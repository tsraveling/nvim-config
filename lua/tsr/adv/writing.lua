local function format_num(n)
  local s = tostring(n)
  local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
  out = out:gsub("^,", "")
  return out
end

local function count_words(text)
  local n = 0
  for _ in text:gmatch("%S+") do
    n = n + 1
  end
  return n
end

local function heading_level(line)
  local hashes = line:match("^(#+)%s")
  if hashes then return #hashes end
  return nil
end

vim.keymap.set('n', '<leader>mca', function()
  local words = vim.fn.wordcount().words
  vim.notify(string.format("%s words", format_num(words)))
end, { desc = "Count words in file" })

vim.keymap.set('n', '<leader>mcs', function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cur = vim.api.nvim_win_get_cursor(0)[1]

  local start_idx, level, heading_text
  for i = cur, 1, -1 do
    local lvl = heading_level(lines[i])
    if lvl then
      start_idx = i
      level = lvl
      heading_text = lines[i]:match("^#+%s+(.*)")
      break
    end
  end

  if not start_idx then
    vim.notify("No markdown heading found above cursor", vim.log.levels.WARN)
    return
  end

  local end_idx = #lines
  for i = start_idx + 1, #lines do
    local lvl = heading_level(lines[i])
    if lvl and lvl <= level then
      end_idx = i - 1
      break
    end
  end

  local body = table.concat(vim.list_slice(lines, start_idx + 1, end_idx), " ")
  local words = count_words(body)
  vim.notify(string.format("%s words in %s", format_num(words), heading_text))
end, { desc = "Count words in current markdown section" })
