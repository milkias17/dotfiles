return {
  {
    "kristijanhusak/vim-dadbod-ui",
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
