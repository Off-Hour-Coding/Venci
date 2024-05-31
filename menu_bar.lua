local Dialog = require("dialog")
local System = require("system")
local Page = require("page_context")
local Font = require("font_manager")
local MenuBar = {}

function MenuBar.init(gtk, gdk, source, pango) -- pango for font stuff
	Gtk = gtk
	Gdk = gdk
	Pango = pango
	GtkSource = source
end

Dialog.init(Gtk)
Font.init(Gtk)
System.init()
Page.init()


function MenuBar.new(themeManager, notebook, window)
	local self = {}

	self.dialog = Dialog.new(window)
	self.system = System.new()
	self.page = Page.new(notebook)
	self.font = Font.new(notebook)
	self.theme_id = ""


	function self.create_new_tab(...)
		notebook:create_tab(...)
		themeManager:apply_theme_to_all_tabs(notebook.notebook, themeManager.current_theme)
		self.font:apply_css_to_all_tabs()
	end

	function self.create_menu_bar()
		local menu_bar = Gtk.MenuBar({ visible = true })
		local theme_menu = Gtk.Menu({ visible = true })
		local theme_menu_item = Gtk.MenuItem({ label = "Themes", visible = true, submenu = theme_menu })

		for _, theme_id in ipairs(themeManager:list_themes()) do
			local item = Gtk.MenuItem({ label = theme_id, visible = true })
			item.on_activate = function()
				themeManager:apply_theme_to_all_tabs(notebook.notebook, theme_id)
				themeManager.theme_id = theme_id
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
					self.font.current_font = font_family
					self.font.current_font_size = font_size
					self.font:set_font(font_family, font_size)
				end
				dialog:hide()
			end
		})

		-- file menu
		self.file_path = ""
		self.content = ""

		local file_menu = Gtk.Menu({ visible = true })
		local file_menu_item = Gtk.MenuItem({ label = "File", visible = true, submenu = file_menu })

		-- file menu options

		local new_file_item = Gtk.MenuItem({ label = "New File", visible = true })
		new_file_item.on_activate = function()
		self.create_new_tab()

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
				self.file_path = filename
				self.file_name = self.system.get_filename_from_path(filename)
				local file = io.open(filename, "r")
				if file then
					local content = file:read("*all")
					file:close()

					self.create_new_tab(content, self.file_name)
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

		local save_file_item = Gtk.MenuItem({ label = "Save File as", visible = true })
		save_file_item.on_activate = function()
			local content = self.page.get_page_content()
			self.file_path = self.dialog.save_file_dialog_box("Save File", content)
			local current_page = notebook.notebook:get_current_page()
			if current_page >= 0 then
				notebook:close_tab(current_page)
				

			end
			
			self.create_new_tab(content, self.system.get_filename_from_path(self.file_path))

			if not self.file_path then
				self.dialog.show_alert("A file is required to be saved", Gtk.MessageType.WARNING)
			end
		end

		file_menu:append(save_file_item)

		local save_current = Gtk.MenuItem({ label = "Save", visible = true })
		save_current.on_activate = (function()
			local content = self.page.get_page_content()
			if not self.system.save_file(self.file_path, content) then
				-- self.dialog.save_file_dialog_box("Save File", content)
				self.dialog.show_alert("There is no file to save", Gtk.MessageType.ERROR)
			end

		end)

		file_menu:append(save_current)

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
