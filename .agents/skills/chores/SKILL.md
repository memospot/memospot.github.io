---
name: chores
description: Handle repeatable repository maintenance chores. Use when the user asks for version bumps, updates or similar.
disable-model-invocation: false
user-invocable: true
---

# memospot.github.io chores

## Bun package bumps

Use these steps when asked to bump Bun/npm package versions.

1. Check the latest version of the package

   ```bash
   bun outdated
   ```

   > This automatically enforces the `minimumReleaseAge` from `bunfig.toml`.

2. Update each package with the version shown in the "Latest" column:

   ```bash
   bun update {package}@{version}
   ```

   > This will properly update the package version in `package.json` and `bun.lock`.
   > Do not update by editing `package.json` directly.

3. Validate

   ```bash
   bun run build
   ```

   Inspect the output for errors or warnings. Solve them if possible.

## Dprint plugin bumps

1. Update plugins

   ```bash
   dprint config update
   ```

2. Validate

   ```bash
   dprint check
   ```

## Commit

IF everything works and a commit is requested, use a short commit message in this format:

    ````text
    chore(deps): bump {npm/dprint} deps

    - {package}: {old version} to {new version}
    - {package}: {old version} to {new version}
    ```

Split npm and dprint updates into separate commits.
