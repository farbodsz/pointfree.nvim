local Job = require("plenary.job")

local M = {}

---Prints a message formatted as an error.
---@param msg string
local function err(msg)
  local fmtmsg = string.format("[pointfree.nvim] ERROR: %s", msg)
  print(fmtmsg)
end

---Returns the start/end position of the current visual selection.
---@return table (start_row, start_col, end_row, end_col)
local function visual_selection_range()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  if start_row < end_row or (start_row == end_row and start_col <= end_col) then
    return start_row - 1, start_col, end_row, end_col
  else
    return end_row - 1, end_col, start_row, start_col
  end
end

---@param start_row integer
---@param start_col integer|nil
---@param end_row integer
---@param end_col integer|nil
---@return string the text within the given range
local function get_selection_text(start_row, start_col, end_row, end_col)
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  for i, line in ipairs(lines) do
    local sub_start, sub_end = 1, string.len(line)
    if i == 1 and start_col then
      sub_start = start_col
    end
    if lines[i + 1] == nil and end_col then
      sub_end = end_col
    end
    lines[i] = string.sub(line, sub_start, sub_end)
  end
  return table.concat(lines, " ")
end

function M.pointfree(is_visual_mode)
  local start_row, start_col, end_row, end_col
  if is_visual_mode then
    start_row, start_col, end_row, end_col = visual_selection_range()

    -- When in visual mode, if we use $ to go to the end of the line, the
    -- end_col is actually one more than what exists on the line, so adjust the
    -- column position accordingly.
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
    end_col = math.min(end_col, string.len(lines[#lines]))
  else
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    start_row, start_col, end_row, end_col = linenr - 1, nil, linenr, nil
  end

  local selected = get_selection_text(start_row, start_col, end_row, end_col)
  local pf_input = string.format("%s", selected)

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
          if not start_col and not end_col then
            vim.api.nvim_buf_set_lines(
              0,
              start_row,
              end_row,
              false,
              job:result()
            )
          else
            -- Single line output since we flattened multi line input
            vim.api.nvim_buf_set_text(
              0,
              start_row,
              start_col - 1,
              end_row - 1,
              end_col,
              job:result()
            )
          end
        end)
      end,
    })
    :start()
end

return M
