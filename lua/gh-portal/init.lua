local M = {}

function M.setup()
  vim.api.nvim_create_user_command('GhPortal', function()
    -- TODO: git command check
    -- TODO: active branch -> main cascading
    local path = vim.api.nvim_buf_get_name(0)
    if path == nil or path == "" then
      vim.notify("gh-portal: Cannot get the buffer path. Make sure you have an active buffer open.", vim.log.levels.ERROR)
      return
    end
    local dir = vim.fn.fnamemodify(path, ':h')
    local escaped_dir = vim.fn.shellescape(dir)

    local exit_code = os.execute(string.format('git -C %s rev-parse --is-inside-work-tree &>/dev/null', escaped_dir))

    if (type(exit_code) == "number" and exit_code ~= 0) or (type(exit_code) ~= "number" and exit_code ~= true) then
      vim.notify("gh-portal: Not in a git repo.", vim.log.levels.ERROR)
      return
    end

    local url = vim.fn.system(string.format('git -C %s config --get remote.origin.url', escaped_dir)):gsub("\n$", "")
    local username, repo
    if url:match("^git@github.com:") then
      -- SSH URL format
      username, repo = url:match("^git@github.com:(.+)/(.+)%.git$")
    elseif url:match("^https://github.com/") then
      -- HTTPS URL format
      username, repo = url:match("^https://github.com/(.+)/(.+)%.git$")
    end

    if username == nil or repo == nil then
      vim.notify("gh-portal: Unable to identify repo URL on GitHub.", vim.log.levels.ERROR)
      return
    end

    local escaped_path = vim.fn.shellescape(path)
    local relative_path = vim.fn.system(string.format('git ls-files --full-name %s', escaped_path)):gsub("\n$", "")
    local current_line = vim.fn.line('.')
    local url = string.format("https://github.com/%s/%s/blob/main/%s#L%s", username, repo, relative_path, current_line)

    local os_name = vim.loop.os_uname().sysname
    -- TODO: other OS
    if os_name ~= "Darwin" then
      vim.notify("gh-portal: Operating system not supported yet.", vim.log.levels.ERROR)
      return
    end

    vim.fn.system(string.format("open %s", url))
  end, {})
end

return M
