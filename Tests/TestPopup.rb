require "gtk3"
Gtk.init # Ne pas le changer de place

require_relative "../UI/Popup.rb"


p = Popup.new()

p.addBouton(titre:"Btn 2"){ puts "BTN 2" }
p.addBouton(titre:"Btn 1"){ puts "BTN 1" }
p.addBouton(titre:"Btn 3"){ p.set_titre(titre:"Vous avez 3 erreur(s)") }
p.addBouton(titre:"Quitter"){ Gtk.main_quit }

p.run()
#p.destroy()
#p.stop()
#p.run()


Gtk.main