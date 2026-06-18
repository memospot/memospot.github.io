# AGENTS.md

Canonical instructions for AI assistants working on this codebase.

## Overview

Astro + Starlight documentation site for the Memospot project. Content is MDX in `src/content/docs/`. Sidebar is defined in `astro.config.ts`.

## Validation

Run before pushing. Order matters:

```bash
just validate
```

This runs `dprint check` → Biome lint → `bun build`.

Single checks:

- `just lint-dprint` — formatting
- `just lint-ts` — Biome lint
- `just build` — build

Fix formatting: `just fmt`

## Tooling

- **Formatter**: dprint (config: `.dprint.jsonc`). Do NOT use Prettier — dprint's Biome plugin handles JS/TS/JSON, malva handles CSS.
- **Linter**: Biome (config: `biome.jsonc`). Biome's own formatter is disabled; dprint owns formatting.
- **Package manager**: bun (`bun install`, `bun dev`).

## Content

- Docs: `src/content/docs/**/*.mdx`
- Changelogs: pulled from upstream `memospot/memospot` CHANGELOG.md via `starlight-changelogs` plugin
- Adding a new doc page: create the `.mdx` file, then add a sidebar entry in `astro.config.ts`

## Quirks

- Astro files disable some Biome rules (`noUnusedVariables`, `noUnusedImports`, `useConst`, `useImportType`) — see `biome.jsonc` overrides.
- `markup_fmt` dprint plugin is disabled; it breaks Astro formatting.
- Tailwind CSS v4 with `@tailwindcss/vite` plugin — no `tailwind.config.*` file; styles are in `src/styles/`.
