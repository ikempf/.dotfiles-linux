return {
  "pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    execution_message = {
      message = function()
        return ""
      end,
    },
    debounce_delay = 500,
  },
}
