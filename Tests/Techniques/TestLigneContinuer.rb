##
# File: TestCoinLP.rb
# Project: Techniques
# File Created: Tuesday, 10th March 2020 3:46 pm
# Author: <VoxoR7>Vaudeleau M.

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

chargeurGrille = ChargeurGrille.charger(path + "/../../Grilles/grillesTestsTechniquesVoxoR7")

grille = chargeurGrille.getGrilleIndex(2)

j = Jeu.charger_rep(grille)
j.afficherPlateau()

tech = :TLC

puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()

remplirLignes(j.getLignes(tech))
j.afficherPlateau()


puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()

remplirLignes(j.getLignes(tech))
j.afficherPlateau()

puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()

remplirLignes(j.getLignes(tech))
j.afficherPlateau()

puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()

remplirLignes(j.getLignes(tech))
j.afficherPlateau()