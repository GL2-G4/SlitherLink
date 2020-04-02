##
# File: CoinLB.rb
# Project: 1Case
# File Created: Friday, 10th March 2020 3:12 pm
# Author: <VoxoR7>Vaudeleau M.

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

# Lorsque dans un coin, une des deux lignes formant le coin est bloqué, l'autre doit également être bloqué.
#
# ====== Exemple ======== 
#
# . x .   .   .      . x .   .   .
#                    x
# .   .   .   . ===> .   .   .   .
#             x                  x
# .   .   .   .      .   .   . x .

class CoinLB < Technique
    
    def initialize ()
        super( "Lorsque dans un coin, une des deux lignes formant le coin est bloqué, l'autre doit également être bloqué.")
    end

    def chercher(plateau)
        super()

        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        #coin haut gauche
        l1 = plateau[0][0].getLigne(:HAUT)
        l2 = plateau[0][0].getLigne(:GAUCHE)

        if ( l1.etat == :BLOQUE && l2.etat != :BLOQUE )
            ligneAvecEtat(l2, :BLOQUE)
            @zone = Zone.new(0,0,0,0)
            return true
        end

        if ( l2.etat == :BLOQUE && l1.etat != :BLOQUE )
            ligneAvecEtat(l1, :BLOQUE)
            @zone = Zone.new(0,0,0,0)
            return true
        end

        #coin bas gauche
        l3 = plateau[0][tl-1].getLigne(:BAS)
        l4 = plateau[0][tl-1].getLigne(:GAUCHE)

        if ( l3.etat == :BLOQUE && l4.etat != :BLOQUE )
            ligneAvecEtat(l4, :BLOQUE)
            @zone = Zone.new(0,tl-1,0,tl-1)
            return true
        end

        if ( l4.etat == :BLOQUE && l3.etat != :BLOQUE )
            ligneAvecEtat(l3, :BLOQUE)
            @zone = Zone.new(0,tl-1,0,tl-1)
            return true
        end

        #coin haut droite
        l5 = plateau[tc-1][0].getLigne(:HAUT)
        l6 = plateau[tc-1][0].getLigne(:DROITE)

        if ( l5.etat == :BLOQUE && l6.etat != :BLOQUE )
            ligneAvecEtat(l6, :BLOQUE)
            @zone = Zone.new(tc-1,0,tc-1,0)
            return true
        end

        if ( l6.etat == :BLOQUE && l5.etat != :BLOQUE )
            ligneAvecEtat(l5, :BLOQUE)
            @zone = Zone.new(tc-1,0,tc-1,0)
            return true
        end

        #coin bas droite
        l7 = plateau[tc-1][tl-1].getLigne(:BAS)
        l8 = plateau[tc-1][tl-1].getLigne(:DROITE)

        if ( l7.etat == :BLOQUE && l8.etat != :BLOQUE )
            ligneAvecEtat(l8, :BLOQUE)
            @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
            return true
        end

        if ( l8.etat == :BLOQUE && l7.etat != :BLOQUE )
            ligneAvecEtat(l7, :BLOQUE)
            @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
            return true
        end

        return false
    end
end