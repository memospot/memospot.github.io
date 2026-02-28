# https://just.systems
#
# Run `just` in the root of the project to see a list of recipes relevant to manual builds.

set script-interpreter := ['bash', '-euo', 'pipefail']
# Backtick commands and recipes without a shebang are executed with the shell set here.
set shell := ['bash', '-c']
set windows-shell := ['powershell', '-Command']
set dotenv-load := true

GIT_WIN := join(env('PROGRAMFILES',''), 'Git','usr','bin')
REPO_ROOT := justfile_directory()

export PATH := if os() == 'windows' { GIT_WIN +';'+ env('PATH') } else { env('PATH') }
export BIOME_CONFIG_PATH := join(REPO_ROOT,'biome.jsonc')
export DPRINT_CACHE_DIR := join(REPO_ROOT,'.dprint')

[private]
[script]
_default:
    echo "REPO_ROOT is ${REPO_ROOT}"
    if [ "{{os()}}" = "windows" ]; then
        git_win="{{replace(GIT_WIN, '\\', '\\\\')}}"
        echo -e "To use this justfile on Windows, make sure Git is installed under {{BOLD}}{{UNDERLINE}}$git_win{{NORMAL}}."
        echo -e "{{BOLD}}{{UNDERLINE}}https://git-scm.com/download/win{{NORMAL}}"
        echo ""
    fi
    deps=(
        bun
        biome
        dprint
        git
        jq
    )
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "{{RED}}ERROR:{{NORMAL}} Please install {{MAGENTA}}{{BOLD}}{{UNDERLINE}}$dep{{NORMAL}}."
            echo -e "Try running {{BOLD}}{{UNDERLINE}}just setup{{NORMAL}}."
            exit 1
        fi
    done
    echo -e "{{GREEN}}Found project dependencies: ${deps[@]}{{NORMAL}}"
    echo -e "{{YELLOW}}If you experience any errors, consider updating the related tool.{{NORMAL}}\n"
    just --list

[private]
deps:
    bun install

[doc('Run in development mode. Use --host to make it accessible on the local network.')]
dev ARGS='': deps
    bun astro dev {{ARGS}}

[script]
[doc('Preview the built page. Use --host to make it accessible on the local network.')]
preview ARGS='':
    bun astro build
    bun astro preview {{ARGS}}

[doc('Build')]
build ARGS='': deps
    bun astro build {{ARGS}}

[group('update')]
[doc('Update project dependencies')]
[confirm('This will update all dependencies. This should be done carefully. Are you sure?')]
update: update-dprint update-ts

[group('update')]
[doc('Update dprint plugins')]
update-dprint:
    dprint config update

[group('update')]
[doc('Update npm packages')]
update-ts:
    bun update
    just fmt

[group('update')]
[doc('Show outdated npm packages')]
outdated:
    bun outdated

[group('update')]
[doc('Upgrade bun')]
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

[group('lint')]
[doc('Run all code linters')]
lint: lint-dprint lint-ts

[group('lint')]
[doc('Check code formatting')]
lint-dprint:
    dprint check

[group('lint')]
[doc('Lint TypeScript code with BiomeJS')]
lint-ts:
    bun x @biomejs/biome ci --css-parse-tailwind-directives=true .

[group('fix')]
[doc('Run all code fixes')]
fix: fix-ts

[group('fix')]
[doc('Run BiomeJS safe fixes')]
[script]
fix-ts:
    cd ./src || exit 1
    if ls *.ts 1> /dev/null 2>&1; then
        bun x @biomejs/biome lint --write .
    fi

[group('format')]
[doc('Format code with dprint (json, yaml, astro, css, javascript/typescript and markdown).')]
fmt:
    dprint fmt --diff

[doc('Run all recommended pre-commit checks')]
pre-commit: fmt lint

[group('maintainer')]
[doc('Delete all GitHub Actions cache')]
gh-clean-cache:
    gh cache delete --all

[group('maintainer')]
[doc('Bump version in package.json')]
[script]
bumpversion VERSION:
    clean="{{trim_start_match(VERSION, "v")}}"
    jq --arg version "$clean" '.version = $version' "./package.json" > "./package.json.tmp" && mv "./package.json.tmp" "./package.json"
    just fmt
    bun install --lockfile-only
    git add ./package.json
    git commit -m "chore: bump version to v$clean"

[group('maintainer')]
[doc('Push a new tag to the repository')]
[script]
pushtag TAG:
    clean="{{trim_start_match(TAG, "v")}}"
    git tag -a "v$clean" -m "chore: push v$clean"
    git push origin --tags

[group('maintainer')]
[doc('Publish a new version (bumpversion + pushtag)')]
publish TAG:
    just bumpversion {{TAG}}
    just pushtag {{TAG}}
