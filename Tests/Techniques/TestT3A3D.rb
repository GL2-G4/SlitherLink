##
# File: TestT3A3D.rb
# Project: Techniques
# File Created: Tuesday, 17th March 2020 11:21:51 am
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 18th March 2020 2:40:41 pm
# Modified By: <CPietJa>Galbrun T.
#


path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Noyau/Jeu"
require path + "/../../Noyau/Ligne"
require path + "/../../Noyau/GestionTechniques/GestionTechniques"
require path + "/../../Noyau/LoadSaveGrilles/ChargeurGrille"

def remplirLignes (lignes)
    for l in lignes
        l[0].setEtat(l[1])
    end
end

chargeurGrille = ChargeurGrille.charger(path + "/../../Grilles/grillesTestsTechniques")

grille = chargeurGrille.getGrilleIndex(8)


j = Jeu.charger_rep(grille)
j.afficherPlateau()


tech = :T3A3D
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