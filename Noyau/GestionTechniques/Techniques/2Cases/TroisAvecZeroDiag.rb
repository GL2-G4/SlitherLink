##
# File: TroisAvecZeroDiag.rb
# Project: 2Cases
# File Created: Monday, 16th March 2020 4:36:11 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Monday, 16th March 2020 5:29:27 pm
# Modified By: <CPietJa>Galbrun T.
#
path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 3 à un 0 diagonale en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Starting Techniques - 3. Diagonal 0 and 3
    Ex:
    .   .   .    .   .   .
          3          = 3
    . x .   . => . x . = .
    x 0 x        x 0 x
    . x .   .    . x .   .
=end

class TroisAvecZeroDiag < Technique
    
    def initialize ()
        super("T3A0D")
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
                        return true
                    end
                end
            end
        end
        return false
    end

    def checkZero(plateau,x,y)
        c = getCase(plateau,x-1,y,:HAUT)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :HAUTGAUCHE
        end
        c = getCase(plateau,x-1,y,:BAS)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :BASGAUCHE
        end
        c = getCase(plateau,x+1,y,:HAUT)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :HAUTDROITE
        end
        c = getCase(plateau,x+1,y,:BAS)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :BASDROITE
        end
        return nil
    end

    def checkCase(plateau,x,y,direction)
        #print x, ",", y, " : ", direction, "\n"
        c = plateau[x][y]
        case direction
        # 0 en haut à gauche du 3
        when :HAUTGAUCHE
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            @zone = Zone.new(x-1,y-1,x,y)
        # 0 en bas à gauche du 3
        when :BASGAUCHE
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            @zone = Zone.new(x-1,y,x,y+1)
        # 0 en haut à droite du 3
        when :HAUTDROITE
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            @zone = Zone.new(x,y-1,x+1,y)
        # 0 en bas à droite du 3
        when :BASDROITE
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            @zone = Zone.new(x,y,x+1,y+1)
        end
        return !@lignesAModif.empty?()
    end
end