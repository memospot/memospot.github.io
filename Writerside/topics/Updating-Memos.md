# Updating Memos

In general, you should download and install new versions of Memospot when they
are [released](https://github.com/memospot/memospot/releases). They come bundled with the latest tested Memos server version, being the easiest and safest
way to update.

> An auto-updater was introduced in v0.1.7, but it's not fully functional on all platforms.

## Standalone update

While a standalone server update works in most cases, manual updates are
strongly discouraged for anything other than a **Patch** version release.


<note>

The semantic version scheme used by Memos is `Major.Minor.Patch`.

</note>

<warning>
Standalone updates can break things due to database and API changes
that occur between Major and Minor versions, which Memospot may not yet be prepared to handle.

If that's the case, you won't be able to revert the server binary to a
previous working version without also reverting to a database backup matching the server
version.

</warning>

## Script-aided procedure

For convenience, there are server updater scripts with auto-backup
capabilities.

#### Windows {collapsible="true" default-state="collapsed"}

Open PowerShell and run the following command:

```Shell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/memospot/memospot/main/memos-server-updater.ps1'))
```

You can check the script source [here.](https://github.com/memospot/memospot/blob/main/memos-server-updater.ps1)


<note>

You must run PowerShell as Admin if you are using Memospot `MSI` installers,
as they do a system-wide installation.

This is **not** necessary when using the NSIS/exe installer,
as it only installs the application for the current user.

</note>

#### Linux/macOS {collapsible="true" default-state="collapsed"}

Open a terminal and run the following command:

```Shell
curl -fsSL https://raw.githubusercontent.com/memospot/memospot/main/memos-server-updater.sh | sudo bash
```

You can check the script source [here.](https://github.com/memospot/memospot/blob/main/memos-server-updater.sh)


<note>

The script can take an optional argument to specify a tag to update to.

E.g. `…memos-server-updater.sh | sudo bash -s v0.21.0`

</note>

<tip>

On Linux, you must run the script with `sudo`, as the Memospot package installs Memos to `/usr/bin/`.

</tip>

## Manual procedure

The basic server update process is to download the latest Memos release from
the [memos-builds](https://github.com/memospot/memos-builds/releases) repository and
replace the `memos` binary in the installation folder.

<warning>

Do not proceed without taking a backup of your database.

Close Memospot, copy the `memos` server binary and the `memos_prod.db`
database file(s) to a location outside your working scope for extra safety.

</warning>

Memos location:

- Linux: `/usr/bin/memos`
- macOS: `/Applications/Memospot.app/Contents/MacOS/memos`
- Windows MSI: `%ProgramFiles%\Memospot\memos.exe`
- Windows NSIS: `%LocalAppData%\Memospot\memos.exe`

<tip>

For Linux and macOS, remember to `chmod +x` the `memos` binary after replacing it.

</tip>

#### From Memos v0.18.2 to v0.21.0 {collapsible="true" default-state="collapsed"}

<tip>

This only applies to this version range, where the web front end wasn't
embedded.

</tip>

The downloaded build contains a `dist` folder (the web front end). You must
place it in the appropriate folder:

- Linux: `/usr/lib/memospot/`
- macOS: `$HOME/Library/Application Support/com.memospot.app/`
- Windows `%LocalAppData%\memospot`
