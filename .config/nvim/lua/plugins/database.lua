return {
  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_use_nvim_notify = 1
    end,
    dependencies = {
      { "tpope/vim-dadbod", cmd = "DB" },
      {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = {
          { "tpope/vim-dadbod", cmd = "DB" },
        },
        config = function()
          vim.cmd(
            "autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })"
          )
        end,
      },
    },
    keys = {
      { "<space>st", "<cmd>DBUIToggle<cr>",        { noremap = true } },
      { "<space>sa", "<cmd>DBUIAddConnection<cr>", { noremap = true } },
    },
  },
}
