# Contributing

[Memospot](https://github.com/lincolnthalles/memospot) contributor's guide.

The recommended code editor is
[Visual Studio Code](https://code.visualstudio.com/). The project has a
pre-configured workspace, which will prompt you to install the recommended
extensions.

> This project's workflow is heavily based on
> [Task](https://taskfile.dev/installation), a modern alternative to Makefiles
> and scripts.
>
> A `Taskfile` is available with lots of pre-configured [tasks](#using-task) for
> this project. {style="note"}

## Pre-requisites

- [Task](https://taskfile.dev/#/installation)
- A package manager: [Homebrew](https://brew.sh/),
  [Chocolatey](https://chocolatey.org/install#individual),
  [winget](https://docs.microsoft.com/windows/package-manager/winget/) or
  [Scoop](https://scoop.sh/).
- A system WebView (Edge
  [WebView2](https://go.microsoft.com/fwlink/p/?LinkId=2124703), Safari, or
  WebkitGTK), for Tauri to work.
- A modern computer, with at least 8 GB of RAM and a decent CPU. Rust
  compilation is very CPU-intensive. Also, `rust-analyzer` (language server)
  utilizes circa 2GB of RAM.
- 20 GB of free disk space on the repository drive, for Rust artifacts and
  `sccache`.

## Toolchain setup

After fulfilling the basic pre-requisites, open a terminal, cd into the project
directory and run `task setup` to _try to_ set up the project toolchain.

```Shell
task setup
```

If some step fails, you can follow the [manual setup guide](#manual-setup) to
install the tools by yourself.

### Manual setup {collapsible="true" default-state="collapsed"}

#### OS-specific dependencies {collapsible="true" default-state="collapsed"}

See also:
[Tauri Prerequisites](https://tauri.app/v1/guides/getting-started/prerequisites/)

##### Linux

```bash
sudo apt update -y &&
sudo apt install -y \
  build-essential \
  curl \
  wget \
  file \
  libgtk-3-dev \
  librsvg2-dev \
  libssl-dev \
  libwebkit2gtk-4.0-dev \
  patchelf \ 
  libayatana-appindicator3-dev
```

> Depending on your distro, `libayatana-appindicator3` may conflict with
> `libappindicator3-dev`. Both are valid for Tauri, and it's ok to ignore the
> error.

##### macOS

```bash
xcode-select --install
```

##### Windows

[Build Tools for Visual Studio 2022](https://visualstudio.microsoft.com/visual-cpp-build-tools/)

```Shell
winget install --id=Microsoft.VisualStudio.2022.BuildTools  -e
```

[Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/#download-section)

```Shell
winget install --id=Microsoft.EdgeWebView2Runtime  -e
```

#### Project dependencies {collapsible="true" default-state="collapsed"}

> After installing a tool, make sure it is available in your system PATH
> environment variable.
>
> Open a new terminal window and try to run the tool from there. If it doesn't
> work, read the tool's installation instructions and setup's output
> thoroughly.{style="warning"}

##### Bun

Bun is a fast JavaScript/TypeScript runtime, bundler, test runner, and package
manager. It's used to bundle the front end and to run build scripts.

- [Official Website](https://bun.sh)
- [GitHub](https://github.com/oven-sh/bun)

> After the installation, make sure Bun works from any terminal window.
>
> `bun --version`

##### Rust

Rust is used to build the Tauri app.

- [Rustup](https://rustup.rs/)
- [Official Website](https://www.rust-lang.org/tools/install)

Run `rustup default stable` to install the latest stable toolchain.

> After the installation, make sure `rustc` and `cargo` works in any terminal.
>
> `rustc --version`
>
> `cargo --version`

##### Extra Rust tools

- [clippy](https://github.com/rust-lang/rust-clippy): A collection of lints to
  catch common mistakes and improve Rust code.
- [sccache](https://github.com/mozilla/sccache): Used to speed up Rust builds.
- [dprint](https://github.com/dprint/dprint): A pluggable code formatter.
- [cargo-binstall](https://github.com/cargo-bins/cargo-binstall): Binary
  installations for Rust projects.
- [cargo-cache](https://github.com/matthiaskrgr/cargo-cache): Utility to manage
  `cargo` cache.
- [cargo-edit](https://github.com/killercup/cargo-edit): Utility to manage
  `cargo` dependencies.

All of these tools can be installed from source via `cargo install`, though it
will take a while to compile them. It's recommended that you install just
`cargo-binstall` from source and use it to download the other tools binaries.

```bash
rustup component add clippy
cargo install cargo-binstall --locked
cargo binstall tauri-cli@1.5.11 --locked -y
cargo binstall cargo-edit@0.12.2 --locked -y
cargo binstall cargo-cache@0.8.3 --locked -y
cargo binstall dprint@0.45.1 --locked -y
cargo binstall sccache@0.8.0 --locked -y
```

> After the installation, make sure `cargo tauri`, `cargo set-version`, `dprint`
> and `sccache` works in any terminal.
>
> `cargo install` outputs the builds to `$HOME/.cargo/bin` which already should
> be in your PATH.

## Memos server build {collapsible="true" default-state="collapsed"}

The [Memos server](https://github.com/usememos/memos) is built separately on the
repository [memos-builds](https://github.com/lincolnthalles/memos-builds).

A pre-build hook will automatically download the latest release from the
repository and put it in the `server-dist` folder. Downloaded files will be
reused on subsequent builds.

> If you build the server by yourself, you must put the appropriate server
> binary in the `server-dist` folder, so Tauri can bundle it with the app.
>
> Also, server binaries **must** be named using
> [target triples](https://clang.llvm.org/docs/CrossCompilation.html#target-triple).
> {style="warning"}

Sample valid server binary names:

- Windows: `memos-x86_64-pc-windows-msvc.exe`
- Linux: `memos-x86_64-unknown-linux-gnu`
- macOS: `memos-x86_64-apple-darwin` / `memos-aarch64-apple-darwin`

> You can check your current system target triplet with the command `rustc -vV`.
> {style=info}

## Using Task {collapsible="true" default-state="expanded"}

After installing Task and cloning the project repository, you can open a
terminal, `cd` into the project directory and run `task --list-all` to see all
available tasks.

```Shell
task --list-all
```

### Common tasks

- `task dev`: Run the app in development mode.
- `task build`: Build the app.
- `task fmt`: Run all code formatters in parallel.
- `task lint`: Run all code checkers/linters in parallel.
- `task test`: Run all available tests.
- `task clean`: Remove ALL build artifacts and caches.

## Coding style

Use a consistent coding style. Run `task lint`, `task fmt` and `task test` on
the repository before submitting a pull request.

## License

By contributing, you agree that all your contributions will be licensed under
the [MIT License](https://choosealicense.com/licenses/mit/).

In short, when you submit code changes, your submissions are understood to be
under the same _MIT License_ that covers the project. Feel free to contact the
maintainer if that's a concern.
