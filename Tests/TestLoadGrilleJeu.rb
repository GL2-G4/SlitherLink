##
# File: TestLoadGrilleJeu.rb
# Project: Tests
# File Created: Thursday, 27th February 2020 2:56:38 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 27th February 2020 3:28:33 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../Noyau/LoadSaveGrilles/ChargeurGrille"
require path + "/../Noyau/Jeu"

chargeurGrille = ChargeurGrille.charger(path + "/../Grilles/grille")

grille = chargeurGrille.getGrilleIndex(0)
grille.afficher()

j = Jeu.charger(grille)
j.afficherPlateau()
