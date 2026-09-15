# Contributing to memospot.github.io

This repository hosts the Memospot landing page and documentation, built with
[Astro](https://astro.build/) and [Starlight](https://starlight.astro.build/).

> Looking for the Memospot application itself? See
> [memospot/memospot](https://github.com/memospot/memospot) and its
> [contributing guide](https://memospot.github.io/guides/contributing/).

## Prerequisites

| Tool                                 | Purpose                   |
| :----------------------------------- | :------------------------ |
| [Bun](https://bun.sh/)               | JavaScript runtime and PM |
| [Just](https://just.systems/)        | Command runner            |
| [dprint](https://dprint.dev/)        | Code formatter            |
| [prek](https://github.com/j178/prek) | Git hook manager          |
| [Git](https://git-scm.com/)          | Version control           |

With [Homebrew](https://brew.sh/):

```bash
brew install oven-sh/bun/bun just dprint prek
```

Biome (the linter) is managed as a project dependency; no separate install is
needed once `bun install` has run.

## Setup

```bash
git clone https://github.com/memospot/memospot.github.io.git
cd memospot.github.io
bun install
just hooks # Install the prek Git hooks (run once after clone)
```

## Common commands

Run `just` in the project root to list all recipes, or `just --list`.

| Command        | Action                                   |
| :------------- | :--------------------------------------- |
| `just dev`     | Start the dev server at `localhost:4321` |
| `just build`   | Build the production site to `./dist/`   |
| `just preview` | Build, then preview the built site       |
| `just fmt`     | Format all files with dprint             |
| `just lint`    | Check formatting and run Biome lint      |
| `just fix`     | Apply Biome safe fixes                   |
| `just clean`   | Remove build artifacts and caches        |

## Before you push

```bash
just validate
```

This runs the formatting check, Biome lint, and a production build — the same
checks that run in CI. Run `just fmt` first if formatting is failing; it
rewrites files in place.

The prek hooks run the formatting and lint checks on every commit, so most
issues are caught before they reach CI.

## Documentation content

- Edit MDX pages under `src/content/docs/`.
- Add every new page to the sidebar in `astro.config.ts`.
- Do not duplicate the upstream `memospot/memospot` changelog locally; it is
  collected through `src/content.config.ts`.

## Deployment

Pushes to `main` are built and deployed to GitHub Pages automatically by
`.github/workflows/deploy.yml`. Pull requests and other branches are checked by
CI (formatting, lint, build) but are never deployed.

## Pull requests

Contributions are human-curated: please open pull requests manually, one
focused change per PR. By contributing, you agree that your contributions are
licensed under the [Blue Oak Model License 1.0.0](https://choosealicense.com/licenses/blueoak-1.0.0/).

Maintainers of AI coding assistants should also read [AGENTS.md](AGENTS.md).
