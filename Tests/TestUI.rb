##
# File: TestUI.rb
# Project: Tests
# File Created: Thursday, 2nd April 2020 3:29:53 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Friday, 3rd April 2020 10:53:12 pm
# Modified By: <CPietJa>Galbrun T.
#
require "gtk3"
Gtk.init # Ne pas le changer de place
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grille")
grille = chargeurGrille.getGrilleIndex(0)

jeu = Jeu.charger_rep(grille)
jUI = PartieUI.creer(jeu)

jUI.run


Gtk.main