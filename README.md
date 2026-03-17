[![Build Status](https://github.com/MaeBrooks/tree-sitter-gren/actions/workflows/test.yml/badge.svg)](https://github.com/MaeBrooks/tree-sitter-gren/actions/workflows/test.yml)

# tree-sitter-gren

A [tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for the [Gren programming language](https://gren-lang.org/).

## Prerequisites

- [Node.js](https://nodejs.org/) (v14+)
- [tree-sitter CLI](https://tree-sitter.github.io/tree-sitter/creating-parsers#installation) (`npm install -g tree-sitter-cli` or `cargo install tree-sitter-cli`)
- A C compiler (gcc, clang, or MSVC)

## Building

Install dependencies and generate the parser:

```sh
npm install
npm run build
```

This runs `tree-sitter generate`, which reads `grammar.js` and produces the C parser in `src/parser.c`.

## Testing

Run the test suite:

```sh
npm test
```

Or build and test in one step:

```sh
npm run test:dev
```

### Updating test expectations

After changing the grammar, use `npm run test:update` to regenerate the expected parse trees:

```sh
npm run test:update
```

### Parsing a file

```sh
tree-sitter parse path/to/file.gren
```

## Project Structure

```
grammar.js           Main grammar definition
src/scanner.c        External scanner (indentation)
src/parser.c         Generated parser (do not edit)
queries/
  highlights.scm     Syntax highlighting queries
  locals.scm         Local scope queries
  tags.scm           Symbol tagging queries
  injections.scm     Language injection queries
test/corpus/         Test corpus files
bindings/            Language bindings (Node, Rust, Swift)
```

## Editing the Grammar

1. Modify `grammar.js` (and `src/scanner.c` if changing lexer behavior)
2. Run `npm run test:dev` to regenerate and test
3. Verify against real `.gren` files with `tree-sitter parse`

## Editor Integration

The generated `src/parser.c` is the universal artifact. How it gets compiled and loaded depends on the editor.

### VS Code

VS Code extensions load the parser as a WebAssembly module. Build it with:

```sh
npx tree-sitter build --wasm
```

This produces `tree-sitter-gren.wasm`, a self-contained binary with the parser tables and scanner. A VS Code extension loads this at runtime via tree-sitter's WASM bindings.

> **Note:** On Apple Silicon (arm64) you may see a warning like `The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)`. This is safe to ignore — the WASM file is still built correctly.

The recommended VS Code extension is [tree-sitter-vscode](https://marketplace.visualstudio.com/items?itemName=AlecGhost.tree-sitter-vscode) by AlecGhost. It ships no built-in parsers — you provide your own WASM file and query files.

**Step 1: Configure the extension**

Open VS Code settings: User Settings > Extensions > tree-sitter-vscode > click the "Edit in settings.json" link. Add the following to your `settings.json`:

```json
"tree-sitter-vscode.languageConfigs": [
  {
    "lang": "gren",
    "parser": "/path/to/tree-sitter-gren/tree-sitter-gren.wasm",
    "highlights": "/path/to/tree-sitter-gren/queries/highlights.scm",
    "injections": "/path/to/tree-sitter-gren/queries/injections.scm"
  }
]
```

Replace `/path/to/tree-sitter-gren` with the absolute path to this repository.

**Step 2: Register the `.gren` file type**

The extension doesn't know about `.gren` files by default. You need to register the file type in the extension's own `package.json`:

1. Open the Command Palette (`Cmd+P` on macOS, `Ctrl+P` on Linux/Windows)
2. Run "Extensions: Open Extensions Folder"
3. Open `alecghost.tree-sitter-vscode-<version>/package.json`
4. Under the `"contributes"` object, add:

```json
"languages": [
  {
    "id": "gren",
    "extensions": [
      ".gren"
    ]
  }
]
```

**Step 3: Reload**

Run the "tree-sitter-vscode: Reload" command from the Command Palette to apply the changes.

### Neovim

Neovim's [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) compiles `src/parser.c` and `src/scanner.c` into a shared library on the user's machine. Register the grammar by adding it to your nvim-treesitter config:

```lua
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gren = {
  install_info = {
    url = "path/to/tree-sitter-gren",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "gren",
}
```

Then run `:TSInstall gren`.

### Zed

This repository includes a complete Zed extension at `editors/zed/` with syntax highlighting, indentation, brackets, and outline support.

**Install as a dev extension:**

1. Open Zed
2. Open the Command Palette (`Cmd+Shift+P` on macOS)
3. Run "zed: install dev extension"
4. Select the `editors/zed/` directory from this repository

The extension bundles its own copy of the grammar, query files, and `gren.wasm`. When the grammar is updated, run `npm run build` to regenerate and sync the files into the extension directory, then restart Zed or reload your Gren extension.

**Extension structure:**

```
editors/zed/
  extension.toml           Extension manifest
  grammars/gren/           Grammar source (synced from root by npm run build)
    grammar.js
    src/
    test/corpus/
  languages/gren/
    config.toml            Language config (file type, comments, brackets)
    highlights.scm         Syntax highlighting queries
    indents.scm            Auto-indent rules
    brackets.scm           Bracket matching
    outline.scm            Symbol outline
```

### Helix

Helix has built-in support for Gren. No additional configuration is needed.

## Bindings

### Rust

Add to your `Cargo.toml`:

```toml
[dependencies]
tree-sitter-gren = { path = "path/to/tree-sitter-gren" }
```

The `parser.c` and `scanner.c` files are compiled by `cc` via `build.rs` and statically linked into your binary.

### Node.js

```js
const Parser = require("tree-sitter");
const Gren = require("tree-sitter-gren");

const parser = new Parser();
parser.setLanguage(Gren);

const tree = parser.parse('module Main exposing (..)');
console.log(tree.rootNode.toString());
```

## Thanks

Shamelessly stolen from the [tree-sitter-elm](https://github.com/elm-tooling/tree-sitter-elm) project.

## Want to help?

Help writing some tests or simply find valid gren files that fail parsing. Tests are located in the `test` folder and separated in parser tests and highlighting tests.

## License

MIT
