##
# File: LigneBloqueContinuer.rb
# Project: 2Cases
# File Created: Tuesday, 18th March 2020 14:19 am
# Author: <VoxoR7>Vaudeleau M.

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    ATTENTION : CETTE TECHNIQUE DOIT IMPERATIVEMENT ETRE APELLEE APRES CoinLB ET CoinLP

    Lorsque une ligne vide a l'une de ses extremité ne debouche que sur des lignes bloque, alors la ligne vide doit etre bloque

    .   .   .    .   .   .
        x   x        x   x   
    . x . x .    . x . x .
               =>    x   x
    .   .   .    .   .   .
                          
    .   .   .    .   .   .
=end

class LigneBloqueContinuer < Technique
    
    def initialize ()
        super("LBC")
    end

    def chercher(plateau)
        super()

        tailleX = plateau.size()
        tailleY = plateau[0].size()

        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|

                if ( i == tailleX - 1 ) then

                    if ( plateau[i][j].getLigne(:DROITE).etat() == :BLOQUE ) then

                        if ( j != 0 ) then

                            # ici on regarde en haut de la ligne
                            if ( ( plateau[i][j - 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) || ( plateau[i][j - 1].getLigne(:DROITE).etat() == :VIDE && plateau[i][j].getLigne(:HAUT).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) then

                                    @zone = Zone.new( i, j - 1, i, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:HAUT), :BLOQUE)
                                    return true
                                else

                                    @zone = Zone.new( i, j - 1, i, j)
                                    ligneAvecEtat( plateau[i][j - 1].getLigne(:DROITE), :BLOQUE)
                                    return true
                                end
                            end
                        end
                    

                        if ( j != tailleY - 1 ) then

                            # ici on regarde en bas de la ligne
                            if ( ( plateau[i][j + 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:BAS).etat() == :VIDE ) || ( plateau[i][j + 1].getLigne(:DROITE).etat() == :VIDE && plateau[i][j].getLigne(:BAS).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                                    @zone = Zone.new( i, j, i, j + 1)
                                    ligneAvecEtat( plateau[i][j].getLigne(:BAS), :BLOQUE)
                                    return true
                                else

                                    @zone = Zone.new( i, j, i, j + 1)
                                    ligneAvecEtat( plateau[i][j + 1].getLigne(:DROITE), :BLOQUE)
                                    return true
                                end
                            end
                        end
                    end
                end
                
                if ( j == tailleY - 1 ) then

                    if ( plateau[i][j].getLigne(:BAS).etat() == :BLOQUE ) then

                        if ( i != 0 ) then

                            # ici on regarde a gauche de la ligne
                            if ( ( plateau[i - 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:GAUCHE).etat() == :VIDE ) || ( plateau[i - 1][j].getLigne(:BAS).etat() == :VIDE && plateau[i][j].getLigne(:GAUCHE).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                                    @zone = Zone.new( i - 1, j, i, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:GAUCHE), :BLOQUE)
                                    return true
                                else

                                    @zone = Zone.new( i - 1, j, i, j)
                                    ligneAvecEtat( plateau[i - 1][j].getLigne(:BAS), :BLOQUE)
                                    return true
                                end
                            end
                        end

                        if ( i != tailleX - 1 ) then

                            # ici on regarde a droite de la ligne
                            if ( ( plateau[i + 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) || ( plateau[i + 1][j].getLigne(:BAS).etat() == :VIDE && plateau[i][j].getLigne(:DROITE).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) then

                                    @zone = Zone.new( i, j, i + 1, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:DROITE), :BLOQUE)
                                    return true
                                else

                                    @zone = Zone.new( i, j, i + 1, j)
                                    ligneAvecEtat( plateau[i + 1][j].getLigne(:BAS), :BLOQUE)
                                    return true
                                end
                            end
                        end
                    end
                end

                if ( plateau[i][j].getLigne(:HAUT).etat() == :BLOQUE ) then

                    # ici on regarde a gauche de la ligne
                    lb = 0
                    lp = 0
                    lv = 0
                    nbtests = 1

                    if ( j > 0 ) then

                        nbtests += 1

                        case plateau[i][j - 1].getLigne(:GAUCHE).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                            end
                    end

                    if ( i > 0 ) then

                        nbtests += 1

                        case plateau[i - 1][j].getLigne(:HAUT).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                        end
                    end

                    case plateau[i][j].getLigne(:GAUCHE).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( lv == 1 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j - 1, i, j)

                        if ( plateau[i][j].getLigne(:GAUCHE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:GAUCHE), :BLOQUE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:HAUT), :BLOQUE)
                        else
                            
                            ligneAvecEtat( plateau[i][j - 1].getLigne(:GAUCHE), :BLOQUE)
                        end

                        return true
                    end

                    # ici on regarde a droite de la ligne
                    lb = 0
                    lp = 0
                    lv = 0
                    nbtests = 1

                    if ( j > 0 ) then

                        nbtests += 1

                        case plateau[i][j - 1].getLigne(:DROITE).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                            end
                    end

                    if ( i < tailleX - 1 ) then

                        nbtests += 1

                        case plateau[i + 1][j].getLigne(:HAUT).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                        end
                    end

                    case plateau[i][j].getLigne(:DROITE).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( lv == 1 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j, i, j + 1)

                        if ( plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:DROITE), :BLOQUE)
                        elsif ( i < tailleX - 1 && plateau[i + 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i + 1][j].getLigne(:HAUT), :BLOQUE)
                        else
                            
                            ligneAvecEtat( plateau[i][j - 1].getLigne(:DROITE), :BLOQUE)
                        end

                        return true
                    end
                end

                if ( plateau[i][j].getLigne(:GAUCHE).etat() == :BLOQUE ) then

                    # ici on regarde en haut de la ligne
                    lb = 0
                    lp = 0
                    lv = 0
                    nbtests = 1

                    if ( j > 0 ) then

                        nbtests += 1

                        case plateau[i][j - 1].getLigne(:GAUCHE).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                            end
                    end

                    if ( i > 0 ) then

                        nbtests += 1

                        case plateau[i - 1][j].getLigne(:HAUT).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                        end
                    end

                    case plateau[i][j].getLigne(:HAUT).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( lv == 1 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j - 1, i, j)

                        if ( plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:HAUT), :BLOQUE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:HAUT), :BLOQUE)
                        else
                            
                            ligneAvecEtat( plateau[i][j - 1].getLigne(:GAUCHE), :BLOQUE)
                        end

                        return true
                    end

                    # ici on regarde en bas de la ligne
                    lb = 0
                    lp = 0
                    lv = 0
                    nbtests = 1

                    if ( j < tailleY - 1 ) then

                        nbtests += 1

                        case plateau[i][j + 1].getLigne(:GAUCHE).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                        end
                    end

                    if ( i > 0 ) then

                        nbtests += 1

                        case plateau[i - 1][j].getLigne(:BAS).etat()

                            when :PLEINE
                                lp += 1
                            when :BLOQUE
                                lb += 1
                            when :VIDE
                                lv += 1
                        end
                    end

                    case plateau[i][j].getLigne(:BAS).etat()

                        when :PLEINE
                            lp += 1
                        when :BLOQUE
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( lv == 1 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j, i, j + 1)

                        if ( plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:BAS), :BLOQUE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:BAS).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:BAS), :BLOQUE)
                        else
                            
                            ligneAvecEtat( plateau[i][j + 1].getLigne(:GAUCHE), :BLOQUE)
                        end

                        return true
                    end
                end
            }
        }

        return false
    end
end