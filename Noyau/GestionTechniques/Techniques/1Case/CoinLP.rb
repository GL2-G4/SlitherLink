##
# File: CoinLP.rb
# Project: 1Case
# File Created: Friday, 10th March 2020 3:43 pm
# Author: <VoxoR7>Vaudeleau M.

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

# Lorsque dans un coin, une des deux lignes formant le coin est pleine, l'autre doit également être pleine.
#
# ====== Exemple ======== 
#
# . = .   .   .      . = .   .   .
#                    =
# .   .   .   . ===> .   .   .   .
#             =                  =
# .   .   .   .      .   .   . = .

class CoinLP < Technique
    
    def initialize ()
        super( "Lorsque dans un coin, une des deux lignes formant le coin est pleine, l'autre doit également être pleine.")
    end

    def chercher(plateau)
        super()

        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        #coin haut gauche
        l1 = plateau[0][0].getLigne(:HAUT)
        l2 = plateau[0][0].getLigne(:GAUCHE)

        if ( l1.etat == :PLEINE && l2.etat != :PLEINE )
            @lignesAModif << l2
            @zone = Zone.new(0,0,0,0)
            return true
        end

        if ( l2.etat == :PLEINE && l1.etat != :PLEINE )
            @lignesAModif << l1
            @zone = Zone.new(0,0,0,0)
            return true
        end

        #coin bas gauche
        l3 = plateau[0][tl-1].getLigne(:BAS)
        l4 = plateau[0][tl-1].getLigne(:GAUCHE)

        if ( l3.etat == :PLEINE && l4.etat != :PLEINE )
            @lignesAModif << l4
            @zone = Zone.new(0,tl-1,0,tl-1)
            return true
        end

        if ( l4.etat == :PLEINE && l3.etat != :PLEINE )
            @lignesAModif << l3
            @zone = Zone.new(0,tl-1,0,tl-1)
            return true
        end

        #coin haut droite
        l5 = plateau[tc-1][0].getLigne(:HAUT)
        l6 = plateau[tc-1][0].getLigne(:DROITE)

        if ( l5.etat == :PLEINE && l6.etat != :PLEINE )
            @lignesAModif << l6
            @zone = Zone.new(tc-1,0,tc-1,0)
            return true
        end

        if ( l6.etat == :PLEINE && l5.etat != :PLEINE )
            @lignesAModif << l5
            @zone = Zone.new(tc-1,0,tc-1,0)
            return true
        end

        #coin bas droite
        l7 = plateau[tc-1][tl-1].getLigne(:BAS)
        l8 = plateau[tc-1][tl-1].getLigne(:DROITE)

        if ( l7.etat == :PLEINE && l8.etat != :PLEINE )
            @lignesAModif << l8
            @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
            return true
        end

        if ( l8.etat == :PLEINE && l7.etat != :PLEINE )
            @lignesAModif << l7
            @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
            return true
        end

        return false
    end
end