local has_nvim_treesitter, _ = pcall(require, 'nvim-treesitter')
if not has_nvim_treesitter then
  return
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "typescript", "tsx", "javascript", "html", "css", "json", "yaml", "prisma",
    "bash", "lua",
    "python", "c", "cpp", "c_sharp", "go", "rust",
  },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local has_context, context = pcall(require, 'treesitter-context')
if not has_context then
  return
end

context.setup { }
