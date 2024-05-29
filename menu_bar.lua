local MenuBar = {}

function MenuBar.init(gtk, gdk, source, pango) -- pango for font stuff
	Gtk = gtk
	Gdk = gdk
	Pango = pango
	GtkSource = source
end

function MenuBar.new(themeManager, notebook, window)
	local self = {}

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

	function self.create_menu_bar()
		local menu_bar = Gtk.MenuBar({ visible = true })
		local theme_menu = Gtk.Menu({ visible = true })
		local theme_menu_item = Gtk.MenuItem({ label = "Themes", visible = true, submenu = theme_menu })

		self.current_theme = nil
		-- Populate the theme menu with available themes
		for _, theme_id in ipairs(themeManager:list_themes()) do
			local item = Gtk.MenuItem({ label = theme_id, visible = true })
			item.on_activate = function()
				themeManager:apply_theme_to_all_tabs(notebook.notebook, theme_id)
				self.current_theme = theme_id
			end
			theme_menu:append(item)
		end


		local font_menu = Gtk.Menu({ visible = true })
		local font_menu_item = Gtk.MenuItem({ label = "Font", visible = true, submenu = font_menu })
		local font_dialog = Gtk.FontChooserDialog({
			title = "Select Font",
			--action = Gtk.FontChooserAction.SET_FONT,
			visible = false,
			on_response = function(dialog, response_id)
				if response_id == Gtk.ResponseType.OK then
					local font_family = dialog:get_font_family()
					local font_size = dialog:get_font_size()
					self:set_font(font_family, font_size)
				end
				dialog:hide()
			end
		})


		-- file menu

		local file_menu = Gtk.Menu({ visible = true })
		local file_menu_item = Gtk.MenuItem({ label = "File", visible = true, submenu = file_menu })

		-- file menu options

		local new_file_item = Gtk.MenuItem({ label = "New File", visible = true })
		new_file_item.on_activate = function()
			print("Selected file")
		end

		file_menu:append(new_file_item)

		local open_file_item = Gtk.MenuItem({ label = "Open file", visible = true })
		open_file_item.on_activate = function()
			local dialog = Gtk.FileChooserDialog({
				title = "Open File",
				action = Gtk.FileChooserAction.OPEN,
				transient_for = window,
				modal = true
			})
			dialog:add_button("Cancel", Gtk.ResponseType.CANCEL)
			dialog:add_button("Open", Gtk.ResponseType.ACCEPT)

			if dialog:run() == Gtk.ResponseType.ACCEPT then
				local filename = dialog:get_filename()
				local file = io.open(filename, "r")
				if file then
					local content = file:read("*all")
					file:close()

					notebook:create_tab(content)

					if not self.current_theme then
						dialog:destroy()
						return
					end
					themeManager:apply_theme_to_all_tabs(notebook.notebook, self.current_theme)
				end
			end

			dialog:destroy()
		end

		file_menu:append(open_file_item)

		local save_file_item = Gtk.MenuItem({ label = "Save File", visible = true})
		save_file_item.on_activate = function ()
			print("Save file option")
		end

		file_menu:append(save_file_item)

		local font_dialog_button = Gtk.MenuItem({ label = "Select Font...", visible = true })
		font_dialog_button.on_activate = function()
			font_dialog:show_all()
		end

		menu_bar:append(file_menu_item)
		menu_bar:append(theme_menu_item)
		font_menu:append(font_dialog_button)
		menu_bar:append(font_menu_item)

		return menu_bar
	end

	return self
end

return MenuBar
