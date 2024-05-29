local Keys = {}

function Keys.init(gtk, gobj)
    Gtk = gtk
    GObject = gobj
end

function Keys.new()
    local self = {}

    self.accel_group = Gtk.AccelGroup()


    function self.bind_key(mod, key, f)
        local closure = GObject.Closure(f)
        
        self.accel_group:connect(key, mod, Gtk.AccelFlags.VISIBLE, closure)
    end

    return self
end

return Keys
