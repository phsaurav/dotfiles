return {
  "ray-x/go.nvim",
  ft = { "go", "gomod", "gowork", "gosum", "gotmpl" },
  cmd = {
    "GoTest", "GoTestFunc", "GoTestFile", "GoTestPkg", "GoCoverage",
    "GoBuild", "GoRun", "GoAlt", "GoAltV", "GoAltS", "GoDoc",
    "GoFillStruct", "GoImpl", "GoAddTag", "GoRmTag", "GoIfErr",
    "GoFmt", "GoImports", "GoModTidy",
  },
  dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
  opts = {
    -- Existing lspconfig/Blink own gopls, diagnostics and mappings.
    lsp_cfg = false,
    lsp_keymaps = false,
    diagnostic = false,
    lsp_codelens = false,
    lsp_inlay_hints = { enable = false },
    textobjects = false,
    -- Keep the existing debugger and its keys in lsp/go-debug.lua.
    dap_debug = false,
    dap_debug_gui = false,
    dap_debug_keymap = false,
    dap_debug_vt = false,
    -- Conform remains the only save formatter; these are manual commands.
    gofmt = "gofmt",
    goimports = "gopls",
    test_runner = "go",
    run_in_floaterm = false,
    -- Keep the integration consistent across projects.
    disable_per_project_cfg = true,
  },
}
