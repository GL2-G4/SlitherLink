##
# File: UnAvecUneLP.rb
# Project: 1Case
# File Created: Friday, 14th February 2020 6:02:07 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 15th April 2020 2:25:24 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 1 à 1 ligne pleine récupère
    les lignes qui peuvent être bloquées.
    Ex:
    . = .       . = .
      1      => x 1 x
    .   .       . x .
=end
class UnAvecUneLP < Technique
    
    def initialize ()
        super("T1A1LP")
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)
        
        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                # On cherche la case contenant un 1 et répondant aux conditions
                # de la technique, puis on récupère la ligne.
                if (c.nbLigneDevantEtrePleine == 1)
                    if(c.nbLigneEtat(:BLOQUE) <= 2 && c.nbLigneEtat(:PLEINE) == 1)
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
