local ThemeManager = {}

function ThemeManager.init(source)
	GtkSource = source
end

function ThemeManager.new()
    local self = {}

    self.style_scheme_man = GtkSource.StyleSchemeManager.get_default()

    function self:list_themes()
        return self.style_scheme_man:get_scheme_ids()
    end

    function self.set_theme(buffer, theme_name)
        local style_scheme_manager = GtkSource.StyleSchemeManager.get_default()
        local style_scheme = style_scheme_manager:get_scheme(theme_name)
        if style_scheme then
            buffer:set_style_scheme(style_scheme)
        else
            print("Theme '" .. theme_name .. "' not found.")
        end
    end

    function self:apply_theme_to_all_tabs(notebook, theme_name)
        for i = 0, notebook:get_n_pages() - 1 do
            local scrolled_window = notebook:get_nth_page(i)
            local source_view = scrolled_window:get_child()
            if GtkSource.View:is_type_of(source_view) then
                local buffer = source_view:get_buffer()
                self.set_theme(buffer, theme_name)
            end
        end
    end

    return self
end

return ThemeManager

