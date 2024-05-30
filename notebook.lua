local Notebook = {}

function Notebook.init(gtk)
	Gtk = gtk
end

function Notebook.new(TextEditor)
	local self = {}

	self.TextEditor = TextEditor

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

	function self:create_tab(content, tab_name)
		tab_name = tab_name or "Untitled"
		local te = TextEditor.new(content)

		local tab_label_box = Gtk.Box({
			visible = true,
			spacing = 6,
			orientation = Gtk.Orientation.HORIZONTAL
		})

		local tab_label = Gtk.Label({ visible = true, label = tab_name})
		local close_button = Gtk.Button({
			visible = true,
			relief = Gtk.ReliefStyle.NONE,
			Gtk.Image({ visible = true, icon_name = "window-close-symbolic"})
		})

		tab_label_box:pack_start(tab_label, true, true, 0)
		tab_label_box:pack_start(close_button, false, false, 0)

		self.editor_tab = te.text_editor
		self.te = te

		self.notebook:append_page(
			-- Page content
			self.editor_tab,
			-- Page tab widget
			
			-- Gtk.Label({ visible = true, label = "Tab"}),
			tab_label_box
		)

		local editor_tab = self.editor_tab
		close_button.on_clicked = (function ()
			local page_num = self.notebook:page_num(editor_tab)
			self.notebook:remove_page(page_num)
		end)
	end

	local _notebook = self
	self.newTabButton.on_clicked = (function ()
		_notebook:create_tab()
	end)

	return self
end

return Notebook

