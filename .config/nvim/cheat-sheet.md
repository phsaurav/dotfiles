# Neovim cheat sheet

`Space` is the leader key. Keys below are Normal mode unless noted. Commands start with `:`. These reflect this configuration, not generic plugin defaults.

## go.nvim — Go tests, coverage and coding helpers

Loads for Go files or a Go command; keeps the existing LSP, formatter and debugger.

- `:GoTest` — run package tests.
- `:GoTestFunc` / `:GoTestFile` — test the current function / file.
- `:GoCoverage` — run tests with coverage.
- `:GoAlt` — switch source ↔ test; `:GoAltV` / `:GoAltS` open in splits.
- `:GoBuild` / `:GoRun` — build / run.
- `:GoDoc` — Go documentation.
- `:GoFillStruct` / `:GoIfErr` — fill struct fields / insert error handling.
- `:GoImpl` / `:GoAddTag` / `:GoRmTag` — interface implementations / struct tags.
- `:GoImports` — organize imports explicitly; `:GoFmt` — gofmt explicitly.
- `:GoModTidy` — tidy module dependencies.

Some generator commands install a helper tool on first use. go.nvim's debugger and extra keymaps are disabled here.

## Telescope — find files, text and buffers

- `Space ff` — files; `Space fd` — include hidden/ignored files; `Space fg` — Git files.
- `Space fs` — search text, including hidden/ignored files.
- `Space fc` — search word under cursor, or selected text in Visual mode.
- `Space bl` — buffers; `Space fm` — marks.
- Inside a picker: `Ctrl-j/k` — next/previous; `Enter` — open; `Ctrl-q` — quickfix.
- Inside a picker: `Ctrl-v` — horizontal split; `Ctrl-s` — vertical split.

## nvim-tree — file explorer

- `Space ee` — toggle; `Space ef` — reveal current file.
- `Space ec` — collapse; `Space er` — refresh.
- Inside tree: `h/l` — parent/open; `Ctrl-v` — horizontal split; `Ctrl-h` — vertical split.

## nvim-lspconfig — language intelligence

Available when a language server attaches.

- `K` — documentation; `ga` — signature help.
- `gd` / `gD` — definition / declaration; `gi` — implementation.
- `gr` — references; `gt` — type definition.
- `Space ca` — code actions; `Space fx` — apply preferred quick fix.
- `Space sf` — search a Go function signature.
- `Space dn/dp` — next/previous diagnostic; `Space dl` — diagnostic list.
- `Space dk` — show/copy diagnostic; `Space wd` — toggle inline diagnostic text.

## Conform — consistent formatting

- Formats on save. `Space ;` — format file or selection.
- `F3` — format through Conform when LSP mappings are attached.
- `:ConformInfo` — inspect formatter status.
- Go uses gofmt and real tabs displayed four columns wide. Project style settings can override indentation defaults.

## Blink completion — autocomplete

In Insert mode: `Ctrl-Space` opens completion, `Ctrl-j/k` or `Ctrl-n/p` selects, `Ctrl-y` accepts, `Ctrl-e` cancels. `Tab` / `Shift-Tab` moves through snippet fields.

Code completion uses language servers, paths, snippets and buffer words. Markdown also enables Obsidian links/tags, Markdown helpers and dictionary words; a missing dictionary file is skipped. `blink.compat` connects the Obsidian sources.

`:BlinkCmp status` shows which completion sources are enabled.

## Gitsigns — Git changes beside your code

- `Space hn/hp` — next/previous change; `Space hk` — preview.
- `Space hs/hr` — stage/reset change; `Space hd` — diff.
- `Space hb` — blame line; `Space tb` — toggle inline blame.

## nvim-dap + nvim-dap-ui + nvim-dap-go — Go debugging

- `Space db` — toggle breakpoint; `Space dc` — clear breakpoints.
- `F5` — start/continue; `F10` — step over; `F11` — step into; `F9` — step out.
- `F12` — toggle debugger panels; `Space dr` — debug console; `Space dt` — terminate.

Current setup is the older remote-attach configuration. `Space dgs` is broken and isn't a usable start shortcut yet. These plugins were not replaced by go.nvim.

## Obsidian — notes and vault navigation

- `gf` — follow note link; `Space ti` — toggle checkbox.
- `Space of/os` — find/search vault notes; `Space oo` — open note in Obsidian.
- `Space on` — apply Base template; `Space ot` — clean up note title.
- `Space ok` — move to Zettelkasten; `Space odd` — delete note after confirmation.

## render-markdown — readable Markdown in the editor

`:RenderMarkdown toggle` toggles rendering. Tree-sitter's custom `Space cb` selects the content inside a fenced code block.

## Comment.nvim — toggle comments

`gcc` toggles a line comment; `Ctrl-_` then a motion comments that region. Visual `gc` comments the selection. Many terminals send `Ctrl-_` with `Ctrl-/`.

## mini.ai — smarter text selections

Use with operators: `vif` selects inside a function; `vaf` selects around it; `cia` changes an argument. Standard objects such as `vi(` still work.

## marks.nvim — visible bookmarks

`ma` sets mark a; `'a` jumps to its line. `m]` / `m[` goes next/previous, `dma` deletes mark a. `Space fm` lists marks via Telescope.

## vim-sneak — quick two-character jumps

`s` + two characters jumps forward; `S` jumps backward. `;` repeats forward, `,` backward.

## Automatic helpers and maintenance

| Plugin | TLDR / command |
| --- | --- |
| lazy.nvim | Plugin manager: `:Lazy`; startup timing: `:Lazy profile`. |
| mason.nvim + mason-lspconfig | Language-server installer/integration: `:Mason`. |
| nvim-treesitter | Syntax highlighting and indentation: `:TSInstall go`, `:TSUpdate`. |
| none-ls.nvim | Python pylint diagnostics; `:NullLsInfo`. Formatting belongs to Conform. |
| nvim-autopairs | Automatically closes quotes/brackets while typing. |
| auto-save.nvim | Saves after edits and on focus/buffer changes; `:ASToggle`. |
| indent-blankline.nvim | Indentation and scope guides; `:IBLToggle`. |
| noice.nvim | Command/message UI; `:Noice history` to review messages. |
| lualine.nvim | Status line and buffer information; automatic. |
| neovim-ayu | Current theme; `:colorscheme ayu`. |
| smear-cursor.nvim | Cursor animation; automatic. |

Support libraries have no daily shortcuts: `guihua.lua` (Go UI), `plenary.nvim` (utilities), `nui.nvim` (UI), `nvim-nio` (debugger async support), and `nvim-web-devicons` (icons). Telescope's fzf-native and ui-select extensions improve its matching and selection menus.

Commented-out plugins such as Trouble, WhichKey, CopilotChat, CodeCompanion and Tabnine are not active.
