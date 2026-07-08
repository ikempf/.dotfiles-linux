-- LazyVim Extras enabled declaratively so they sync via dotfiles.
-- Equivalent to enabling these in `:LazyExtras`, but tracked in git
-- instead of the (per-machine, untracked) ~/.config/nvim/lazyvim.json.
return {
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.toml" },
}
