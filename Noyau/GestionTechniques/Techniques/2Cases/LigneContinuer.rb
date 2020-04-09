##
# File: LigneContinuer.rb
# Project: 2Cases
# File Created: Tuesday, 18th March 2020 14:19 am
# Author: <VoxoR7>Vaudeleau M.

path = File.expand_path(File.dirname(__FILE__))

require path + "/../../Technique"
require path + "/../../../Case"
require path + "/../../Zone"

=begin
    ATTENTION : CETTE TECHNIQUE DOIT IMPERATIVEMENT ETRE APELLEE APRES CoinLB ET CoinLP

    Lorsque une ligne qui touche un des bords du plateau, a une ligne bloqué a cote, la ligne ne peut continuer que de l'autre coté.
    De meme lorsque une ligne qui ne touche pas un des bords du plateau, a 2 lignes bloqué a coté de l'un des bouts de la ligne, cette ligne ne peut continuer que d'un seul coté    

    .   .   .    .   .   .
        x   x        x   x   
    . x . = .    . x . = .
              =>     =   =
    .   .   .    .   .   .
                          
    .   .   .    .   .   .
=end

class LigneContinuer < Technique
    
    def initialize ()
        super("LC")
    end

    def chercher(plateau)
        super()

        tailleX = plateau.size()
        tailleY = plateau[0].size()

        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|

                if ( i == tailleX - 1 ) then

                    if ( plateau[i][j].getLigne(:DROITE).etat() == :PLEINE ) then

                        if ( j != 0 ) then

                            # ici on regarde en haut de la ligne
                            if ( plateau[i][j - 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:HAUT).etat() == :BLOQUE ) then

                                #  ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                            elsif ( !( plateau[i][j - 1].getLigne(:DROITE).etat() == :PLEINE || plateau[i][j].getLigne(:HAUT).etat() == :PLEINE ) && ( plateau[i][j - 1].getLigne(:DROITE).etat() == :BLOQUE || plateau[i][j].getLigne(:HAUT).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j - 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:HAUT).etat() != :PLEINE ) then

                                    @zone = Zone.new( i, j - 1, i, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:HAUT), :PLEINE)
                                    return true
                                elsif ( plateau[i][j - 1].getLigne(:DROITE) != :PLEINE )

                                    @zone = Zone.new( i, j - 1, i, j)
                                    ligneAvecEtat( plateau[i][j - 1].getLigne(:DROITE), :PLEINE)
                                    return true
                                end
                            end
                        end
                    

                        if ( j != tailleY - 1 ) then

                            # ici on regarde en bas de la ligne
                            if ( plateau[i][j + 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:BAS).etat() == :BLOQUE ) then

                                #  ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                            elsif ( !( plateau[i][j + 1].getLigne(:DROITE).etat() == :PLEINE || plateau[i][j].getLigne(:BAS).etat() == :PLEINE ) && ( plateau[i][j + 1].getLigne(:DROITE).etat() == :BLOQUE || plateau[i][j].getLigne(:BAS).etat() == :BLOQUE ) ) then

                                if ( plateau[i][j + 1].getLigne(:DROITE).etat() == :BLOQUE && plateau[i][j].getLigne(:BAS) != :PLEINE ) then

                                    @zone = Zone.new( i, j, i, j + 1)
                                    ligneAvecEtat( plateau[i][j].getLigne(:BAS), :PLEINE)
                                    return true
                                elsif ( plateau[i][j + 1].getLigne(:DROITE) != :PLEINE )

                                    @zone = Zone.new( i, j, i, j + 1)
                                    ligneAvecEtat( plateau[i][j + 1].getLigne(:DROITE), :PLEINE)
                                    return true
                                end
                            end
                        end
                    end
                end
                
                if ( j == tailleY - 1 ) then

                    if ( plateau[i][j].getLigne(:BAS).etat() == :PLEINE ) then

                        if ( i != 0 ) then

                            # ici on regarde a gauche de la ligne
                            if ( plateau[i - 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:GAUCHE).etat() == :BLOQUE ) then

                                #  ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                            elsif ( !( plateau[i - 1][j].getLigne(:BAS).etat() == :PLEINE || plateau[i][j].getLigne(:GAUCHE).etat() == :PLEINE ) && ( plateau[i - 1][j].getLigne(:BAS).etat() == :BLOQUE || plateau[i][j].getLigne(:GAUCHE).etat() == :BLOQUE ) ) then

                                if ( plateau[i - 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:GAUCHE) != :PLEINE ) then

                                    @zone = Zone.new( i - 1, j, i, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:GAUCHE), :PLEINE)
                                    return true
                                elsif ( plateau[i - 1][j].getLigne(:BAS) != :PLEINE )

                                    @zone = Zone.new( i - 1, j, i, j)
                                    ligneAvecEtat( plateau[i - 1][j].getLigne(:BAS), :PLEINE)
                                    return true
                                end
                            end
                        end

                        if ( i != tailleX - 1 ) then

                            # ici on regarde a droite de la ligne
                            if ( plateau[i + 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:DROITE).etat() == :BLOQUE ) then

                                #  ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                            elsif ( !( plateau[i + 1][j].getLigne(:BAS).etat() == :PLEINE || plateau[i][j].getLigne(:DROITE).etat() == :PLEINE ) && ( plateau[i + 1][j].getLigne(:BAS).etat() == :BLOQUE || plateau[i][j].getLigne(:DROITE).etat() == :BLOQUE ) ) then

                                if ( plateau[i + 1][j].getLigne(:BAS).etat() == :BLOQUE && plateau[i][j].getLigne(:DROITE) != :PLEINE ) then

                                    @zone = Zone.new( i, j, i + 1, j)
                                    ligneAvecEtat( plateau[i][j].getLigne(:DROITE), :PLEINE)
                                    return true
                                elsif ( plateau[i + 1][j].getLigne(:BAS) != :PLEINE )

                                    @zone = Zone.new( i, j, i + 1, j)
                                    ligneAvecEtat( plateau[i + 1][j].getLigne(:BAS), :PLEINE)
                                    return true
                                end
                            end
                        end
                    end
                end

                if ( plateau[i][j].getLigne(:HAUT).etat() == :PLEINE ) then

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

                    if ( lp >= 2 || lb == nbtests ) then

                        # ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                    elsif ( lp == 0 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j - 1, i, j)

                        if ( plateau[i][j].getLigne(:GAUCHE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:GAUCHE), :PLEINE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:HAUT), :PLEINE)
                        else
                            
                            ligneAvecEtat( plateau[i][j - 1].getLigne(:GAUCHE), :PLEINE)
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

                    if ( lp >= 2 || lb == nbtests ) then

                        # ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                    elsif ( lp == 0 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j, i, j + 1)

                        if ( plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:DROITE), :PLEINE)
                        elsif ( i < tailleX - 1 && plateau[i + 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i + 1][j].getLigne(:HAUT), :PLEINE)
                        else
                            
                            ligneAvecEtat( plateau[i][j + 1].getLigne(:GAUCHE), :PLEINE)
                        end

                        return true
                    end
                end

                if ( plateau[i][j].getLigne(:GAUCHE).etat() == :PLEINE ) then

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

                    if ( lp >= 2 || lb == nbtests ) then

                        # ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                    elsif ( lp == 0 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j - 1, i, j)

                        if ( plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:HAUT), :PLEINE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:HAUT).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:HAUT), :PLEINE)
                        else
                            
                            ligneAvecEtat( plateau[i][j - 1].getLigne(:GAUCHE), :PLEINE)
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
                        when :BLOQUEZ
                            lb += 1
                        when :VIDE
                            lv += 1
                    end

                    if ( lp >= 2 || lb == nbtests ) then

                        # ICI ERREUR DE JEU A TRAITE ( Vaudeleau Mathieu )
                    elsif ( lp == 0 && lb == nbtests - 1 ) then

                        @zone = Zone.new( i - 1, j, i, j + 1)

                        if ( plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                            ligneAvecEtat( plateau[i][j].getLigne(:BAS), :PLEINE)
                        elsif ( i > 0 && plateau[i - 1][j].getLigne(:BAS).etat() == :VIDE )
                            
                            ligneAvecEtat( plateau[i - 1][j].getLigne(:BAS), :PLEINE)
                        else
                            
                            ligneAvecEtat( plateau[i][j + 1].getLigne(:GAUCHE), :PLEINE)
                        end

                        return true
                    end
                end
            }
        }

        return false
    end
end