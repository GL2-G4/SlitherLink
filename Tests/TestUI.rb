##
# File: TestUI.rb
# Project: Tests
# File Created: Thursday, 2nd April 2020 3:29:53 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 7th April 2020 7:07:44 pm
# Modified By: <CPietJa>Galbrun T.
#
require "gtk3"
Gtk.init # Ne pas le changer de place
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grille")
grille = chargeurGrille.getGrilleIndex(2)

jeu = Jeu.charger_rep(grille)
jUI = PartieUI.creer(jeu)

jUI.run


Gtk.main