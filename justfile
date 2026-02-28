# https://just.systems
#
# Run `just` in the root of the project to see a list of recipes relevant to manual builds.

set script-interpreter := ['bash', '-euo', 'pipefail']

# Backtick commands and recipes without a shebang are executed with the shell set here.

set shell := ['bash', '-c']
set windows-shell := ['powershell', '-Command']
set dotenv-load := true

REPOSITORY := justfile_directory()
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
        jq
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

[doc('Run in development mode. Use --host to make it accessible on the local network.')]
dev ARGS='': deps
    bun astro dev {{ ARGS }}

[doc('Preview the built page. Use --host to make it accessible on the local network.')]
[script]
preview ARGS='':
    bun astro build
    bun astro preview {{ ARGS }}

[doc('Build')]
build ARGS='': deps
    bun astro build {{ ARGS }}

[confirm('This will update all dependencies. This should be done carefully. Are you sure?')]
[doc('Update project dependencies')]
[group('update')]
update: update-dprint update-ts

[doc('Update dprint plugins')]
[group('update')]
update-dprint:
    dprint config update

[doc('Update npm packages')]
[group('update')]
update-ts:
    bun update
    just fmt

[doc('Show outdated npm packages')]
[group('update')]
outdated:
    bun outdated

[doc('Upgrade bun')]
[group('update')]
upgrade:
    bun upgrade

[doc('Clean project artifacts')]
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

[doc('Run all code linters')]
[group('lint')]
lint: lint-dprint lint-ts

[doc('Check code formatting')]
[group('lint')]
lint-dprint:
    dprint check

[doc('Lint TypeScript code with BiomeJS')]
[group('lint')]
lint-ts:
    bun x @biomejs/biome ci --css-parse-tailwind-directives=true .

[doc('Run BiomeJS safe fixes')]
[group('fix')]
[script]
fix:
    cd ./src || exit 1
    if ls *.ts 1> /dev/null 2>&1; then
        bun x @biomejs/biome lint --write .
    fi

[doc('Format code with dprint (json, yaml, astro, css, javascript/typescript and markdown).')]
[group('format')]
fmt:
    dprint fmt --diff

[doc('Do a full validation before pushing')]
validate: fmt lint build

[doc('Delete all GitHub Actions cache')]
[group('maintainer')]
gh-clean-cache:
    gh cache delete --all
