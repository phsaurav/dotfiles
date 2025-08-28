return {
  "neovim/nvim-lspconfig",
  event = {
    "BufReadPost *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh}",
    "BufNewFile *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh}"
  },
  ft = { "lua", "python", "go", "dockerfile", "json", "sh", "yaml", "yml" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    -- Set sign column to always display
    vim.opt.signcolumn = "yes"

    -- Import LSPConfig and CMP capabilities
    local lspconfig = require("lspconfig")
    local original_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

    -- List of servers to set up
    local servers = {
      gopls = { -- Go LSP with custom settings
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        gopls = {
          completeUnimported = true,
          analyses = { unusedparams = true },
          staticcheck = true,
          usePlaceholders = true,
        },
      },
      lua_ls = { -- Lua LSP specific settings
        filetypes = { "lua" },
        Lua = {
          diagnostics = { globals = { "vim" } }, -- Recognize `vim` as a global
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
      },
      jsonls = {
        filetypes = { "json", "jsonc" }
      },
      dockerls = {
      },
      bashls = {
        filetypes = { "sh", "bash" }
      },
      pyright = {
        filetypes = { "python" },
      },
      yamlls = {
        filetypes = { "yaml", "yml" },
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
            "!Join sequence"
          },
        },
      },
    }

    -- Common on_attach function with descriptions for keymaps
    local function on_attach(client, bufnr)
      local opts = { buffer = bufnr, silent = true }

      vim.keymap.set(
        "n",
        "K",
        vim.lsp.buf.hover,
        vim.tbl_extend("keep", opts, { desc = "LSP: Hover Documentation" })
      )
      vim.keymap.set(
        "n",
        "gd",
        vim.lsp.buf.definition,
        vim.tbl_extend("keep", opts, { desc = "LSP: Go to Definition" })
      )
      vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        vim.tbl_extend("keep", opts, { desc = "LSP: Go to Declaration" })
      )
      -- Default-gri
      -- vim.keymap.set(
      --   "n",
      --   "gI",
      --   vim.lsp.buf.implementation,
      --   vim.tbl_extend("keep", opts, { desc = "LSP: Go to Implementation" })
      -- )
      -- Defautl-grr
      -- vim.keymap.set(
      --   "n",
      --   "gr",
      --   vim.lsp.buf.references,
      --   vim.tbl_extend("keep", opts, { desc = "LSP: Show References" })
      -- )
      vim.keymap.set(
        "n",
        "ga",
        vim.lsp.buf.signature_help,
        vim.tbl_extend("keep", opts, { desc = "LSP: Show Signature Help" })
      )
      vim.keymap.set(
        "n",
        "gt",
        function()
          require("telescope.builtin").lsp_type_definitions()
        end,
        vim.tbl_extend("keep", opts, { desc = "LSP: Go to Type Definition" })
      )
      vim.keymap.set({ "n", "x" }, "<F3>", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("keep", opts, { desc = "LSP: Format Buffer" }))
      vim.keymap.set(
        "n",
        "<leader>ca",
        vim.lsp.buf.code_action,
        vim.tbl_extend("keep", opts, { desc = "LSP: Code Action" })
      )
    end

    local signs = { error = " ", warn = " ", hint = "󰠠 ", info = " " }
    for type, icon in pairs(signs) do
      local hl = "diagnosticsign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Helper function to set up LSP servers
    local function setup_server(server_name, custom_settings)
      lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = custom_settings, -- Pass specific settings if any
      })
    end

    -- Setup all servers using the helper function
    for server, settings in pairs(servers) do
      setup_server(server, settings)
    end

    local util = require("lspconfig.util")

    -- lspconfig.terraformls.setup({
    --   capabilities = capabilities,
    --   on_attach = function(client, bufnr)
    --     -- Disable semantic tokens if not needed
    --     client.server_capabilities.semanticTokensProvider = nil
    --
    --     -- Call your common on_attach function
    --     on_attach(client, bufnr)
    --   end,
    --   flags = {
    --     debounce_text_changes = 200,
    --   },
    --   root_dir = util.root_pattern(".terraform", ".git"),
    --   settings = {
    --     terraform = {
    --       experimentalFeatures = {
    --         validateOnSave = true,
    --       },
    --       languageServer = {
    --         enable = true,
    --         args = { "server" },
    --       },
    --       telemetry = {
    --         enable = false,
    --       },
    --     },
    --   },
    -- })
  end,
}
