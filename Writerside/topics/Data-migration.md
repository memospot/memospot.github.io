# Data migration

> The current version of Memos stores assets in a portable format.
>
> Data can be seamlessly moved between Memos containers and Memospot instances,
> regardless of the operating system.
> {style=note}

> Assets, resources and objects refer to the same thing.

## Data storage location

- Windows: `%LocalAppData%\memospot`
- Linux/macOS: `~/.memospot` (a hidden folder in the user home)
- Inside Memos container: `/var/opt/memos`
- Memos container host:
    - `~/.memos`
    - `/root/.memos`
    - Near your `docker-compose.yml` file, if you're using it.

> Relevant files:
> - `memos_prod.db`
> - `memos_prod.db-shm` (may not exist)
> - `memos_prod.db-wal` (may not exist)
> - `assets` directory

The `.thumbnail_cache` directory and its contents are generated as needed.

## Migrating data from earlier Memos versions

> None of this is needed if you have never stored assets outside the database or
> if you have used Memospot v0.1.3/v0.1.4 in the past since it contains a
> built-in database migrator.
>
> If that's the case, all your data is already portable. {style=warning}

## Brief history

- Up to Memos v0.18.1, databases and assets were not portable. They pointed to
  absolute paths at the host's file system, and moving data between systems required
  the instructions written on this page.
- Memos v0.18.2 started saving new assets with relative paths, but shipped a
  very slow path migrator for pre-existing assets.
- The asset path migrator was removed from Memos v0.19.1+.
- Memospot v0.1.3/v0.1.4 (bundled with Memos v0.20.0, compatible up to v0.21.0)
  shipped with its own fast asset migrator.

