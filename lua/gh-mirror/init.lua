local M = {}

function M.setup()
  vim.api.nvim_create_user_command('Gh-mirror', function()
    -- TODO: check not in a git repo
    -- TODO: active branch -> main cascading
    local file = vim.fn.expand('%:p')
    local dir = vim.fn.fnamemodify(file, ':h')
    print(dir)
  end, {})
end

return M
