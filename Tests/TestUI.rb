##
# File: TestUI.rb
# Project: Tests
# File Created: Thursday, 2nd April 2020 3:29:53 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Friday, 10th April 2020 5:22:21 pm
# Modified By: <CPietJa>Galbrun T.
#
require "gtk3"
Gtk.init # Ne pas le changer de place
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grille")
grille = chargeurGrille.getGrilleIndex(3)

jeu = Jeu.charger(grille)
w,h = 600,500
window = Gtk::Window.new.set_default_size(w,h)
window.signal_connect("delete-event") { Gtk.main_quit }

uiP = PartieUI.creer(jeu,w,h)
window.add(uiP)

window.show_all


Gtk.main