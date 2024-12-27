return {
	{
		"mfussenegger/nvim-dap",
		cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" },
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		-- Load for Go files and on VeryLazy event
		ft = "go",
		cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dapui.setup()

			-- Automatically open and close the DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Toggle Debug UI with F12
			vim.keymap.set("n", "<F12>", function()
				dapui.toggle()
			end, { desc = "Toggle Debug UI" })
		end,
	},
	{
		"dreamsofcode-io/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		config = function(_, opts)
			require("dap-go").setup(opts)

			local dap = require("dap")

			dap.adapters.delve = {
				type = "server",
				port = 2345,
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:2345" },
				},
			}

			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "attach",
					mode = "remote",
					port = 2345,
				},
			}

			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end, { desc = "Start/Continue Debugging" })

			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, { desc = "Step Over" })

			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, { desc = "Step Into" })

			vim.keymap.set("n", "<F9>", function()
				dap.step_out()
			end, { desc = "Step Out" })

			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle Breakpoint" })

			vim.keymap.set("n", "<leader>dc", function()
				dap.clear_breakpoints()
			end, { desc = "Clear All Breakpoints" })

			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Open Debug REPL" })

			vim.keymap.set("n", "<leader>dt", function()
				dap.terminate()
			end, { desc = "Terminate Debugger" })

			vim.keymap.set("n", "<leader>dgs", function()
				dap_go.debug()
			end, { desc = "Start Go Debugging" })
		end,
	},
}
