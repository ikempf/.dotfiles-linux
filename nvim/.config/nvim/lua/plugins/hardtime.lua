return {
  "m4xshen/hardtime.nvim",
  enabled = false,
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    disabled_filetypes = { "qf", "netrw", "lazy", "mason" },
  },
  event = "VeryLazy",
}