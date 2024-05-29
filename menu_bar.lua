local MenuBar = {}

function MenuBar.init(gtk, source, pango) -- pango for font stuff
	Gtk = gtk
	Pango = pango
	GtkSource = source
end

function MenuBar.new(themeManager, fontManager, notebook)
    local self = {}

	function self:set_font(font_desc)
		local font_css = "* { font-family: 'Ubuntu Mono Regular';}"
		
		local css_provider = Gtk.CssProvider()
		css_provider:load_from_data(font_css)

		local context = notebook:get_style_context()
		context:add_provider(css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

		local buffer_list = notebook:get_children()
		for _, child in ipairs(buffer_list) do
			local view = child:get_child()
			view:set_override_font(font_description)
		end
	end

    function self.create_menu_bar()
        local menu_bar = Gtk.MenuBar({ visible = true })
        local theme_menu = Gtk.Menu({ visible = true })
        local theme_menu_item = Gtk.MenuItem({ label = "Themes", visible = true, submenu = theme_menu })

        -- Populate the theme menu with available themes
        for _, theme_id in ipairs(themeManager:list_themes()) do
            local item = Gtk.MenuItem({ label = theme_id, visible = true })
            item.on_activate = function()
                themeManager:apply_theme_to_all_tabs(notebook, theme_id)
            end
            theme_menu:append(item)
        end

        menu_bar:append(theme_menu_item)

		local font_menu = Gtk.Menu({ visible = true })
		local font_menu_item = Gtk.MenuItem({ label = "Font", visible = true, submenu = font_menu })

		local font_dialog = Gtk.FontChooserDialog({
			title = "Select Font",
			--action = Gtk.FontChooserAction.SET_FONT,
			visible = false,
			on_response = function(dialog, response_id)
				if response_id == Gtk.ResponseType.OK then
					local font_desc = dialog:get_font()
					self:set_font(font_desc)
				end
				dialog:hide()
			end
		})

		local font_dialog_button = Gtk.MenuItem({ label = "Select Font...", visible = true })
		font_dialog_button.on_activate = function()
			font_dialog:show_all()
		end

		font_menu:append(font_dialog_button)
		menu_bar:append(font_menu_item)

        return menu_bar
    end

    return self
end

return MenuBar

