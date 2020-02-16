##
# File: TestT2A2LB.rb
# Project: Techniques
# File Created: Saturday, 15th February 2020 4:31:54 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Saturday, 15th February 2020 4:37:13 pm
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
j.jouer(1,1,:BAS,:CLIC_DROIT)
j.afficherPlateau()


tech = :T2A2LB
puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()


j.jouer(2,1,:HAUT,:CLIC_DROIT)
j.jouer(2,1,:DROITE,:CLIC_DROIT)
j.afficherPlateau()

puts "Recherche : " + j.chercher(tech).to_s()
puts "Zone : " + j.getZone(tech).to_s()
puts "Lignes : " + j.getLignes(tech).to_s()


remplirLignes(j.getLignes(tech))
j.afficherPlateau()
