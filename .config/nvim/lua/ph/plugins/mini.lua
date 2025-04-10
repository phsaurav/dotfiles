return {
  {
    'echasnovski/mini.ai',
    event = "VeryLazy",
    version = false,
    config = function()
      require('mini.ai').setup({
        -- You can leave this empty to use the default behavior
      })
    end
  },
  -- {
  --   'echasnovski/mini.surround',
  --   event = "VeryLazy",
  --   version = false,
  --   opts = {
  --     mappings = {
  --       add = 'gs',             -- add surrounding
  --       delete = 'gsd',         -- delete surrounding
  --       find = 'gsf',           -- find surrounding (right)
  --       find_left = 'gsF',      -- find surrounding (left)
  --       highlight = 'gsh',      -- highlight surrounding
  --       replace = 'gsr',        -- Replace surrounding
  --       update_n_lines = 'gsn', -- Update `n_lines`
  --     }
  --   }
  -- },
}
