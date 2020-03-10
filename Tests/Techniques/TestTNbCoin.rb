##
# File: TestT1.rb
# Project: Techniques
# File Created: Tuesday, 3rd March 2020 4:18:24 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 10th March 2020 2:47:37 pm
# Modified By: <CPietJa>Galbrun T.
#


path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Noyau/Jeu"
require path + "/../../Noyau/Ligne"
require path + "/../../Noyau/GestionTechniques/GestionTechniques"
require path + "/../../Noyau/LoadSaveGrilles/ChargeurGrille"

def remplirLignes (lignes)
    for l in lignes
        l.setEtat(:PLEINE)
    end
end

chargeurGrille = ChargeurGrille.charger(path + "/../../Grilles/grillesTestsTechniques")

grille = chargeurGrille.getGrilleIndex(4)


j = Jeu.charger_rep(grille)
j.afficherPlateau()


tech = :TNBCOIN
puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()


puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()


puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()


puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()