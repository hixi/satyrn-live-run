#!/usr/bin/env bash
# Model demo: /implement through the locally-installed adapter. Needs backend.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${SATYRN_ENGINE_REPO:?export SATYRN_ENGINE_REPO=\$PWD/../satyrn-engine}"
: "${SATYRN_MODEL:?export SATYRN_MODEL=ollama/ornith-1.5:9b}"

pi install ./node_modules/agent-engine
pi --mode print "/implement Replace the greeting text Files: \`greeting.py\`"
