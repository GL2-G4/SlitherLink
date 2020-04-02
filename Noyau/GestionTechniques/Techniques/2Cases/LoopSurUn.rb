##
# File: LoopSurUn.rb
# Project: 2Cases
# File Created: Wednesday, 18th March 2020 4:38:47 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 18th March 2020 4:49:15 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un loop rejoint un 1 en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Basic Techniques - 3. Loop reaching a 1
    Ex:
    .   .   .   .    . x .   .   .
      1              x 1      
    .   . = .   . => .   . = .   .
        x                x    
    . = .   .   .    . = .   .   .
          1                1 x
    .   .   .   .    .   . x .   .
=end

class LoopSurUn < Technique
    def initialize ()
        super("TLR1")
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                if (c.nbLigneDevantEtrePleine == 3)
                    dir = checkZero(plateau,i,j)
                    if(dir != nil && checkCase(plateau,i,j,dir))
                        @zone = Zone.new(i-1,j-1,i+1,j+1)
                        return true
                    end
                end
            end
        end
        return false
    end
end
