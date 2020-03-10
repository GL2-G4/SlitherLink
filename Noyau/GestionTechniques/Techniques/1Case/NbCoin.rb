##
# File: Un.rb
# Project: 1Case
# File Created: Friday, 6th March 2020 3:43:47 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 10th March 2020 3:05:48 pm
# Modified By: <CPietJa>Galbrun T.
#


path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    Technique qui lorsqu'un chiffre(entre 1 et 3) est dans un coin, 
    en tire des conséquences.
    Voir à https://www.conceptispuzzles.com/index.aspx?uri=puzzle/slitherlink/techniques :
    -> Starting Techniques - 6. Any number in a corner
    Pour le 0, voir "Zero.rb".
=end

class NbCoin < Technique
    
    def initialize (description)
        super(description)
    end

    def chercher(plateau)
        super()
        tl, tc = getTailleLigne(plateau), getTailleColonne(plateau)

        #coin haut gauche
        case plateau[0][0].nbLigneDevantEtrePleine
            when 1
                l1 = plateau[0][0].getLigne(:HAUT)
                l2 = plateau[0][0].getLigne(:GAUCHE)
                if ((l1.etat != :BLOQUE || l2.etat != :BLOQUE) && verifCase(l1,l2,:BLOQUE))
                    @zone = Zone.new(0,0,0,0)
                    return true
                end
            when 2
                l1 = plateau[0][1].getLigne(:GAUCHE)
                l2 = plateau[1][0].getLigne(:HAUT)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(0,0,1,1)
                    return true
                end
            when 3
                l1 = plateau[0][0].getLigne(:HAUT)
                l2 = plateau[0][0].getLigne(:GAUCHE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(0,0,0,0)
                    return true
                end
        end

        # coin bas gauche
        case plateau[0][tl-1].nbLigneDevantEtrePleine
            when 1
                l1 = plateau[0][tl-1].getLigne(:BAS)
                l2 = plateau[0][tl-1].getLigne(:GAUCHE)
                if ((l1.etat != :BLOQUE || l2.etat != :BLOQUE) && verifCase(l1,l2,:BLOQUE))
                    @zone = Zone.new(0,tl-1,0,tl-1)
                    return true
                end
            when 2
                l1 = plateau[0][tl-2].getLigne(:GAUCHE)
                l2 = plateau[1][tl-1].getLigne(:BAS)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(0,tl-2,1,tl-1)
                    return true
                end
            when 3
                l1 = plateau[0][tl-1].getLigne(:BAS)
                l2 = plateau[0][tl-1].getLigne(:GAUCHE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(0,tl-1,0,tl-1)
                    return true
                end
        end

        # coin haut droite
        case plateau[tc-1][0].nbLigneDevantEtrePleine
            when 1
                l1 = plateau[tc-1][0].getLigne(:HAUT)
                l2 = plateau[tc-1][0].getLigne(:DROITE)
                if ((l1.etat != :BLOQUE || l2.etat != :BLOQUE) && verifCase(l1,l2,:BLOQUE))
                    @zone = Zone.new(tc-1,0,tc-1,0)
                    return true
                end
            when 2
                l1 = plateau[tc-2][0].getLigne(:HAUT)
                l2 = plateau[tc-1][1].getLigne(:DROITE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(tc-2,0,tc-1,1)
                    return true
                end
            when 3
                l1 = plateau[tc-1][0].getLigne(:HAUT)
                l2 = plateau[tc-1][0].getLigne(:DROITE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(tc-1,0,tc-1,0)
                    return true
                end
        end

        # coin bas droite
        case plateau[tc-1][tl-1].nbLigneDevantEtrePleine
            when 1
                l1 = plateau[tc-1][tl-1].getLigne(:BAS)
                l2 = plateau[tc-1][tl-1].getLigne(:DROITE)
                if ((l1.etat != :BLOQUE || l2.etat != :BLOQUE) && verifCase(l1,l2,:BLOQUE))
                    @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
                    return true
                end
            when 2
                l1 = plateau[tc-2][tl-1].getLigne(:BAS)
                l2 = plateau[tc-1][tl-2].getLigne(:DROITE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(tc-2,tl-2,tc-1,tl-1)
                    return true
                end
            when 3
                l1 = plateau[tc-1][tl-1].getLigne(:BAS)
                l2 = plateau[tc-1][tl-1].getLigne(:DROITE)
                if ((l1.etat != :PLEINE || l2.etat != :PLEINE) && verifCase(l1,l2,:PLEINE))
                    @zone = Zone.new(tc-1,tl-1,tc-1,tl-1)
                    return true
                end
        end
        return false
    end

    private
    def verifCase(ligne1, ligne2, etat)
        modif = false
        if (ligne1.etat != etat)
            @lignesAModif << ligne1
            modif = true
        end
        if (ligne2.etat != etat)
            @lignesAModif << ligne2
            modif = true
        end
        return modif
    end
end
