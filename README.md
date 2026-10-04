# satyrn-live-run

Run `satyrn-engine` from the current checkout, installed as a versioned
dependency overridden to a local path. Mimics the future where the engine
is on PyPI / npm; for now both resolve to `../satyrn-engine`.

## Setup

```bash
uv sync
npm install
```

`uv` resolves `satyrn-engine>=0.1.0` via `[tool.uv.sources]` to
`../satyrn-engine` (editable). `npm` resolves `agent-engine` via
`file:../satyrn-engine/packages/engine`.

## Hermetic demo (no model, no network)

```bash
./scripts/demo.sh
```

Runs `check`, `derive --help` shape check, and `deliver` with a trusted
`python -c` command. Verifies the receipt and the candidate ref.

## Model demo (needs backend)

```bash
export SATYRN_ENGINE_REPO=$PWD/../satyrn-engine
export SATYRN_MODEL=ollama/ornith-1.5:9b
./scripts/pi-demo.sh
```

Installs the adapter once (`pi install ./node_modules/agent-engine`)
and dispatches `/implement` in print mode.
