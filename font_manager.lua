local FontManager = {}

function FontManager.init(source)
	GtkSource = source
end

function FontManager.new(notebook)
    local self = {}
    self.current_font = ""
    self.current_font_size = ""
	function self:apply_css_to_all_tabs()
		for i = 0, notebook.notebook:get_n_pages() - 1 do
			local scrolled_window = notebook.notebook:get_nth_page(i)
			local source_view = scrolled_window:get_child()
			if GtkSource.View:is_type_of(source_view) then
				local context = source_view:get_style_context()
				context:add_class("text-view")
			end
		end
	end

	function self:set_font(font_family, font_size)
		local css_provider = Gtk.CssProvider()
		local css = string.format([[
            .text-view {
                font-family: '%s';
                font-size: %dpx;
            }
        ]], font_family:get_name(), font_size / Pango.SCALE)

		css_provider:load_from_data(css)

		local display = Gdk.Display.get_default()
		local screen = display:get_default_screen()
		Gtk.StyleContext.add_provider_for_screen(screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

		self:apply_css_to_all_tabs()
	end
    return self
end

return FontManager

