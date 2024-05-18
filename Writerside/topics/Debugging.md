# Debugging

> This is intended for advanced users only.

There's a built-in logger that can help diagnose some issues.

## yq

Yq is a portable YAML, JSON, XML, CSV, TOML and properties processor. It's a
convenient way to edit configuration files from the command line.

> [yq](https://github.com/mikefarah/yq) is available at several package
> managers: Homebrew, MacPorts, Winget, Chocolatey and Scoop.

## Enabling logging {collapsible="true" default-state="collapsed"}

### Using yq {collapsible="true" default-state="expanded"}

- Linux/macOS:

  ```bash
  yq -i '.memospot.log.enabled = true' "~/.memospot/memospot.yaml"
  ```

- Windows:
  ```bash
  yq -i '.memospot.log.enabled = true' "$Env:LocalAppData\memospot\memospot.yaml"
  ```

### Manually editing `memospot.yaml` {collapsible="true" default-state="collapsed"}

```yaml
memospot:
  log:
    enabled: true
```

## Increasing log level {collapsible="true" default-state="collapsed"}

### Using yq {collapsible="true" default-state="expanded"}

- Linux/macOS:

  ```bash
  yq -i '.root.level = "debug"' "~/.memospot/logging_config.yaml"
  ```

- Windows:
  ```bash
  yq -i '.root.level = "debug"' "$Env:LocalAppData\memospot\logging_config.yaml"
  ```

### Manually editing `logging_config.yaml` {collapsible="true" default-state="collapsed"}

```yaml
root:
  level: debug
```

## Disabling logging {collapsible="true" default-state="collapsed"}

> It's recommended to disable logging when not needed.
>
> {style="note"}

- Linux/macOS:

  ```bash
  yq -i '.memospot.log.enabled = false' "~/.memospot/memospot.yaml"
  rm ~/.memospot/logging_config.yaml
  ```

- Windows:
  ```bash
  yq -i '.memospot.log.enabled = false' "$Env:LocalAppData\memospot\memospot.yaml"
  Remove-Item "$Env:LocalAppData\memospot\logging_config.yaml"
  ```

### Manually editing `memospot.yaml` {collapsible="true" default-state="collapsed"}

```yaml
memospot:
  log:
    enabled: false
```

## Default `logging_config.yaml` {collapsible="true" default-state="collapsed"}

> If you launch Memospot with an empty or invalid logging_config.yaml, the file
> will be automatically populated with a default configuration. {style="note"}

```yaml
appenders:
  file:
    encoder:
      pattern: "{d(%Y-%m-%d %H:%M:%S)} - {h({l})}: {m}{n}"
    path: $ENV{MEMOSPOT_DATA}/memospot.log
    kind: rolling_file
    policy:
      trigger:
        kind: size
        limit: 10 mb
      roller:
        kind: fixed_window
        pattern: $ENV{MEMOSPOT_DATA}/memospot.log.{}.gz
        count: 5
        base: 1
root:
  # debug | info | warn | error | off
  level: info
  appenders:
    - file
```

Extra configurations options can be found in the
[log4rs documentation](https://github.com/estk/log4rs#quick-start)

> For convenience, the `$ENV{MEMOSPOT_DATA}` environment variable is available
> in `logging_config.yaml`.
>
> This resolves to the same directory where `memospot.yaml` resides.
