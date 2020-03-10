##
# File: Technique.rb
# Project: Techniques
# File Created: Friday, 14th February 2020 5:30:28 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 10th March 2020 3:58:44 pm
# Modified By: <CPietJa>Galbrun T.
#

##
# * ===Description
# Une Technique est une classe abstraite permettant la
# recherche d'une technique dans un plateau de Case.
#
# * ===Méthodes d'instance
# [chercher] Renvoie vrai si la technique a réussi, faux
# par défaut, met à jour les variables d'instances :
# zone et lignesAModif.
#
# * ===Variables d'instance
# [description] Description de la technique.
# [zone] Zone où a réussi la technique.
# [lignesAModif] Tableau de Ligne qui peuvent être modifiées.
#
class Technique
    # Reader
    attr_reader :zone, :lignesAModif
    # Accessor
    attr_accessor :description

    def initialize (description)
        @description = description
        @zone = nil
        @lignesAModif = []
    end

    def chercher
        @zone = nil
        @lignesAModif = []
        return false
    end

    def to_s
        s = "=== Description ===\n" + @description.to_s()
        s += "\n=== Zone ===\n" + @zone.to_s()
        s += "\n=== Lignes ===\n" + @lignesAModif.to_s()
        return s
    end

    private
    # Renvoie la taille de la 2eme dimension du plateau
    def getTailleLigne (plateau)
        return plateau[0].size()
    end

    # Renvoie la taille du plateau
    def getTailleColonne (plateau)
        return plateau.size()
    end

    # Renvoie la liste des voisins pour une case donnée
    def getVoisins ( x , y , plateau )
        voisins = Array.new(3){ |c| c = Array.new(3,nil) }
        -1.upto(1){ |i|
            -1.upto(1){ |j|
                begin
                    voisins[i+1][j+1] = plateau[x+i][y+j]
                rescue => e
                    voisins[i+1][j+1] = nil
                end
            }
        }
        return voisins
    end

    # Regarde le contexte d'une technique
    def contexte (plateau, x, y)
        return self
    end

end

class TechniqueError < RuntimeError
end