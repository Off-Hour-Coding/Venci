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

		notebook_obj.editor_tab = te.text_editor
		notebook_obj.te = te

		notebook_obj.notebook:append_page(
			-- Page content
			notebook_obj.editor_tab,
			-- Page tab widget
			Gtk.Label({ visible = true, label = "Tab"})
		)
	end)

	return self
end

return Notebook

