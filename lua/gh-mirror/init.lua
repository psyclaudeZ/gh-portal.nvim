local M = {}

function M.setup()
  vim.api.nvim_create_user_command('Ghmirror', function()
    -- TODO: git command check
    -- TODO: active branch -> main cascading
    local path = vim.api.nvim_buf_get_name(0)
    if path == nil or path == "" then
      vim.notify("gh-mirror: Cannot get the buffer path. Make sure you have an active buffer open.", vim.log.levels.ERROR)
      return
    end
    local dir = vim.fn.fnamemodify(path, ':h')

    local escaped_path = vim.fn.shellescape(path)
    local escaped_dir = vim.fn.shellescape(dir)

    local exit_code = os.execute(string.format('git -C %s rev-parse --is-inside-work-tree &>/dev/null', escaped_dir))

    if (type(exit_code) == "number" and exit_code ~= 0) or (type(exit_code) ~= "number" and exit_code ~= true) then
      vim.notify("gh-mirror: Not in a git repo.", vim.log.levels.ERROR)
      return
    end

    print(vim.fn.system(string.format('git -C %s rev-parse --show-toplevel', escaped_dir)))

   -- TODO: generate git repo link
  end, {})
end

return M
