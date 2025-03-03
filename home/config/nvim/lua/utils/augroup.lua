-- utils/augroup.lua

local M = {}

M.setup = function()
  local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup,
    pattern = "*",
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode ~= "c" then -- 명령행 창이 아닌 경우에만 checktime 실행
        vim.cmd("checktime")
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = augroup,
    pattern = "*",
    callback = function()
      vim.cmd("echohl WarningMsg | echo 'File " .. vim.fn.expand("<afile>") .. " changed on disk. Buffer reloaded.' | echohl None")
    end,
  })
end

return M
