##
# File: TestT3A1LB.rb
# Project: Techniques
# File Created: Sunday, 16th February 2020 10:07:22 am
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Sunday, 16th February 2020 10:12:28 am
# Modified By: <CPietJa>Galbrun T.
#


path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Noyau/Jeu"
require path + "/../../Noyau/Ligne"
require path + "/../../Noyau/GestionTechniques/GestionTechniques"

def remplirLignes (lignes)
    for l in lignes
        l.setEtat(:PLEINE)
    end
end




j = Jeu.creer(4,3)
j.jouer(1,1,:HAUT,:CLIC_DROIT)
j.afficherPlateau()


tech = :T3A1LB
puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()


j.jouer(2,0,:HAUT,:CLIC_DROIT)
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