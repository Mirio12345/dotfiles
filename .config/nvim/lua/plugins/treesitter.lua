-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "wgsl",
      "query",
      "html",
      "json",
      "typescript",
      "rust",
      "yaml",
      "tsx",
      "toml",
      "sql",
      "glimmer",
      "svelte",
      "astro",
      "regex",
      "javascript",
      "dockerfile",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
