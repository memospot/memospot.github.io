# https://just.systems
#
# Run `just` in the root of the project to see a list of recipes relevant to manual builds.

set script-interpreter := ['bash', '-euo', 'pipefail']

# Backtick commands and recipes without a shebang are executed with the shell set here.
set shell := ['bash', '-c']

export REPOSITORY := justfile_directory()
export BIOME_CONFIG_PATH := join(REPOSITORY, 'biome.jsonc')
export DPRINT_CACHE_DIR := join(REPOSITORY, '.dprint')

[private]
[script]
_default:
    echo "REPO_ROOT is ${REPOSITORY}"
    deps=(
        bun
        biome
        dprint
        git
    )
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "{{ RED }}ERROR:{{ NORMAL }} Please install {{ MAGENTA }}{{ BOLD }}{{ UNDERLINE }}$dep{{ NORMAL }}."
            exit 1
        fi
    done
    echo -e "{{ GREEN }}Found project dependencies: ${deps[@]}{{ NORMAL }}"
    echo -e "{{ YELLOW }}If you experience any errors, consider updating the related tool.{{ NORMAL }}\n"
    just --list

[private]
deps:
    bun install

# Install prek Git hooks (run once after clone)
hooks:
    #!/usr/bin/env bash
    if ! command -v prek &> /dev/null; then
        echo -e "{{ RED }}ERROR:{{ NORMAL }} prek is not installed."
        echo -e "Install it with: {{ MAGENTA }}brew install prek{{ NORMAL }}"
        exit 1
    fi
    prek install --prepare-hooks
    echo -e "{{ GREEN }}Git hooks installed.{{ NORMAL }}"

# Run prek hooks on all files
hooks-run:
    prek run --all-files

# Run in development mode. Use --host to make it accessible on the local network.
dev ARGS='': deps
    bun astro dev {{ ARGS }}

# Preview the built page. Use --host to make it accessible on the local network.
[script]
preview ARGS='':
    bun astro build
    bun astro preview {{ ARGS }}

# Build
build ARGS='': deps
    bun astro build {{ ARGS }}

# Update project dependencies
[confirm('This will update all dependencies. This should be done carefully. Are you sure?')]
[group('update')]
update: update-dprint update-ts

# Update dprint plugins
[group('update')]
update-dprint:
    dprint config update

# Update npm packages
[group('update')]
update-ts:
    bun update
    just fmt

# Show outdated npm packages
[group('update')]
outdated:
    bun outdated

# Upgrade bun
[group('update')]
upgrade:
    bun upgrade

# Clean project artifacts
[script]
clean:
    set +e
    bun pm cache rm
    dirs=(
        "./.dprint"
        "./.astro"
        "./dist"
        "./node_modules"
    )
    for item in "${dirs[@]}"; do
        test -d "$item" && rm -rf "$item"
    done

# Run all code linters
[group('lint')]
lint: lint-dprint lint-ts

# Check code formatting
[group('lint')]
lint-dprint:
    dprint check

# Lint TypeScript code with BiomeJS
[group('lint')]
lint-ts:
    bun x @biomejs/biome ci --css-parse-tailwind-directives=true .

# Run BiomeJS safe fixes
[group('fix')]
fix:
    bun x @biomejs/biome lint --write .

# Format code with dprint (json, yaml, astro, css, javascript/typescript and markdown)
[group('format')]
fmt:
    dprint fmt

# Do a full validation before pushing
validate: lint-dprint lint build

# Concise version of validate
@gate:
    just validate >/dev/null 2>&1 && echo "[OK] All validations passed." || echo "[ERROR] Run 'just validate' for more details."

# Delete all GitHub Actions cache
[group('maintainer')]
gh-clean-cache:
    gh cache delete --all
