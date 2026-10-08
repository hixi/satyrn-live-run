#!/usr/bin/env bash
# deliver requires a clean tree, so untracked demo residue (.venv,
# node_modules, deliver output) must be ignored or removed first.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== check =="
uv run satyrn-engine check --repo . contracts/greeting.yaml
echo "check OK"

echo "== derive =="
CONTRACT_ERR=$(mktemp)
CONTRACT_OUT=$(uv run satyrn-engine derive --repo . -- 'Replace the greeting text Files: `greeting.py`' 2>"$CONTRACT_ERR")
echo "$CONTRACT_OUT"
CONTRACT=$(sed -n 's/^satyrn-engine: contract //p' "$CONTRACT_ERR")
rm -f "$CONTRACT_ERR"
test -n "$CONTRACT" && test -f "$CONTRACT"
echo "derive OK: $CONTRACT"

echo "== deliver =="
rm -f greeting.txt
RECEIPT=$(uv run satyrn-engine deliver --repo . contracts/greeting.yaml -- \
  python -c 'from pathlib import Path; Path("greeting.txt").write_text("hello\n")')
echo "$RECEIPT"
echo "$RECEIPT" | python3 -c "import json,sys; r=json.load(sys.stdin); assert r['outcome']=='candidate-created', r; print('receipt OK:', r['code'], r['candidate_ref'], 'head_moved:', r['head_moved'])"

echo "== candidate =="
git show "refs/satyrn/candidates/greeting/head" --stat | head -10
git update-ref -d "refs/satyrn/candidates/greeting/head"
rm -f greeting.txt "$CONTRACT"
echo "demo OK"
