#!/usr/bin/env bash
# scripts/codegen.sh —— 后端 OpenAPI → Dart 生成
#
# 单一事实源：后端跑在 localhost:3000，OpenAPI 暴露在 /api/docs/openapi.json
# 与 web/ 共用同一份 spec（web/ 用 openapi-typescript，mobile 用 openapi_generator_cli）
#
# 使用：
#   1. 确保后端在跑：cd /Users/yangq/Codes/Health-Helper && npm run dev
#   2. 在 mobile/ 下跑：bash scripts/codegen.sh
#
# 输出：
#   mobile/lib/api/generated/api.dart      ← ApiClient 入口
#   mobile/lib/api/generated/model/        ← 所有 schema 的 model 类

set -euo pipefail

# ===== 配置 =====
API_BASE_URL="${API_BASE_URL:-http://localhost:3000}"
SPEC_URL="${API_BASE_URL}/api/docs/openapi.json"
OUTPUT_DIR="$(cd "$(dirname "$0")/.." && pwd)/lib/api/generated"
TMP_SPEC="$(mktemp -t openapi-XXXXXX.json)"

# openapi-generator 命令可能在 PATH 里；不在就 fallback
OPENAPI_GEN_BIN="${HOME}/.pub-cache/bin/openapi-generator"
if [[ ! -x "${OPENAPI_GEN_BIN}" ]]; then
  OPENAPI_GEN_BIN="$(command -v openapi-generator || true)"
fi
if [[ -z "${OPENAPI_GEN_BIN}" ]]; then
  echo "[codegen] ✗ openapi-generator 不在 PATH。先跑："
  echo "    dart pub global activate openapi_generator_cli"
  echo "    export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
  exit 1
fi

echo "[codegen] fetching ${SPEC_URL}..."
curl -sf -o "${TMP_SPEC}" "${SPEC_URL}"
echo "[codegen] spec size: $(wc -c < "${TMP_SPEC}") bytes"

# ===== 跑 openapi_generator_cli =====
# generator: dart-dio（与 dio client 对齐）
echo "[codegen] running openapi-generator..."
"${OPENAPI_GEN_BIN}" generate \
  --input-spec "${TMP_SPEC}" \
  --generator-name dart-dio \
  --output "${OUTPUT_DIR}" \
  --additional-properties "pubName=health_helper_api,useDioForMultipart=true,sortParams=true"

rm -f "${TMP_SPEC}"

echo "[codegen] ✓ generated → ${OUTPUT_DIR}"
echo "[codegen] next: flutter pub get && dart run build_runner build --delete-conflicting-outputs"
