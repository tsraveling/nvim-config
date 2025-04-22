-- Function to create a .cpp file with stubs for functions in a .h file
function CreateCppStubs()
  -- Get current buffer filename
  local current_file = vim.fn.expand('%:p')

  -- Check if it's a header file
  if not string.match(current_file, "%.h$") then
    print("Current file is not a header file (.h)")
    return
  end

  -- Get the corresponding cpp file path
  local cpp_file = string.gsub(current_file, "%.h$", ".cpp")

  -- Check if cpp file exists
  local cpp_exists = vim.fn.filereadable(cpp_file) == 1

  -- Parse the header file for class and function declarations
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local class_name = nil
  local functions = {}
  local namespace = nil

  -- Parse header content
  for _, line in ipairs(lines) do
    -- Check for namespace
    local ns_match = string.match(line, "namespace%s+([%w_]+)")
    if ns_match then
      namespace = ns_match
    end

    -- Check for class declaration
    local class_match = string.match(line, "class%s+([%w_]+)")
    if class_match then
      class_name = class_match
    end

    -- Check for function declarations (exclude inline, pure virtual, and constructors/destructors)
    if class_name then
      -- Match function declarations
      local fn_name, fn_params = string.match(line, "%s*([%w_~]+)%s*%((.-)%)%s*;")

      -- If we found a function name and it's not already inline or pure virtual
      if fn_name and not string.match(line, "=%s*0%s*;") and not string.match(line, "{.*}") then
        -- Skip constructors/destructors if they're marked inline or default
        local is_ctor_dtor = (fn_name == class_name or fn_name == "~" .. class_name)
        local is_inline = string.match(line, "inline")
        local is_default = string.match(line, "=%s*default%s*;")

        if not (is_ctor_dtor and (is_inline or is_default)) then
          -- Get return type (simplified - doesn't handle all cases)
          local return_type = string.match(line, "%s*([%w_:%*&<>]+)%s+[%w_~]+%s*%(")

          -- If unable to get return type, use a default
          return_type = return_type or "void"

          -- Store function info
          table.insert(functions, {
            name = fn_name,
            params = fn_params,
            return_type = return_type
          })
        end
      end
    end
  end

  if #functions == 0 then
    print("No functions found in the header file")
    return
  end

  -- If cpp file doesn't exist, create it
  local cpp_content = {}
  if not cpp_exists then
    -- Add include directive
    table.insert(cpp_content, "#include \"" .. vim.fn.fnamemodify(current_file, ":t") .. "\"")
    table.insert(cpp_content, "")

    -- Add namespace if found
    if namespace then
      table.insert(cpp_content, "namespace " .. namespace .. " {")
      table.insert(cpp_content, "")
    end

    -- Create file with stub implementations
    local file = io.open(cpp_file, "w")
    if file then
      for _, fn in ipairs(functions) do
        local fn_signature = string.format("%s %s::%s(%s)",
          fn.return_type,
          class_name,
          fn.name,
          fn.params)
        table.insert(cpp_content, fn_signature)
        table.insert(cpp_content, "{")

        -- Add return statement if needed
        if fn.return_type ~= "void" then
          -- Basic default return values based on type
          if string.match(fn.return_type, "bool") then
            table.insert(cpp_content, "    return false;")
          elseif string.match(fn.return_type, "int") or string.match(fn.return_type, "size_t") then
            table.insert(cpp_content, "    return 0;")
          elseif string.match(fn.return_type, "float") or string.match(fn.return_type, "double") then
            table.insert(cpp_content, "    return 0.0;")
          elseif string.match(fn.return_type, "char%s*%*") or string.match(fn.return_type, "std::string") then
            table.insert(cpp_content, "    return \"\";")
          elseif string.match(fn.return_type, "std::vector") then
            table.insert(cpp_content, "    return {};")
          else
            table.insert(cpp_content, "    return {};")
          end
        end

        table.insert(cpp_content, "}")
        table.insert(cpp_content, "")
      end

      -- Close namespace if it exists
      if namespace then
        table.insert(cpp_content, "} // namespace " .. namespace)
      end

      -- Write to file
      file:write(table.concat(cpp_content, "\n"))
      file:close()
      print("Created " .. cpp_file .. " with " .. #functions .. " function stubs")
    else
      print("Failed to create " .. cpp_file)
    end
  else
    -- If cpp file exists, read it and add missing functions
    local file = io.open(cpp_file, "r")
    local existing_content = {}
    if file then
      for line in file:lines() do
        table.insert(existing_content, line)
      end
      file:close()
    end

    -- Convert content to a single string for easier searching
    local content_str = table.concat(existing_content, "\n")

    -- Check for each function if it exists in cpp
    local new_functions = {}
    for _, fn in ipairs(functions) do
      -- Create function signature pattern to match in cpp file
      local fn_pattern = string.gsub(fn.name, "([^%w])", "%%%1") -- Escape special characters
      local pattern = string.format("%s[%%s%%n%%r%%t]*%s::%s[%%s%%n%%r%%t]*%%(",
        fn.return_type,
        class_name,
        fn_pattern)

      -- If function not found in cpp content, add it
      if not string.find(content_str, pattern) then
        table.insert(new_functions, fn)
      end
    end

    -- If there are functions to add
    if #new_functions > 0 then
      -- Append new functions to file
      local file = io.open(cpp_file, "a")
      if file then
        file:write("\n")

        for _, fn in ipairs(new_functions) do
          local fn_signature = string.format("%s %s::%s(%s)",
            fn.return_type,
            class_name,
            fn.name,
            fn.params)
          file:write(fn_signature .. "\n")
          file:write("{\n")

          -- Add return statement if needed
          if fn.return_type ~= "void" then
            -- Basic default return values based on type
            if string.match(fn.return_type, "bool") then
              file:write("    return false;\n")
            elseif string.match(fn.return_type, "int") or string.match(fn.return_type, "size_t") then
              file:write("    return 0;\n")
            elseif string.match(fn.return_type, "float") or string.match(fn.return_type, "double") then
              file:write("    return 0.0;\n")
            elseif string.match(fn.return_type, "char%s*%*") or string.match(fn.return_type, "std::string") then
              file:write("    return \"\";\n")
            elseif string.match(fn.return_type, "std::vector") then
              file:write("    return {};\n")
            else
              file:write("    return {};\n")
            end
          end

          file:write("}\n\n")
        end

        file:close()
        print("Added " .. #new_functions .. " function stubs to " .. cpp_file)
      else
        print("Failed to open " .. cpp_file .. " for appending")
      end
    else
      print("All functions already implemented in " .. cpp_file)
    end
  end
end

-- Add command to Neovim
vim.api.nvim_create_user_command("CreateCppStubs", CreateCppStubs, {})

