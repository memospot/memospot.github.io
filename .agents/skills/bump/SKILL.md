---
name: bump
description: Version bump checklists for npm/Bun and dprint plugins.
disable-model-invocation: true
user-invocable: true
---

# memospot.github.io chores

## Bun package bumps

1. Check outdated packages

   ```bash
   bun outdated
   ```

   > `minimumReleaseAge` from `bunfig.toml` is enforced automatically.

2. Update each package to the version shown in the "Latest" column

   ```bash
   bun update {package}@{version}
   ```

   > Do NOT edit `package.json` directly — `bun update` handles both `package.json` and `bun.lock`.

3. Validate — build must pass clean

   ```bash
   bun run build
   ```

   **Done when**: build succeeds with no new errors or warnings. If a warning has an upstream cause, leave a TODO and proceed.

## Dprint plugin bumps

1. Update plugins

   ```bash
   dprint config update
   ```

2. Validate

   ```bash
   dprint check
   ```

   **Done when**: zero formatting differences reported.

## Commit

When a commit is requested, use short messages in this format.
Split npm and dprint updates into separate commits.

```text
chore(deps): bump {npm/dprint} deps

- {package}: {old version} to {new version}
- {package}: {old version} to {new version}
```
