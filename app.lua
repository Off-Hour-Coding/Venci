local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gdk = lgi.require("Gdk")
local Pango = lgi.require("Pango")
local GtkSource = lgi.require("GtkSource", "3.0")
local GObject = lgi.GObject



local ThemeManager = require("theme_manager")
local TextEditor = require("text_editor")
local Notebook = require("notebook")
local MenuBar = require("menu_bar")
local Keys = require("keys")
local System = require("system")
local Page = require("page_context")

-- Init sets Gtk and GtkSource for modules
ThemeManager.init(GtkSource)
TextEditor.init(Gtk, GtkSource)
Notebook.init(Gtk)
MenuBar.init(Gtk, Gdk, GtkSource, Pango)
Keys.init(Gtk, GObject)

local appID = "tsukigva2-kerlon.text.app"
local appTitle = "Venci"
local app = Gtk.Application({ application_id = appID })

function app:on_startup()
    local win = Gtk.ApplicationWindow({
        title = appTitle,
        application = self,
        default_width = 1000,
        default_height = 800
    })

    local keys = Keys.new()
    System.init()
    Page.init()

    win:add_accel_group(keys.accel_group)

    local notebook = Notebook.new(TextEditor)

    local themeManager = ThemeManager.new()

    local menuBar = MenuBar.new(themeManager, notebook, win)

    local page = Page.new(notebook)
   
    local system = System.new()

    local box = Gtk.Box({
        visible = true,
        orientation = Gtk.Orientation.VERTICAL
    })

    keys.bind_key(Gdk.ModifierType.CONTROL_MASK, Gdk.KEY_s, (function ()
        system.save_file(menuBar.file_path, page.get_page_content())
    end))

    box:pack_start(menuBar.create_menu_bar(), false, false, 0)
    box:pack_start(notebook.notebook, true, true, 0)
    box:pack_start(notebook.newTabButton, false, false, 0)

    win:add(box)
    win:show_all()
end

function app:on_activate()
    self.active_window:present()
end

return app:run(arg)

