local Notebook = {}

function Notebook.init(gtk)
	Gtk = gtk
end

function Notebook.new(TextEditor)
	self = {}

	self.newTabButton = Gtk.Button({
		visible = true,
		halign = Gtk.Align.CENTER,
		margin = 10,

		Gtk.Box({
			visible = true,
			spacing = 6,
			orientation = Gtk.Orientation.HORIZONTAL,

			Gtk.Label({ visible = true, label = "New tab" }),
			Gtk.Image({ visible = true, icon_name = "list-add-symbolic" })
		})
	})

	self.notebook = Gtk.Notebook({
		visible = true,
		show_border = false,
		scrollable = true
	})

	local notebook_obj = self
	self.newTabButton.on_clicked = (function()
		local te = TextEditor.new()

		local tab_label_box = Gtk.Box({
			visible = true,
			spacing = 6,
			orientation = Gtk.Orientation.HORIZONTAL
		})

		local tab_label = Gtk.Label({ visible = true, label = "Tab"})
		local close_button = Gtk.Button({
			visible = true,
			relief = Gtk.ReliefStyle.NONE,
			Gtk.Image({ visible = true, icon_name = "window-close-symbolic"})
		})

		close_button.on_clicked = function ()
			local page_num = notebook_obj.notebook:get_current_page()
			notebook_obj.notebook:remove_page(page_num)			
		end

		tab_label_box:pack_start(tab_label, true, true, 0)
		tab_label_box:pack_start(close_button, false, false, 0)

		notebook_obj.editor_tab = te.text_editor
		notebook_obj.te = te

		notebook_obj.notebook:append_page(
			-- Page content
			notebook_obj.editor_tab,
			-- Page tab widget
			
			-- Gtk.Label({ visible = true, label = "Tab"}),
			tab_label_box
		)
	end)

	return self
end

return Notebook

