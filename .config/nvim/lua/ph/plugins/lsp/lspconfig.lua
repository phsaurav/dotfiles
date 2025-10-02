return {
  "neovim/nvim-lspconfig",
  event = {
    "BufReadPost *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh}",
    "BufNewFile *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh}",
  },
  ft = { "lua", "python", "go", "dockerfile", "json", "sh", "yaml", "yml" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.opt.signcolumn = "yes"

    local base_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)

    local function on_attach(client, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("keep", opts, { desc = "LSP: Hover Documentation" }))
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("keep", opts, { desc = "LSP: Go to Definition" }))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
        vim.tbl_extend("keep", opts, { desc = "LSP: Go to Declaration" }))
      vim.keymap.set("n", "ga", vim.lsp.buf.signature_help,
        vim.tbl_extend("keep", opts, { desc = "LSP: Show Signature Help" }))
      vim.keymap.set("n", "gt", function()
        require("telescope.builtin").lsp_type_definitions()
      end, vim.tbl_extend("keep", opts, { desc = "LSP: Go to Type Definition" }))
      vim.keymap.set({ "n", "x" }, "<F3>", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("keep", opts, { desc = "LSP: Format Buffer" }))
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
        vim.tbl_extend("keep", opts, { desc = "LSP: Code Action" }))
    end

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local servers = {
      gopls = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            analyses = { unusedparams = true },
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      },
      lua_ls = {
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      },
      jsonls = {
        filetypes = { "json", "jsonc" },
      },
      dockerls = {},
      bashls = {
        filetypes = { "sh", "bash" },
      },
      pyright = {
        filetypes = { "python" },
      },
      yamlls = {
        filetypes = { "yaml", "yml" },
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "docker-compose*.{yml,yaml}",
              ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
              ["https://json.schemastore.org/ansible-meta.json"] = "meta/main.{yml,yaml}",
              ["https://json.schemastore.org/ansible-playbook.json"] = "*play*.{yml,yaml}",
              ["https://json.schemastore.org/ansible-inventory.json"] = "inventory*.{yml,yaml}",
              ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
              "/*.k8s.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "**/docker-compose*.{yml,yaml}",
            },
            validate = true,
            hover = true,
            completion = true,
            customTags = {
              "!fn",
              "!And",
              "!If",
              "!Not",
              "!Equals",
              "!Or",
              "!FindInMap sequence",
              "!Base64",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!Select",
              "!Split",
              "!Join sequence",
            },
          },
        },
      },
    }

    local function setup_server(name, opts)
      local cfg = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
      }, opts or {})

      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end

    for server, opts in pairs(servers) do
      setup_server(server, opts)
    end

    -- local util = require("lspconfig.util") -- still available if you re-enable terraformls, etc.
  end,
}
