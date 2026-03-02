-- Build: compile.sh or cmake fallback
vim.keymap.set('n', '<leader>bb', function()
  local compile_sh = vim.fn.getcwd() .. '/compile.sh'

  if vim.fn.filereadable(compile_sh) == 1 then
    local function run_compile_sh()
      vim.cmd('vsplit')
      vim.cmd('wincmd L')
      vim.cmd('vertical resize 60')
      vim.cmd('terminal')
      vim.cmd(string.format('call feedkeys("%s\\r", "t")', compile_sh))
      vim.cmd('startinsert')
      vim.notify('compile.sh ran!', vim.log.levels.INFO)
    end

    if vim.fn.executable(compile_sh) ~= 1 then
      vim.ui.input({
        prompt = 'compile.sh is not executable. Make it executable? (y/n) > ',
      }, function(input)
        if input and (input:lower() == 'y' or input:lower() == 'yes') then
          vim.fn.system(string.format('chmod +x "%s"', compile_sh))
          run_compile_sh()
        end
      end)
    else
      run_compile_sh()
    end
  else
    -- Fallback: cmake build
    vim.cmd('vsplit')
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 60')
    vim.cmd('terminal')
    vim.cmd([[
        call feedkeys("cd build\r", 't')
        call feedkeys("cmake ..\r", 't')
        call feedkeys("make\r", 't')
        call feedkeys("exit", 't')
    ]])
    vim.cmd('startinsert')
  end
end, { noremap = true, desc = "Build: compile.sh or cmake" })
