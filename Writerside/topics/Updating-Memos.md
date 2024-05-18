# Updating Memos

In general, you should download and install new versions of Memospot when they
are [released](https://github.com/memospot/memospot/releases). They come
bundled with the latest tested Memos version.

> An auto-updater is planned, but it's not yet available.

> The semantic version scheme is `Major.Minor.Patch`. {style=note}

## Standalone server update {collapsible="true" default-state="expanded"}

> Standalone server updates can break things due to database and API changes
> that occur between Major and Minor versions.
>
> If that's the case, you won't be able to revert the server binary to a
> previous version without reverting to a database backup matching the server
> version. {style=warning}

### Script-aided procedure {collapsible="true" default-state="collapsed"}

#### Windows

For convenience, there's an automatic server updater-script with auto-backup
capabilities.

Open PowerShell and run the following command:

```Shell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/memospot/memospot/main/memos-server-updater.ps1'))
```

> You can check the script source
> [here.](https://raw.githubusercontent.com/memospot/memospot/main/memos-server-updater.ps1)
> {style=note}

> You must run PowerShell as Admin if you are using Memospot `MSI` installers.
>
> This is **not** needed using the `NSIS`/`exe` installer. {style=warning}

### Manual procedure {collapsible="true" default-state="collapsed"}

> While a standalone server upgrade works in most cases, manual updates are
> strongly discouraged for anything other than **Patch** version upgrades.

> Do not proceed without taking a backup of your database.
>
> Close Memospot and copy the `memos` server binary and the `memod_prod`
> database file(s) to a location outside your working scope for extra safety.
> {style="warning"}

The basic update process is to download the latest Memos' server release from
[memos-builds](https://github.com/memospot/memos-builds/releases) and
replace the `memos` binary in the Memospot installation folder.

#### From Memos v0.18.2 to v0.21.0 {collapsible="true" default-state="collapsed"}

**This only applies to this version range, where the web front end wasn't
embedded.**

The downloaded build contains a `dist` folder (the web front end). You must
place it in the appropriate folder:

- Linux: `/usr/lib/memospot/`
- macOS: `$HOME/Library/Application Support/com.memospot.app/`
- Windows `%LocalAppData%\memospot`
