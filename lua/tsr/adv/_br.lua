-- The runner method
local function run_it(do_log)
  local is_scons = vim.fn.filereadable('SConstruct') == 1
  local is_cmake = vim.fn.filereadable('CMakeLists.txt') == 1
  local is_ninja = vim.fn.filereadable('build/build.ninja') == 1 or vim.fn.filereadable('build.ninja') == 1
  local is_godot = vim.fn.filereadable('project.godot') == 1
  local is_sh = vim.bo.filetype == 'sh' or vim.bo.filetype == 'zsh'
  local is_treesitter = vim.fn.filereadable('tree-sitter.json') == 1
  local is_go = vim.fn.filereadable('go.mod') == 1
  local is_go_server = is_go and vim.fn.filereadable('cmd/main.go') == 1
  local is_rust = vim.fn.filereadable('cargo.toml') == 1

  -- Helper function to create terminal window
  local function create_terminal_window()
    vim.cmd('vsplit')
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 80')
    vim.cmd('terminal')
  end

  local function build_cmake(build_tar)
    create_terminal_window()
    local configure = is_ninja and "cmake -G Ninja .." or "cmake .."
    local builder = is_ninja and "ninja" or "make"
    vim.cmd(string.format('call feedkeys("cd build\\r", "t")'))
    vim.cmd(string.format('call feedkeys("%s && %s && ", "t")', configure, builder))
    vim.cmd(string.format('call feedkeys("./%s", "t")', build_tar))
    if (do_log) then
      vim.cmd([[call feedkeys(" > log.txt", 't')]])
    end
    vim.cmd([[call feedkeys("\r", 't')]])
    -- vim.cmd([[call feedkeys("exit", 't')]]) -- prefills exit, useful for simple runs
    vim.cmd('startinsert')
  end

  if is_sh then
    local current_file = vim.fn.expand('%:p') -- Get full path of current buffer
    local is_executable = vim.fn.executable(current_file) == 1

    local function execute_script()
      create_terminal_window()
      if do_log then
        vim.cmd(string.format('call feedkeys("%s > log.txt\\r", "t")', current_file))
      else
        vim.cmd(string.format('call feedkeys("%s\\r", "t")', current_file))
      end
      vim.cmd('startinsert')
    end

    if not is_executable then
      vim.ui.input({
        prompt = string.format("Make %s executable? (y/n) > ", vim.fn.expand('%:t'))
      }, function(input)
        if input and (input:lower() == 'y' or input:lower() == 'yes') then
          vim.fn.system(string.format('chmod +x "%s"', current_file))
          execute_script()
        end
      end)
    else
      execute_script()
    end
  elseif is_treesitter then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("tree-sitter generate > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("tree-sitter generate\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  elseif is_go_server then
    -- Server pattern: kill process on port, then run
    local project_id = vim.fn.getcwd()
    if not _G.project_server_ports then
      _G.project_server_ports = {}
    end

    local function run_server(port)
      create_terminal_window()
      -- Kill existing process on port, then start server
      local kill_cmd = string.format("lsof -ti:%s | xargs kill -9 2>/dev/null; ", port)
      local run_cmd = string.format("go run ./cmd -port %s", port)
      if do_log then
        run_cmd = run_cmd .. " > log.txt"
      end
      vim.cmd(string.format('call feedkeys("%s%s\\r", "t")', kill_cmd, run_cmd))
      vim.cmd('startinsert')
    end

    if not _G.project_server_ports[project_id] then
      vim.ui.input({ prompt = "Server port > " }, function(port)
        if port and port ~= "" then
          _G.project_server_ports[project_id] = port
          run_server(port)
        end
      end)
    else
      run_server(_G.project_server_ports[project_id])
    end
  elseif is_go then
    -- Simple go project (bubbletea, CLI, etc)
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("go run . > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("go run .\\r", "t")')
    end
    vim.cmd('startinsert')
  elseif is_cmake then
    -- Use current working directory as project identifier
    local project_id = vim.fn.getcwd()

    -- Use a table to store targets by project
    if not _G.project_build_targets then
      _G.project_build_targets = {}
    end

    -- Check if we have a stored target for this project
    if not _G.project_build_targets[project_id] then
      vim.ui.input({ prompt = "Target >" }, function(build_tar)
        -- Store the target for this project
        _G.project_build_targets[project_id] = build_tar
        build_cmake(build_tar)
      end)
    else
      -- Use the stored target
      build_cmake(_G.project_build_targets[project_id])
    end
  elseif is_scons then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("scons > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("scons\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  elseif is_rust then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("cargo run > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("cargo run\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  elseif is_godot then
    create_terminal_window()
    if do_log then
      vim.cmd('call feedkeys("godot . > log.txt\\r", "t")')
    else
      vim.cmd('call feedkeys("godot .\\r", "t")')
    end
    vim.cmd('call feedkeys("exit", "t")')
    vim.cmd('startinsert')
  else
    vim.notify("Not cmake, scons, Godot, or shell script.", vim.log.levels.WARN)
  end
end

-- Async build to qflist (cmake/ninja/make C++ projects)
local function build_to_qf()
  local has_ninja = vim.fn.filereadable('build/build.ninja') == 1
  local has_make = vim.fn.filereadable('build/Makefile') == 1
  local has_cmake = vim.fn.filereadable('CMakeLists.txt') == 1

  if not (has_ninja or has_make or has_cmake) then
    vim.notify("No cmake/ninja/make project detected.", vim.log.levels.WARN)
    return
  end

  if has_cmake and not (has_ninja or has_make) then
    vim.notify("Run cmake config first (build/ not configured).", vim.log.levels.WARN)
    return
  end

  local cmd = has_ninja and { 'ninja', '-C', 'build' } or { 'make', '-C', 'build' }
  local output = {}

  local function collect(_, data)
    if not data then return end
    for _, line in ipairs(data) do
      if line ~= "" then table.insert(output, line) end
    end
  end

  vim.notify("Build: " .. table.concat(cmd, ' '))
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = collect,
    on_stderr = collect,
    on_exit = function(_, code)
      vim.fn.setqflist({}, ' ', {
        title = 'Build: ' .. table.concat(cmd, ' '),
        lines = output,
        efm = vim.o.errorformat,
      })
      if code == 0 then
        vim.notify("Build OK", vim.log.levels.INFO)
        vim.cmd('cclose')
      else
        vim.notify("Build failed (exit " .. code .. ")", vim.log.levels.ERROR)
        vim.cmd('botright copen')
      end
    end,
  })
end

-- Run the software in various environments
vim.keymap.set('n', "<leader>br", function()
  run_it(false)
end)

-- Run the software in various environments and log to log.txt
vim.keymap.set('n', "<leader>bR", function()
  run_it(true)
end)

-- Build to quickfix list (errors parsed via errorformat)
vim.keymap.set('n', "<leader>bq", build_to_qf)
