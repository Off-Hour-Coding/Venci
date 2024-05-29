local Dialog = {}

function Dialog.init(gtk)
    Gtk = gtk
end

function Dialog.new(window)
    local self = {}

    function self.save_file_dialog_box(dialog_box_title, content)
        local dialog = Gtk.FileChooserDialog({
            title = dialog_box_title,
            action = Gtk.FileChooserAction.SAVE,
            transient_for = window,
            modal = true
        })
        dialog:add_button("Cancel", Gtk.ResponseType.CANCEL)
        dialog:add_button("Save", Gtk.ResponseType.ACCEPT)
        dialog:set_do_overwrite_confirmation(true)

        if dialog:run() == Gtk.ResponseType.ACCEPT then
            local filename = dialog:get_filename()
            local file = io.open(filename, "w")
            if file then
                file:write(content)
                file:close()
            end
        end
        dialog:destroy()
    end
    
    return self
end

return Dialog
