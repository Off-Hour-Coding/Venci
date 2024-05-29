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
      full_app = "full_app.lua",
      menu_bar = "menu_bar.lua",
      notebook = "notebook.lua",
      text_editor = "text_editor.lua",
      theme_manager = "theme_manager.lua"
   },
   install = {
     bin = {
        venci = 'full_app.lua'
     }
   }
}

