##
# File: Zero.rb
# Project: 1Case
# File Created: Tuesday, 3rd March 2020 3:53:25 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Friday, 6th March 2020 4:13:35 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

class Zero < Technique
    
    def initialize (description)
        super(description)
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)
        
        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                if (c.nbLigneDevantEtrePleine == 0)
                    if(c.nbLigneEtat(:BLOQUE) < 4)
                        @zone = Zone.new(i,j,i,j)
                        @lignesAModif += c.getLigneEtat(:VIDE)
                        @lignesAModif += c.getLigneEtat(:PLEINE)
                        contexte(plateau,i,j)
                        return true
                    end
                end
            end
        end
        return false
    end

    def contexte(plateau, x , y)
        voisins = getVoisins(x,y,plateau)
        
        voisins.each_index() { |i|
            voisins[i].each_index() { |j|
                if (voisins[i][j] == nil)
                    #puts "CASE[#{i};#{j}] = NIL"
                    if (i == 0 && j != 1)
                        # Coins haut et bas gauche
                        if (j == 0 && voisins[i][j+1] != nil)
                            @lignesAModif << voisins[i][j+1].getLigne(:HAUT)
                            @zone.setCoordUn(x-1,y)
                        elsif (j == 2 && voisins[i][j-1] != nil)
                            @lignesAModif << voisins[i][j-1].getLigne(:BAS)
                            @zone.setCoordUn(x-1,y)
                        elsif (voisins[i+1][j] != nil)
                            @lignesAModif << voisins[i+1][j].getLigne(:GAUCHE)
                            if(j == 0)
                                @zone.setCoordUn(x,y-1)
                            elsif(j == 2)
                                @zone.setCoordDeux(@zone.x2,y+1)
                            end
                        end
                    elsif (i == 2)
                        # Coins haut et bas droite
                        if (j == 0 && voisins[i][j+1] != nil)
                            @lignesAModif << voisins[i][j+1].getLigne(:HAUT)
                            @zone.setCoordDeux(x+1,y)
                        elsif (j == 2 && voisins[i][j-1] != nil)
                            @lignesAModif << voisins[i][j-1].getLigne(:BAS)
                            @zone.setCoordDeux(x+1,y)
                        elsif (voisins[i-1][j] != nil)
                            @lignesAModif << voisins[i-1][j].getLigne(:DROITE)
                            if(j == 0)
                                @zone.setCoordUn(x,y-1)
                            elsif(j == 2)
                                @zone.setCoordDeux(@zone.x2,y+1)
                            end
                        end
                    end
                end
            }
        }

        self
    end
end
