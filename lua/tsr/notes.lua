local function clean_selection()
  local mode = vim.fn.mode()

  -- Get current visual selection positions
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- Normalize so start is before end
  if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
    start_pos, end_pos = end_pos, start_pos
  end

  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- Get selected lines
  local lines = vim.fn.getline(start_line, end_line)
  if type(lines) == "string" then lines = { lines } end

  -- Trim to selection bounds (only for characterwise visual mode)
  if mode == "v" then
    if #lines == 1 then
      lines[1] = lines[1]:sub(start_col, end_col)
    else
      lines[1] = lines[1]:sub(start_col)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
  else
    -- Line mode: use full lines
    start_col = 1
    end_col = #lines[#lines]
  end

  -- Join into single string
  local text = table.concat(lines, "\n")

  -- 1. Replace newlines with spaces
  text = text:gsub("\n", " ")

  -- 2. Replace common OCR typos
  text = text:gsub(" o f ", " of ")
  text = text:gsub(" o r ", " or ")
  text = text:gsub(" t o ", " to ")

  -- 3. Combine hyphenated line breaks (char- char -> charchar)
  text = text:gsub("(%w)%- (%w)", "%1%2")

  -- 4. Ensure sentences are separated by spaces (char.char -> char. char)
  text = text:gsub("(%w%.)(%w)", "%1 %2")

  -- Replace selection with cleaned text
  vim.api.nvim_buf_set_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, { text })
end

vim.keymap.set("x", "<leader>tg", clean_selection, { desc = "Clean selected text (fix newlines, hyphens, spacing)" })
