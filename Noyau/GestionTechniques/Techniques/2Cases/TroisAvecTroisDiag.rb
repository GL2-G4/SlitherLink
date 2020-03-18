##
# File: TroisAvecTroisDiag.rb
# Project: 2Cases
# File Created: Wednesday, 18th March 2020 1:48:16 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 18th March 2020 4:27:00 pm
# Modified By: <CPietJa>Galbrun T.
#
path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 3 à un 3 diagonale en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Starting Techniques - 5. Two diagonal 3's
    Ex:
    .   .   .   .   .    .   .   .   .   .
                                     x
    .   .   .   .   .    .   .   . = . x .
              3                    3 =
    .   .   .   .   . => .   .   .   .   .
          3                  = 3  
    .   .   .   .   .    . x . = .   .   .
                             x
    .   .   .   .   .    .   .   .   .   .
=end

class TroisAvecTroisDiag < Technique
    
    def initialize ()
        super("T3A3D")
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        0.upto(tl-1) do |j|
            0.upto(tc-1) do |i|
                c = plateau[i][j]
                if (c.nbLigneDevantEtrePleine == 3)
                    dir = checkTrois(plateau,i,j)
                    check = false
                    case dir
                    when :HAUTGAUCHE
                        check = checkCase(plateau,i,j,dir)
                    when :HAUTDROITE
                        check = checkCase(plateau,i,j,dir)
                    when :BASDROITE
                        check = checkCase(plateau,i+1,j+1,:HAUTGAUCHE)
                    when :BASGAUCHE
                        check = checkCase(plateau,i-1,j+1,:HAUTDROITE)
                    end
                    if(dir != nil && check)
                        return true
                    end
                    @zone = nil
                end
            end
        end
        return false
    end

    def checkTrois(plateau,x,y)
        c = getCase(plateau,x,y,:HAUTGAUCHE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :HAUTGAUCHE
        end
        c = getCase(plateau,x,y,:BASGAUCHE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :BASGAUCHE
        end
        c = getCase(plateau,x,y,:HAUTDROITE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :HAUTDROITE
        end
        c = getCase(plateau,x,y,:BASDROITE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :BASDROITE
        end
        return nil
    end

    def checkCase(plateau,x,y,direction)
        #print x, ",", y, " : ", direction, "\n"
        c = plateau[x][y]
        case direction
        when :HAUTGAUCHE
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            cV = getCase(plateau,x,y,:HAUTGAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:PLEINE)
                verifAddLigne(cV.getLigne(:GAUCHE),:PLEINE)
            end
            cV = getCase(plateau,x,y,:BASDROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
            end
            cV = getCase(plateau,x-2,y-1,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            @zone = Zone.new(x-2,y-2,x+1,y+1)
        when :HAUTDROITE
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            cV = getCase(plateau,x,y,:HAUTDROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:PLEINE)
                verifAddLigne(cV.getLigne(:DROITE),:PLEINE)
            end
            cV = getCase(plateau,x,y,:BASGAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            cV = getCase(plateau,x+2,y-1,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
            end
            @zone = Zone.new(x-1,y-2,x+2,y+1)
        end
        return !@lignesAModif.empty?()
    end
end