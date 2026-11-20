local M = {}

function M.setup()
  local wk = require('which-key')
  wk.setup({
    preset = 'classic',
    delay = 300,
    icons = { mappings = false },
    -- Do not intercept Space while typing or using a terminal.
    triggers = { { '<auto>', mode = 'nxso' } },
  })
  wk.add({
    { '<leader>f', group = '查找 / Telescope' },
    { '<leader>d', group = '诊断' },
    { '<leader>c', group = '代码操作' },
    { '<leader>r', group = '重命名 / 重构' },
    { '<leader>h', group = 'Git 修改块' },
    { '<leader>e', desc = '切换文件树' },
    { '<leader>t', desc = '切换终端' },
    { '<leader>g', desc = 'Git 状态' },
    { '<leader>l', desc = 'Git 提交图' },
    { '<leader>v', desc = 'Markdown 分屏预览' },
    { '<leader>w', desc = '切换单词级 diff' },
    { '<leader>b', desc = '查看当前行 blame' },
    { '<leader>B', desc = '切换行内 blame' },
    { '<leader>?', desc = '搜索快捷键' },
  })
end

return M
