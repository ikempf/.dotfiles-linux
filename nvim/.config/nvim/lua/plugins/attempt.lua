return {
	{
		"m-demare/attempt.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>an", function() require("attempt").new_select() end,    desc = "New attempt (select ext)" },
			{ "<leader>ai", function() require("attempt").new_input_ext() end, desc = "New attempt (input ext)" },
			{ "<leader>ar", function() require("attempt").run() end,           desc = "Run attempt" },
			{ "<leader>ad", function() require("attempt").delete_buf() end,    desc = "Delete attempt" },
			{ "<leader>ac", function() require("attempt").rename_buf() end,    desc = "Rename attempt" },
			{ "<leader>al", function() require("attempt.snacks").picker() end, desc = "List attempts" },
		},
		opts = {},
	},
}
