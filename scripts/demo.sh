#!/usr/bin/env bash
# Hermetic engine demo: check + deliver with a trusted command. No model.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== check =="
uv run satyrn-engine check --repo . contracts/greeting.yaml
echo "check OK"

echo "== deliver =="
rm -f greeting.txt
RECEIPT=$(uv run satyrn-engine deliver --repo . contracts/greeting.yaml -- \
  python -c 'from pathlib import Path; Path("greeting.txt").write_text("hello\n")')
echo "$RECEIPT"
echo "$RECEIPT" | python3 -c "import json,sys; r=json.load(sys.stdin); assert r['outcome']=='candidate-created', r; print('receipt OK:', r['code'], r['candidate_ref'])"

echo "== candidate =="
git show "refs/satyrn/candidates/greeting/head" --stat | head -10
git update-ref -d "refs/satyrn/candidates/greeting/head"
rm -f greeting.txt
echo "demo OK"
