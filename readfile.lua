local cjson = require("cjson")
local lfs = require("lfs")

local JSONFile = {}

function JSONFile.write(path, data)
    local file = io.open(path, "w+")
    if file then
        file:write(cjson.encode_pretty(data))
        file:close()
    else
        error("Could not open file for writing: " .. path)
    end
end

function JSONFile.read(path)
    local file = io.open(path, "r")
    if not file then
        return nil, "file not found"
    end

    local content = file:read("*all")
    file:close()

    local data, decode_error = cjson.decode(content)
    if not data then
        return nil, decode_error
    end

    return data
end

function JSONFile.write_if_not_exists(path, data)
    if not lfs.attributes(path) then
        local file = io.open(path, "w")
        if file then
            file:write(cjson.encode_pretty(data))
            file:close()
        else
            error("Could not open file for writing: " .. path)
        end
    end
end

function JSONFile.update_value(path, key, new_value)
    local file = io.open(path, "r+")
    if not file then
        print("O arquivo '" .. path .. "' não foi encontrado.")
        return
    end

    local content = file:read("*all")
    local data, decode_error = cjson.decode(content)
    if not data then
        file:close()
        return nil, decode_error
    end

    data[key] = new_value
    file:seek("set", 0)
    file:write(cjson.encode_pretty(data))
    file:truncate()
    file:close()
end

function JSONFile.append(path, data)
    local file = io.open(path, "a")
    if file then
        file:write(cjson.encode_pretty(data))
        file:close()
    else
        error("Could not open file for appending: " .. path)
    end
end

return JSONFile
