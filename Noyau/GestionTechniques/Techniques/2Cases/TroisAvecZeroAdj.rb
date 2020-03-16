##
# File: TroisAvecZeroAdj.rb
# Project: 2Cases
# File Created: Tuesday, 10th March 2020 3:11:34 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Monday, 16th March 2020 4:19:59 pm
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
    
    def initialize ()
        super("T3A0A")
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

    def checkZero(plateau,x,y)
        c = getCase(plateau,x,y,:HAUT)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :HAUT
        end
        c = getCase(plateau,x,y,:DROITE)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :DROITE
        end
        c = getCase(plateau,x,y,:BAS)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :BAS
        end
        c = getCase(plateau,x,y,:GAUCHE)
        if(c != nil && c.nbLigneDevantEtrePleine == 0)
            return :GAUCHE
        end
        return nil
    end

    def checkCase(plateau,x,y,direction)
        #print x, ",", y, " : ", direction, "\n"
        c = plateau[x][y]
        case direction
        # 0 en haut du 3
        when :HAUT
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            cV = getCase(plateau,x,y,:GAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:PLEINE)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:DROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:PLEINE)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:BAS)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
        # 0 à droite du 3
        when :DROITE
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            cV = getCase(plateau,x,y,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:DROITE),:PLEINE)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:BAS)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:DROITE),:PLEINE)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:GAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
            end
        # 0 en bas du 3
        when :BAS
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            cV = getCase(plateau,x,y,:GAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:BAS),:PLEINE)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:DROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:BAS),:PLEINE)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:GAUCHE),:BLOQUE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
        when :GAUCHE
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            cV = getCase(plateau,x,y,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:GAUCHE),:PLEINE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:BAS)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:GAUCHE),:PLEINE)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:DROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
                verifAddLigne(cV.getLigne(:BAS),:BLOQUE)
            end
        end
        return !@lignesAModif.empty?()
    end
end