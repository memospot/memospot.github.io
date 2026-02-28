# memospot.github.io

Memospot landing page and documentation.

[![Built with Starlight](https://astro.badg.es/v2/built-with-starlight/tiny.svg)](https://starlight.astro.build) [![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/memospot/memospot.github.io)

## Technology Stack

- [Astro](https://astro.build/) - Static site generator
- [Starlight](https://starlight.astro.build/) - Astro documentation framework
- [MDX](https://mdxjs.com/) - Markdown with embedded JSX components
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [Bun](https://bun.sh/) - JavaScript runtime and package manager
- [Biome](https://biomejs.dev/) - Linter and code formatter
- [dprint](https://dprint.dev/) - Code formatting

## Project Structure

In this project, you'll see the following folders and files:

```txt
.
├── public/                (Static assets like favicons and robots.txt)
├── src/
│   ├── assets/            (Images and other media)
│   ├── components/        (Astro components used across the site)
│   ├── content/
│   │   └── docs/          (Mdx files for documentation)
│   ├── styles/            (CSS styles)
│   └── content.config.ts  (Controls how content is loaded and displayed)
├── astro.config.ts        (Astro configuration. Contains the sidebar links.)
└── justfile               (Task runner file with common commands)
```

## Installing Dependencies with Homebrew

```bash
brew install \
  oven-sh/bun/bun \
  dprint \
  biome \
  just \
  jq
```

## Commands

All commands are run from the root of the project, from a terminal:

| Command               | Action                                           |
| :-------------------- | :----------------------------------------------- |
| `bun install`         | Installs dependencies                            |
| `bun dev`             | Starts local dev server at `localhost:4321`      |
| `bun build`           | Build the production site to `./dist/`           |
| `bun preview`         | Preview the build locally, before deploying      |
| `bun astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `bun astro -- --help` | Get help using the Astro CLI                     |

For consistency with the parent project, a `justfile` is also provided with similar commands. Run `just` on the project directory to see a list of available tasks.

## Learn more

- [Starlight’s docs](https://starlight.astro.build/)
- [Astro documentation](https://docs.astro.build)
- [MDX documentation](https://mdxjs.com/docs/)
- [Tailwind CSS documentation](https://tailwindcss.com/docs)
- [Bun documentation](https://bun.sh/docs)

## Contributing

Contributions are welcome! Please read the [contribution guide](https://memospot.github.io/guides/contributing/) for extra details.
