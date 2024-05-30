local Page = {}

function Page.init()
    
end

function Page.new(notebook)
    local self = {}

    function self.get_page_content()
        local current_page = notebook.notebook:get_current_page()
        if current_page >= 0 then
            local nth_page = notebook.notebook:get_nth_page(current_page)
            local sourceview = nth_page:get_child()
            local buf = sourceview:get_buffer()
            local content = buf:get_text(buf:get_start_iter(), buf:get_end_iter())
            return content
        end
    end

    return self
end

return Page
