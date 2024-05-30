local System = {}

function System.init()
    -- Aqui você poderia realizar alguma inicialização se necessário
end

function System.new()
    local self = {}

    function self.save_file(path, content)
        local file = io.open(path, "w")
        if file then
            file:write(content)
            file:close()
            return true
        end
        return false
    end

    function self.get_filename_from_path(path)
        local filename = path:match("[^/\\]+$")  
        return filename
    end

    function self.print_table(t, indent)
        indent = indent or 0
        local formatting = string.rep("  ", indent)
    
        if type(t) ~= "table" then
            print(formatting .. tostring(t))
            return
        end
    
        for k, v in pairs(t) do
            local key_str = formatting .. tostring(k) .. ": "
            if type(v) == "table" then
                print(key_str)
                self.print_table(v, indent + 1)
            else
                print(key_str .. tostring(v))
            end
        end
    end
    return self
end

return System
