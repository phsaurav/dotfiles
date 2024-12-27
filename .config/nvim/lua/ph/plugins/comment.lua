return{
    'numToStr/Comment.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('Comment').setup(
            {
                opleader = {
                    ---Line-comment keymap
                    line = '<C-_>',
                },
            }
        )
    end
}
