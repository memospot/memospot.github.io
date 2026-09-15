# AGENTS.md

Canonical instructions for AI assistants working on this codebase.

## Overview

Single-package Astro + Starlight site for the Memospot landing page and documentation.
Edit MDX content under `src/content/docs/`; configure Starlight navigation and integrations in `astro.config.ts`.
Treat this repository as one package rooted here; no nested package or tooling scopes are present.

## Non-negotiable

Never create GitHub issues or pull requests. This project only accepts manual human-curated contributions. If asked, inform and stop.

## Commands

Run commands from the repository root.

Use `CONTRIBUTING.md` for contributor setup, Git hook onboarding, and the pre-push checklist.

Before pushing, run:

```bash
just validate
```

`just validate` depends on `lint-dprint`, the `lint` recipe (dprint `check` then Biome `ci`), and `build` (`bun astro build`).
`just fmt` (`dprint fmt`) is a separate recipe that rewrites files in place; run it first when a
formatting check fails, then inspect the resulting diff.

Focused checks:

- `just lint-dprint` — check dprint formatting
- `just lint-ts` — run Biome lint
- `just fix` — apply Biome safe fixes with `bun x @biomejs/biome lint --write .`
- `just build` — build the site
- `just fmt` — apply dprint formatting

Development and preview:

- `bun dev` or `just dev`
- `bun run build`
- `bun preview` or `just preview`
- `just hooks` — install the prek Git hooks (run once after clone)

For dependency updates, use `bun update {package}@{version}` after checking `bun outdated`; do not edit `package.json` or `bun.lock` by hand.
For dprint plugin updates, run `dprint config update`, then `dprint check`.

## Structure

- `src/content/docs/**/*.mdx` — documentation pages; add every new page to the sidebar in `astro.config.ts`.
- `src/content/docs/index.mdx` — splash landing page; its `hero` frontmatter is rendered by `src/components/Hero.astro`.
- `src/content.config.ts` — docs schema and the upstream changelog loader.
- `src/styles/*.css` — custom CSS; register stylesheet paths in `astro.config.ts`.
- `public/` — static site assets.

## Quirks and constraints

- Use dprint with `.dprint.jsonc`; it includes `.js` and `.mjs` and associates them with Biome. Do not use Prettier. Biome's formatter is disabled, so use Biome only for linting.
- Do not add jq or dotenv-load assumptions to `just` recipes; `justfile` currently uses neither.
- Treat root `prek.toml` as the Git hook configuration. Its dprint and Biome hooks call `just lint-dprint` and `just lint-ts`; both match `.js` and `.mjs`. After editing it, run `prek validate-config` then `prek run --all-files`.
- Astro files override Biome's `noUnusedVariables`, `noUnusedImports`, `useConst`, and `useImportType` rules; do not apply generic Biome fixes to those rules in `.astro` files.
- Tailwind CSS v4 is wired through `@tailwindcss/vite`; do not create a `tailwind.config.*` file. Put custom styles in `src/styles/`.
- `bunfig.toml` enforces exact versions, a frozen lockfile, a seven-day minimum release age, and ignored install scripts. Use Bun's update workflow for dependency changes.
- The changelog collection reads upstream `memospot/memospot` changelog data through `src/content.config.ts`; do not duplicate that feed as local documentation.
- `.github/workflows/deploy.yml` builds and deploys on pushes to `main` and on manual dispatch;
  CI (`ci.yml`) runs `fmt` (`just lint-dprint`), `lint` (`just lint-ts`), and `build` (`just build`) jobs, with path filters that include `justfile`, `.js`, and `.mjs`.
- Do not commit `dist/`, `.astro/`, `.dprint/`, or `node_modules/`; these generated directories are ignored by `.gitignore`.
