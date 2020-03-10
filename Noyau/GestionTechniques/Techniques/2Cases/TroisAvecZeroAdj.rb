##
# File: TroisAvecZeroAdj.rb
# Project: 2Cases
# File Created: Tuesday, 10th March 2020 3:11:34 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 10th March 2020 3:35:16 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 3 à un 0 adjacent en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Starting Techniques - 2. Adjacent 0 and 3
    Ex:
    .   . x .   .    .   . x .   .
        x 0 x            x 0 x
    .   . x .   . => . = . x . = .
          3              = 3 =
    .   .   .   .    . x . = . x .
                         x   x
    .   .   .   .    .   .   .   .
=end

class TroisAvecZeroAdj < Technique
    
    def initialize (description)
        super(description)
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                if (c.nbLigneDevantEtrePleine == 3)
                    return true
                end
            end
        end
        return false
    end
end