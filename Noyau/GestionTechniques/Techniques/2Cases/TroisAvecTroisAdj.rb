##
# File: TroisAvecTroisAdj.rb
# Project: 2Cases
# File Created: Tuesday, 17th March 2020 10:57:22 am
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 26th March 2020 4:02:55 pm
# Modified By: <CPietJa>Galbrun T.
#

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un 3 à un 3 adjacent en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Starting Techniques - 4. Two adjacent 3's
    Ex:
    .   .   .    .   .   .
                     x    
    .   .   .    .   .   .
      3   3   => = 3 = 3 =
    .   .   .    .   .   .
                     x    
    .   .   .    .   .   .
=end

class TroisAvecTroisAdj < Technique
    
    def initialize ()
        super("T3A3A")
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
                    when :HAUT
                        check = checkCase(plateau,i,j,dir)
                    when :DROITE
                        check = checkCase(plateau,i,j,dir)
                    when :BAS
                        check = checkCase(plateau,i,j+1,:HAUT)
                    when :GAUCHE
                        check = checkCase(plateau,i-1,j,:DROITE)
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

    # Renvoie la 1ère case voisine(HAUT | BAS | DROITE | GAUCHE)
    # contenant un 3.
    def checkTrois(plateau,x,y)
        c = getCase(plateau,x,y,:HAUT)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :HAUT
        end
        c = getCase(plateau,x,y,:DROITE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :DROITE
        end
        c = getCase(plateau,x,y,:BAS)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :BAS
        end
        c = getCase(plateau,x,y,:GAUCHE)
        if(c != nil && c.nbLigneDevantEtrePleine == 3)
            return :GAUCHE
        end
        return nil
    end

    # Récupère les lignes s'il y en a à prendre, et renvoie
    # vrai si on en a récupèré.
    def checkCase(plateau,x,y,direction)
        #print x, ",", y, " : ", direction, "\n"
        c = plateau[x][y]
        case direction
        # 0 en haut du 3
        when :HAUT
            verifAddLigne(c.getLigne(:HAUT),:PLEINE)
            verifAddLigne(c.getLigne(:BAS),:PLEINE)
            cV = getCase(plateau,x,y,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:PLEINE)
            end
            cV = getCase(plateau,x,y,:GAUCHE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:DROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:HAUT),:BLOQUE)
            end
            @zone = Zone.new(x-1,y-1,x+1,y)
        # 0 à droite du 3
        when :DROITE
            verifAddLigne(c.getLigne(:DROITE),:PLEINE)
            verifAddLigne(c.getLigne(:GAUCHE),:PLEINE)
            cV = getCase(plateau,x,y,:DROITE)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:DROITE),:PLEINE)
            end
            cV = getCase(plateau,x,y,:HAUT)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            cV = getCase(plateau,x,y,:BAS)
            if(cV != nil)
                verifAddLigne(cV.getLigne(:DROITE),:BLOQUE)
            end
            @zone = Zone.new(x,y-1,x+1,y+1)
        end
        return !@lignesAModif.empty?()
    end
end