return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
						-- Prevent Ctrl-h from wrapping through Snacks' sidebar root back into Neovim.
						actions = {
							tmux_navigate_left = function()
								local pane = vim.env.TMUX_PANE
								if not pane then
									return
								end

								vim.system({
									"tmux",
									"if-shell",
									"-F",
									"-t",
									pane,
									"#{pane_at_left}",
									"",
									"select-pane -t " .. pane .. " -L",
								}):wait()
							end,
						},
						win = {
							input = {
								keys = {
									["<c-h>"] = "tmux_navigate_left",
								},
							},
							list = {
								keys = {
									["<c-h>"] = "tmux_navigate_left",
								},
							},
						},
					},
					files = {
						hidden = true, -- show dotfiles in fuzzy finder
						ignored = false, -- optional: show gitignored files
					},
				},
			},
		},
	},
}
