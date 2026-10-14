
print("def tab")
local opt = vim.opt

-- defval
opt.expandtab = true
opt.tabstop = 4  -- tab display width
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

local function set_indent(width, use_tabs)
  return function(args)
    local bo = vim.bo[args.buf]
    bo.expandtab   = not use_tabs
    bo.tabstop     = width
    bo.shiftwidth  = width
    bo.softtabstop = use_tabs and 0 or width
  end
end

local group = vim.api.nvim_create_augroup("UserIndent", { clear = true })
local function handle(width, use_tabs, set)
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = set,
    callback = set_indent(width, use_tabs),
  })
end

handle(8, true, {"go", "make"})
handle(2, false, {
  "lua", "json", "jsonc", "yaml", "toml",
  "javascript", "typescript", "javascriptreact", "typescriptreact",
  "html", "css", "scss", "less", "xml",
  "vue", "svelte", "astro",
  "ruby", "sh", "bash", "nix", "haskell", "protobuf",
})


