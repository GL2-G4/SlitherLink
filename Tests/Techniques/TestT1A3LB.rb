##
# File: TestT1A3LB.rb
# Project: Techniques
# File Created: Saturday, 15th February 2020 2:11:49 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 27th February 2020 10:01:52 pm
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

grille = chargeurGrille.getGrilleIndex(0)


j = Jeu.charger_rep(grille)
j.afficherPlateau()


tech = :T1A3LB
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