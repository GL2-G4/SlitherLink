##
# File: TestJeuGagne?.rb
# Project: Tests
# File Created: Friday, 3rd April 2020 2:57:28 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Friday, 3rd April 2020 4:02:20 pm
# Modified By: <CPietJa>Galbrun T.
#

require_relative "../Noyau/Jeu.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grille")
grille = chargeurGrille.getGrilleIndex(2)

jeu = Jeu.charger(grille)
jeu.afficherPlateau()
print "Jeu Gagné ? ", jeu.gagne?(), "\n"
print "Nb erreur(s) : ", jeu.nbErreur(), "\n"
jeu.afficherErreur(0)
jeu.afficherErreur(4)

print "\n---\n\n"

jeu = Jeu.charger_rep(grille)
jeu.jouer(3,2,:BAS,:CLIC_GAUCHE)
jeu.afficherPlateau()
print "Jeu Gagné ? ", jeu.gagne?(), "\n"
print "Nb erreur(s) : ", jeu.nbErreur(), "\n"
jeu.afficherErreur()

print "\n---\n\n"

jeu = Jeu.charger_rep(grille)
jeu.afficherPlateau()
print "Jeu Gagné ? ", jeu.gagne?(), "\n"
print "Nb erreur(s) : ", jeu.nbErreur(), "\n"
jeu.afficherErreur()