> If you are coming from an old Memos version or skipped v0.18.2 and v0.19.0,
> consider installing
> [Memospot v0.1.4](https://github.com/memospot/memospot/releases/tag/v0.1.4).
> It will fix all asset paths in the database automatically on the first start. {style=note}

## Legacy instructions {collapsible="true" default-state="collapsed"}

This guide will help you migrate your Memos database and assets to a new host.

It's possible to migrate between Windows and POSIX hosts, and between Memos
Docker and Memospot, in any combination or direction. Just follow the
appropriate steps.

If you only used the default `Database` object storage, you can skip the assets
migration part and just copy the database files to the new host.

> MySQL and PostgreSQL are not supported by Memospot, so this guide will only
> cover SQLite migrations.
>
> Check Memos'
> [database documentation](https://www.usememos.com/docs/advanced-settings/database)
> if you need to work with other drivers.

> Do not proceed without taking an offline backup of your database.
>
> Shutdown the server and copy the database files and assets to a location
> outside your working scope for extra safety. {style="warning"}

### Requirements

- A SQLite3 client, like
  [DB Browser for SQLite](https://github.com/sqlitebrowser/sqlitebrowser)

- SSH access to your Docker host, if applicable

- An SCP/SFTP client, like [WinSCP](https://winscp.net/) and
  [Cyberduck](https://cyberduck.io): to copy files to/from host, if needed

### Basic migration

- Close Memospot and stop your Docker container
- Copy your assets folder from source to destination host
- Copy `memos_prod.db` (and sidecar files `memos_prod.db-shm` and
  `memos_prod.db-wal`, if they exist) to a work directory on your local machine
- Open the copied `memos_prod.db` with your SQLite client
- Execute the [appropriate SQL queries](#replacing-assets-paths-in-the-database)
- Write the changes to the database and close it
- Copy modified `memos_prod.db` to the destination

> Always copy the journal files (`memos_prod.db-shm` and `memos_prod.db-wal`)
> along with the database file.
>
> They may contain recent data that has not been committed to the database yet.
>
> Note that these files won't exist if the database was closed properly.

> The default Memos data path on a Docker _**host**_ is `~/.memos/`. Within the
> _container_, the path is `/var/opt/memos`.
>
> Unless you changed it, `~/.memos/` is where you'll find your assets and
> database. Stop the container first.

### Replacing assets paths in the database

The following queries assume the following:

- You are using the default internal Docker volume path `/var/opt/memos`

- All your relative paths are using the default `assets` folder

> Pay attention to the leading and trailing slashes when editing the queries
> below.

The following sections contains queries to replace the assets paths in the
database.

> Remember to always back up your database before running SQL queries.
> {style="warning"}

Pick one path style:

#### Using absolute paths (Memos <= v0.18.0) {collapsible="true" default-state="collapsed"}

> There are some `__PLACEHOLDERS__` in the following queries that you must
> replace with resolved absolute paths from your system, as SQL clients won't
> resolve system environment variables. {style="warning"}

- `__MEMOSPOT_POSIX_PATH__`

  Linux/macOS Terminal:

  ```bash
  echo "$HOME/.memospot"
  ```

- `__MEMOSPOT_WINDOWS_PATH__`

  Windows Powershell:

  ```bash
  Write-Host "$Env:LocalAppData\memospot"
  ```

- `__MEMOS_SERVER_WINDOWS_PATH__`

  Windows Powershell:

  ```bash
  Write-Host "$Env:ProgramData\memos"
  ```

> When migrating data **to** a Memos Docker container, you must specify the
> _internal_ Docker volume path.
>
> You probably shouldn't change `/var/opt/memos`.
>
> The host-accessible data path is set later (`~/.memos/`), when you launch the
> container:
>
> ```bash
> docker run -d \
> --init \
> --name memos \
> --publish 5230:5230 \
> --volume ~/.memos/:/var/opt/memos \
> ghcr.io/usememos/memos:latest
> ```
>
> {style="note"}

Choose what best suits your migration scenario:

##### Windows Memospot -> Memos Docker {collapsible="true" default-state="collapsed"}

SQL query:

```sql
-- Replace Windows Memospot paths with
-- default internal Docker volume paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '__MEMOSPOT_WINDOWS_PATH__',
                              '/var/opt/memos');

-- Replace remaining Windows path separators
UPDATE resource
  SET internal_path = REPLACE(internal_path, '\', '/');
```

##### Windows Memos Server -> Memos Docker {collapsible="true" default-state="collapsed"}

SQL query:

```sql
-- Replace Windows Memos Server paths with
-- default internal Docker volume paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '__MEMOS_SERVER_WINDOWS_PATH__',
                              '/var/opt/memos');

-- Replace remaining Windows path separators
UPDATE resource
  SET internal_path = REPLACE(internal_path, '\', '/');
```

##### Windows Memos Server -> Windows Memospot {collapsible="true" default-state="collapsed"}

SQL query:

```sql
-- Replace Windows Memos Server paths with
-- default internal Docker volume paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '__MEMOS_SERVER_WINDOWS_PATH__',
                              '__MEMOSPOT_WINDOWS_PATH__');
```

##### Linux/macOS Memospot -> Memos Docker {collapsible="true" default-state="collapsed"}

SQL query:

```sql
-- Replace Linux/macOS Memospot paths with
-- default Docker volume paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '__MEMOSPOT_POSIX_PATH__',
                              '/var/opt/memos');
```

##### Linux/macOS Memospot -> Windows Memospot {collapsible="true" default-state="collapsed"}

```sql
-- Replace Linux/macOS Memospot paths with Windows Memospot paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '__MEMOSPOT_POSIX_PATH__',
                              '__MEMOSPOT_WINDOWS_PATH__');

-- Replace remaining POSIX path separators
UPDATE resource
  SET internal_path = REPLACE(internal_path, '/', '\');
```

##### Memos Docker -> Linux/macOS Memospot {collapsible="true" default-state="collapsed"}

```sql
-- Replace default Docker volume paths with Linux/macOS Memospot paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '/var/opt/memos',
                              '__MEMOSPOT_POSIX_PATH__');
```

##### Memos Docker -> Windows Memospot {collapsible="true" default-state="collapsed"}

```sql
-- Replace default Docker volume paths with Windows Memospot paths
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              '/var/opt/memos',
                              '__MEMOSPOT_WINDOWS_PATH__');

-- Replace remaining POSIX path separators
UPDATE resource
  SET internal_path = REPLACE(internal_path, '/', '\');
```

#### Using relative paths (Memos >= v0.18.1) {collapsible="true" default-state="collapsed"}

These queries will replace absolute paths with relative paths.

While this method works fine and is simpler (queries may be run as-is), it will
let the database with mixed path styles, as new assets will be created with
absolute paths. {style="warning"}

> This only works if you have the default prefix `assets` in all your paths.
> {style="warning"}

> Assets with relative paths will be resolved relatively to the `MEMOS_DATA`
> environment variable.

Choose what best suits your scenario:

##### From a POSIX host to another POSIX host (relative) {collapsible="true" default-state="collapsed"}

```sql
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              SUBSTR(internal_path, 1,
                                     INSTR(internal_path, '/assets')
                              ), '');
```

##### From a POSIX host to a Windows host (relative) {collapsible="true" default-state="collapsed"}

```sql
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              SUBSTR(internal_path, 1,
                                     INSTR(internal_path, '/assets')
                              ), '');
UPDATE resource
  SET internal_path = REPLACE(internal_path, '/', '\');
```

##### From a Windows host to a POSIX host (relative) {collapsible="true" default-state="collapsed"}

```sql
UPDATE resource
  SET internal_path = REPLACE(internal_path,
                              SUBSTR(internal_path, 1,
                                     INSTR(internal_path, '\assets')
                              ), '');
UPDATE resource
  SET internal_path = REPLACE(internal_path, '\', '/');
```

### After migration

> Remember to browse the `resource` table and check if the new values in the
> `internal_path` column are adequate to the destination host filesystem.
> {style="note"}

Execute the following query to check the first 100 rows:

```sql
SELECT type, filename, internal_path
  FROM resource WHERE internal_path IS NOT '' LIMIT 100;
```
