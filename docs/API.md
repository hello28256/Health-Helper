# Health Helper API

RESTful API for cross-platform (iOS / Android / Web) health tracking.

- **Base URL (dev)**: `http://localhost:3000`
- **Authentication**: JWT Bearer token (access + refresh)
- **Interactive docs**: `http://localhost:3000/api/docs` (Swagger UI)
- **OpenAPI spec**: `http://localhost:3000/api/docs/openapi.json`
- **Source of truth**: `src/docs/openapi.ts`

---

## Quick start

```bash
# 1. Register
curl -X POST http://localhost:3000/api/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "alice@example.com",
    "password": "strong-password-123",
    "deviceId": "iphone-1"
  }'

# Response
{
  "user": { "id": "uuid", "email": "...", ... },
  "accessToken": "eyJ...",
  "refreshToken": "eyJ..."
}

# 2. Use the access token
ACCESS="eyJ..."

curl http://localhost:3000/api/users/me \
  -H "Authorization: Bearer $ACCESS"

# 3. When access token expires, refresh
curl -X POST http://localhost:3000/api/auth/refresh \
  -H 'Content-Type: application/json' \
  -d '{ "refreshToken": "eyJ...", "deviceId": "iphone-1" }'
```

---

## Authentication

| Item | Value |
|------|-------|
| Algorithm | HS256 |
| Access token TTL | 15 min (`JWT_ACCESS_TTL`) |
| Refresh token TTL | 7 days (`JWT_REFRESH_TTL`) |
| Refresh storage | SHA-256 hash only (plain text never stored) |
| Cross-device | Each `deviceId` gets its own refresh token |
| Rotation | Refresh always issues a new pair; old refresh is revoked |
| Logout | Revokes refresh for that device only |

**Cross-device data sync**: log in from iOS, Android, Web with the same email/password but different `deviceId`. All clients see the same data (exercise, diet, mood, steps).

---

## Error format

All errors return:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request body",
    "details": { /* optional, depends on error */ }
  }
}
```

| HTTP | Code | Meaning |
|------|------|---------|
| 400 | `VALIDATION_ERROR` | Zod schema failed; `details` contains field errors |
| 401 | `UNAUTHORIZED` | Missing/invalid access token |
| 404 | `NOT_FOUND` | Resource doesn't exist |
| 409 | `CONFLICT` | E.g. email already registered |
| 429 | `RATE_LIMITED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Unhandled server error |
| 502 | `AI_UPSTREAM_ERROR` | Upstream AI provider failed |
| 503 | `AI_DISABLED` | No AI API key configured |

---

## Endpoints

### Auth — `/api/auth`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/register` | — | Register; returns access + refresh tokens |
| POST | `/login` | — | Login; rotates refresh per device |
| POST | `/refresh` | — | Rotate access + refresh tokens |
| POST | `/logout` | — | Revoke refresh token (idempotent) |

### Users — `/api/users`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/me` | ✓ | Get current user profile |
| PATCH | `/me` | ✓ | Update profile (displayName, heightCm, **weightKg**, birthDate) |

### Exercises — `/api/exercises`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/types` | ✓ | List all exercise types (MET + safety notes) |
| POST | `/` | ✓ | Create exercise record — **calories computed server-side** |
| GET | `/` | ✓ | List user's exercise records (optional `from`, `to`) |

### Steps — `/api/exercises/steps`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/steps` | ✓ | Upsert daily steps (max-value strategy) |
| GET | `/steps/today` | ✓ | Get today's steps |

### Diet — `/api/diet`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/foods` | optional | Search food nutrition library (`q`, `category`, `limit`, `offset`) |
| POST | `/records` | ✓ | Record a meal (servers compute `consumed`) |
| GET | `/records` | ✓ | List diet records in range (`from`, `to` required) |
| GET | `/summary` | ✓ | Daily nutrition summary (default: today) |

### Mood — `/api/mood`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/` | ✓ | Record a mood (8 enum values, optional score 1-10 + note) |
| GET | `/` | ✓ | List mood records (optional `from`, `to`) |
| GET | `/trend` | ✓ | Daily-aggregated trend (`from`, `to` required) |

### Chat — `/api/chat`

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/messages` | ✓ | Send a message; receives AI reply with medical disclaimer |
| GET | `/history` | ✓ | List recent chat messages |

---

## Key design notes

### Server-authoritative calculations

**Never trust the client for `calories` or `consumed` nutrition.**

- Exercise `calories = MET × weightKg × duration(hours)` — MET comes from the exercise type, weight from the user's profile (default 65 kg), duration from the request.
- Diet `consumed.kcal = servings × servingSizeG/100 × kcalPer100g` — all three come from server data.

This prevents tampering and keeps multi-device data consistent.

### Step counter (max-value strategy)

Mobile pedometers sometimes report old data (OS rollback, app restart). The server keeps the **max** value reported for a given date, so re-uploading 5,000 steps when 12,000 was already stored does not regress.

### Refresh token rotation

Every `/api/auth/refresh` issues a new access + refresh pair and immediately revokes the old refresh. If a refresh token is leaked and used, the legitimate user's next refresh will fail (compromise signal). Each `deviceId` has its own refresh, so revoking one device does not affect others.

### Mood enum vs free text

Mood uses a fixed 8-value enum (`happy`, `calm`, `sad`, `anxious`, `angry`, `tired`, `grateful`, `excited`) to keep aggregation consistent across languages and clients. The optional `note` field is free text for personal context.

### AI chat medical disclaimer

The system prompt embeds a mandatory medical disclaimer: the AI is not a doctor, cannot diagnose or prescribe, and must direct crisis cases to local emergency numbers. The full disclaimer lives at `src/services/chatService.ts:12` (`MEDICAL_DISCLAIMER`).

When the server has no `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` configured, the endpoint returns `503 AI_DISABLED` instead of silently failing.

---

## Running locally

```bash
# 1. Start Postgres
docker compose up -d

# 2. Migrate + seed
npm run db:migrate
npm run db:seed

# 3. Start dev server (with hot reload)
npm run dev
# → http://localhost:3000

# 4. Open API docs
# → http://localhost:3000/api/docs
```

See [README.md](../README.md) and [DEPLOY.md](./DEPLOY.md) for full setup.
