##
# File: TestUI.rb
# Project: Tests
# File Created: Thursday, 2nd April 2020 3:29:53 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 2nd April 2020 4:25:17 pm
# Modified By: <CPietJa>Galbrun T.
#
require "gtk3"
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

Gtk.init

chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grille")
grille = chargeurGrille.getGrilleIndex(0)

jeu = Jeu.charger_rep(grille)
jUI = PartieUI.creer(jeu)

jUI.run


Gtk.main