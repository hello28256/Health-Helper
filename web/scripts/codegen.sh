#!/usr/bin/env bash
# 从后端 OpenAPI spec 生成 TypeScript 类型
# 用法：npm run codegen   （要求后端跑在 :3000）
set -euo pipefail

API_URL="${VITE_API_BASE_URL:-http://localhost:3000}"
OUTPUT="src/types/api.d.ts"

echo "[codegen] 拉取 ${API_URL}/api/docs/openapi.json ..."
curl -sf "${API_URL}/api/docs/openapi.json" -o /tmp/openapi.json

echo "[codegen] 生成 ${OUTPUT} ..."
npx openapi-typescript /tmp/openapi.json -o "${OUTPUT}"

LINES=$(wc -l < "${OUTPUT}")
echo "[codegen] ✓ 完成，${OUTPUT} 共 ${LINES} 行"
