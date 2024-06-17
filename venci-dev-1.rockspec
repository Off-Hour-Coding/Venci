package = "Venci"
version = "dev-1"
source = {
   url = "git+https://github.com/Off-Hour-Coding/Venci"
}
description = {
   homepage = "https://github.com/Off-Hour-Coding/Venci",
   license = "LGPL"
}
dependencies = {
   "lua >= 5.4",
   "lgi >= 1.0"
}
build = {
   type = "builtin",
   modules = {
      app = "app.lua",
      menu_bar = "menu_bar.lua",
      notebook = "notebook.lua",
      text_editor = "text_editor.lua",
      theme_manager = "theme_manager.lua",
	  font_manager = "font_manager.lua",
	  readfile = "readfile.lua",
	  system = "system.lua",
	  keys = "keys.lua",
	  dialog = "dialog.lua",
	  page_context = "page_context.lua"
   },
   install = {
     bin = {
        venci = 'app.lua'
     }
   }
}

