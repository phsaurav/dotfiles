function Save_file()
    local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
    if modifiable then
        vim.cmd 'w!'
    end
end

-- Define a toggle function for diagnostic virtual text
function toggle_virtual_text()
    local current_config = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current_config }) -- Toggle the value
end

function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end
