# Configuration

Though there's no need for a regular user to ever touch this file,
some of the Memospot behavior can be configured via `memospot.yaml`.

## Configuration location

- Linux/macOS:

```Shell
~/.memospot/memospot.yaml
```

> Optional locations (if moved manually by the user):
>
> ```Shell
>    $XDG_CONFIG_HOME/memospot/memospot.yaml
> ```
> ```Shell
>    ~/.config/memospot/memospot.yaml
> ```

- Windows:

    - Explorer:

        ```Shell
        %LocalAppData%\memospot\memospot.yaml
        ```

    - Powershell:

      ```Shell
      $Env:LocalAppData\memospot\memospot.yaml
      ```

## Sample configuration file

The fields that default to `null` are detected at runtime.

```yaml
memos:
  # Memos data storage. Where the database and assets are stored.
  #
  # This setting allows you to change the data storage (database,
  # assets, and thumbnails) to a folder synced by a cloud storage 
  # provider client, like OneDrive, Dropbox, Google Drive, etc.
  data: null

  # Use this to spawn a custom Memos binary.
  binary_path: null

  # Memos working directory. This is where the `dist` folder
  # must reside (from v0.18.2 to v0.21.0).
  working_dir: null

  # Mode: [prod] | dev | demo. This changes the database file in use.
  mode: prod

  # Address where Memos will listen for connections.
  # Listening to 127.0.0.1 won't trigger Windows Firewall, and the
  # server instance will only be accessible from the host computer.
  # This is the default.
  #
  # Listening to 0.0.0.0 will make the server available 
  # at all your computer's network adapters addresses
  # if it's allowed by the Firewall.
  addr: 127.0.0.1

  # Memos' port. Managed by Memospot. You can set a custom port,
  # but it will be automatically changed if the port is in use
  # during Memospot startup.
  port: 0

  # Custom environment variables for Memos. 
  # Custom keys will be automatically uppercased  
  # and prefixed with "MEMOS_".
  # Make sure to always quote custom env values, 
  # so they get parsed as strings.
  # env:
  #   NEW_ENV_VAR: "my value"
  env: null

memospot:
  backups:
    # Enable backups [true]. Currently, backups only run before
    # database migrations and there's no retention management.
    enabled: true
    # Backup directory.
    path: null

  migrations:
    # Enable migrations [true]. These are database
    # migrations that make upgrading Memos smoother.
    enabled: true

  log:
    # Enable logging [false]. Used for advanced debugging.
    # A new file called `logging_config.yaml` will be created next 
    # to this file upon the next Memospot run.
    # Then, you can edit `logging_config.yaml` changing `root.level`
    # from `info` to `debug` to increase the logging level.
    enabled: false

  remote:
    # Use Memospot as a client for a remote Memos server [false].
    # - Added in v0.1.6.
    # The URL must point to a valid Memos server, using HTTP or HTTPS.
    # Other web apps most likely won't pass the internal health check.
    enabled: false
    url: https://demo.usememos.com/

  updater:
    # Enable auto-updater [true].
    # - Added in v0.1.7.
    enabled: true

  window:
    # Window properties.
    # - Added in v0.1.7.
    # Managed variables store the previous state upon app close.

    # Whether the window should be centered upon creation. [true]
    center: true

    # Whether the window should be fullscreen upon creation. [false]
    fullscreen: false

    # Whether the window should be resizable upon creation. [true]
    resizable: true

    # (Managed) Whether the window should be maximized upon creation.
    maximized: false

    # (Managed) Window initial width.
    width: 0

    # (Managed) Window initial height.
    height: 0

    # (Managed) Window initial x position.
    x: 0

    # (Managed) Window initial y position.
    y: 0
```