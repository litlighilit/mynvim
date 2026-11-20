if #vim.api.nvim_list_uis() == 0 then
  assert(not package.loaded.image, 'Headless startup must not initialize the Sixel image backend')
end
