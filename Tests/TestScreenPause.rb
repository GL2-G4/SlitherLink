
require "gtk3"
Gtk.init # Ne pas le changer de place

require_relative "../UI/ScreenPause.rb"

window = Gtk::Window.new.set_default_size(400,200)
window.signal_connect("delete-event") { Gtk.main_quit }

sP = ScreenPause.new
window.add(sP)

window.show_all

Gtk.main