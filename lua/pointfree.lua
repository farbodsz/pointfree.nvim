local Job = require("plenary.job")
local M = {}

local function err(msg)
  local fmtmsg = string.format("[pointfree.nvim] ERROR: %s", msg)
  print(fmtmsg)
end

function M.pointfree()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local curline = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]

  local pf_input = string.format("%s", curline)

  Job
    :new({
      command = "pointfree",
      args = { pf_input },
      cwd = vim.fn.getcwd(),
      on_exit = function(job, return_val)
        if return_val ~= 0 then
          return err(string.format("Unable to make pointfree: %s", pf_input))
        end

        vim.schedule(function()
          vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, false, job:result())
        end)
      end,
    })
    :start()
end

return M
