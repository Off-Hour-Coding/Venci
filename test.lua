local lgi = require 'lgi'
local Gtk = lgi.Gtk

Gtk.init()

local window = Gtk.Window {
    title = "Hello World",
    default_width = 800,
    default_height = 600,
    on_destroy = Gtk.main_quit
}

local label = Gtk.Label { label = "Hello, World!" }
window:add(label)
window:show_all()

Gtk.main()
