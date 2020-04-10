##
# File: TestJeuGagne?.rb
# Project: Tests
# File Created: Friday, 3rd April 2020 2:57:28 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Sunday, 5th April 2020 6:31:51 pm
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
#jeu.afficherErreur(:index => 0)
#jeu.afficherErreur(:index => 4)
jeu.afficherErreur()

print "\n---\n\n"

jeu = Jeu.charger_rep(grille)
jeu.jouer(3,2,:BAS,:CLIC_DROIT)
jeu.jouer(3,2,:DROITE,:CLIC_GAUCHE)
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

print "\n---\n\n"

jeu = Jeu.charger(grille)
jeu.jouer(0,4,:DROITE,:CLIC_GAUCHE)
jeu.afficherPlateau()
print "Jeu Gagné ? ", jeu.gagne?(), "\n"
print "Nb erreur(s) : ", jeu.nbErreur(), "\n"
jeu.afficherErreur()

print "\n---\n\n"

jeu = Jeu.charger(grille)
jeu.afficherPlateau()
print "Jeu Gagné ? ", jeu.gagne?(), "\n"
print "Nb erreur(s) : ", jeu.nbErreur(), "\n"
e = jeu.getErreursJoueur()
jeu.afficherErreur(tabErr: e)