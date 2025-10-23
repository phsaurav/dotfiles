return {
  "neovim/nvim-lspconfig",
  event = {
    "BufReadPost *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh,html,css,templ}",
    "BufNewFile *.{lua,py,go,js,jsx,ts,tsx,tf,tfvars,dockerfile,json,sh,bash,zsh,html,css,templ}",
  },
  ft = { "lua", "python", "go", "dockerfile", "json", "sh", "yaml", "yml", "html", "css", "templ" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.opt.signcolumn = "yes"

    local base_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)
    local tb = require('telescope.builtin')

    vim.keymap.set('n', '<leader>sf', function()
      local line = vim.api.nvim_get_current_line()
      local sig
      if not line:match("^%s*func") then
        sig = line:match("^%s*([%w_]+%b().-)%s*$")
            or line:match("^%s*([%w_]+%b().-)%s*[%},]")
      else
        local lines = table.concat(
          vim.api.nvim_buf_get_lines(0, vim.fn.line('.') - 1, vim.fn.line('.') + 1, false), " "
        )
        sig = lines:match("%)%s*([%w_]+%b().-)%s*{")
            or lines:match("func%s+([%w_]+%b().-)%s*{")
      end
      if not sig or sig == "" then
        vim.notify("No Go method/function signature found", vim.log.levels.WARN)
        return
      end
      tb.grep_string({ search = sig, additional_args = { "--glob", "*.go" } })
    end, { desc = "Search by Go signature (method or interface)" })

    local function on_attach(client, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("keep", opts, { desc = "LSP: Hover Documentation" }))
      vim.keymap.set('n', 'gd', tb.lsp_definitions, { buffer = bufnr, desc = 'Definition' })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
        vim.tbl_extend("keep", opts, { desc = "LSP: Go to Declaration" }))
      vim.keymap.set("n", "ga", vim.lsp.buf.signature_help,
        vim.tbl_extend("keep", opts, { desc = "LSP: Show Signature Help" }))
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
        { noremap = true, silent = true })
      vim.keymap.set('n', 'gr', tb.lsp_references, { buffer = bufnr, desc = 'References' })
      vim.keymap.set('n', 'gi', tb.lsp_implementations, { buffer = bufnr, desc = 'Implementation' })
      vim.keymap.set('n', 'gt', tb.lsp_type_definitions, { buffer = bufnr, desc = 'Type' })
      vim.keymap.set({ "n", "x" }, "<F3>", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("keep", opts, { desc = "LSP: Format Buffer" }))
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
        vim.tbl_extend("keep", opts, { desc = "LSP: Code Action" }))
    end

    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘ ",
          [vim.diagnostic.severity.WARN] = "⚠ ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = "ℹ ",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = false,
    })

    local servers = {
      gopls = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            analyses = { unusedparams = true },
            staticcheck = true,
            usePlaceholders = true,
            semanticTokens = true,
            experimentalPostfixCompletions = true,
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
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
            vim.diagnostic.enable(false, { bufnr = bufnr })
            vim.defer_fn(function()
              vim.diagnostic.reset(nil, bufnr)
            end, 1000)
          end
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            schemaStore = {
              enable = true,
              url = 'https://www.schemastore.org/api/json/catalog.json',
            },
            schemas = {
              kubernetes = {
                'k8s-*.{yml,yaml}',
                'k8s-*.{yml,yaml}',
                'k8s/*.{yml,yaml}',
              },
            },
            validate = true,
            hover = true,
            completion = true,
            customTags = {
              "!fn", "!And", "!If", "!Not", "!Equals", "!Or",
              "!FindInMap sequence", "!Base64", "!Cidr", "!Ref",
              "!Sub", "!GetAtt", "!GetAZs", "!ImportValue",
              "!Select", "!Split", "!Join sequence",
            },
          },
        }
      },
      -- New language servers
      tailwindcss = {
        filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "templ" },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass" },
            includeLanguages = {
              templ = "html",
            },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
          },
        },
      },
      html = {
        filetypes = { "html", "templ" },
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = "auto",
            },
          },
        },
      },
      cssls = {
        filetypes = { "css", "scss", "less" },
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
      golangci_lint_ls = {
        filetypes = { "go" },
        settings = {
          golangci_lint_ls = {
            settings = {
              golangci_lint = {
                enable = true,
              },
            },
          },
        },
      },
      templ = {
        filetypes = { "templ" },
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

    -- local util = require("lspconfig.util")
  end,
}
