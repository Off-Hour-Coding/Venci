local TextEditor = {}

function TextEditor.init(gtk, source)
	Gtk = gtk
	GtkSource = source
end

function TextEditor.new()
	self = {}

	self.text_buffer = GtkSource.Buffer {}
	self.text_view = GtkSource.View {
		buffer = self.text_buffer,
		--wrap_mode = 'WORD',
		visible = true,
		show_line_numbers = true
	}

	self.text_buffer:set_language(GtkSource.LanguageManager():get_language("lua"))
	self.text_buffer:set_highlight_syntax(true)

	self.text_editor = Gtk.ScrolledWindow {
		expand = true,
		visible = true,
		child = self.text_view
	}

	return self
end

return TextEditor

