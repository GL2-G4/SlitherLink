##
# File: TroisAvecTroisLP.rb
# Project: 1Case
# File Created: Friday, 14th February 2020 6:02:07 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 15th April 2020 2:28:18 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 3 à 3 lignes pleines récupère
    la ligne qui peut être rempli.
    Ex:
    . = .       . = .
    = 3      => = 3 x
    . = .       . = .
=end
class TroisAvecTroisLP < Technique
    
    def initialize ()
        super("T3A3LP")
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)
        
        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                # On cherche la case contenant un 3 et répondant aux conditions
                # de la technique, puis on récupère la ligne.
                if (c.nbLigneDevantEtrePleine == 3)
                    if(c.nbLigneEtat(:BLOQUE) == 0 && c.nbLigneEtat(:PLEINE) == 3)
                        @zone = Zone.new(i,j,i,j)
                        lignesAvecEtat(c.getLigneEtat(:VIDE), :BLOQUE)
                        return true
                    end
                end
            end
        end
        return false
    end
end
