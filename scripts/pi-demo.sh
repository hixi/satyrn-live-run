#!/usr/bin/env bash
# Model demo: /implement through the locally-installed adapter. Needs backend.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${SATYRN_ENGINE_REPO:?export SATYRN_ENGINE_REPO=\$PWD/../satyrn-engine}"
: "${SATYRN_MODEL:?export SATYRN_MODEL=ollama/ornith-1.5:9b}"

pi install ./node_modules/agent-engine

echo "== derive (print mode waits for --go) =="
OUT=$(pi --mode print "/implement Replace the greeting text Files: \`greeting.py\`")
echo "$OUT"
ID=$(printf '%s\n' "$OUT" | grep -oE 'implement-[0-9a-f]{12}' | head -1 || true)
: "${ID:?no contract id in /implement output}"

echo "== go =="
pi --mode print "/implement --go $ID"
