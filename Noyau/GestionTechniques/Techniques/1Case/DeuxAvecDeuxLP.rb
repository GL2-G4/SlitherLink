##
# File: DeuxAvecDeuxLP.rb
# Project: 1Case
# File Created: Friday, 14th February 2020 6:01:41 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 15th April 2020 2:15:38 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"

=begin
    Technique qui lorsqu'un 2 à 2 lignes pleines récupère
    les 2 lignes qui peuvent être remplis.
    Ex:
    . = .       . = .
    = 2      => = 2 x
    .   .       . x .
=end
class DeuxAvecDeuxLP < Technique
    
    def initialize ()
        super("T2A2LP")
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)
        
        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                # On cherche la case contenant un 2 et répondant aux conditions
                # de la technique, puis on récupère les lignes.
                if (c.nbLigneDevantEtrePleine == 2)
                    if(c.nbLigneEtat(:BLOQUE) <= 1 && c.nbLigneEtat(:PLEINE) == 2)
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
