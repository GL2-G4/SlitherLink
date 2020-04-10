##
# File: BloqueCasePleine.rb
# Project: 1Case
# File Created: Tuesday, 10th April 2020 17:45
# Author: <VoxoR7>Vaudeleau M.

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin

    Lorsque une case possedant 1 numero a deja un nombre de ligne pleine égale a son numéro, on bloque toutes les autres lignes

    .   .   .    .   . x .
          1          x 1 x    
    .   . = .    .   . = .
          3 =   =>   x 3 =   
    .   . = .    .   . =  .
                          
    .   .   .    .   .   .
=end

class BloqueCasePleine < Technique
    
    def initialize ()
        super("BCP")
    end

    def chercher(plateau)
        super()

        tailleX = plateau.size()
        tailleY = plateau[0].size()

        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|

                if ( plateau[i][j].nbLigneDevantEtrePleine() != 4 ) then

                    lp = 0
                    lb = 0
                    lv = 0

                    case plateau[i][j].getLigne(:HAUT).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    case plateau[i][j].getLigne(:DROITE).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    case plateau[i][j].getLigne(:BAS).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    case plateau[i][j].getLigne(:GAUCHE).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( plateau[i][j].nbLigneDevantEtrePleine() == lp && lv > 0 ) then
            
                        @zone = Zone.new( i, j, i, j)
                        if ( plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:HAUT), :BLOQUE)
                        end
                        if ( plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:DROITE), :BLOQUE)
                        end
                        if ( plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:BAS), :BLOQUE)
                        end
                        if ( plateau[i][j].getLigne(:GAUCHE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:GAUCHE), :BLOQUE)
                        end

                        return true
                    end
                end
            }
        }

    end
end