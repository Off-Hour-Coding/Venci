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
            print("Salvo com sucesso!")
        else
            print("Erro ao salvar o arquivo")
        end
    end

    function self.get_filename_from_path(path)
        local filename = path:match("[^/\\]+$")  
        return filename
    end

    return self
end

return System
