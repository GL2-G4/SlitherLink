=begin
    Auteurs :: Vaudeleau M.
    Version :: 0.1
    ---
    * ===Descriptif
    Les objets Quicksave peuvent enregistré une grille a un moment donné.
    Ces Quicksave connaissent l'état de la grille et l'historique des actions a un moment donné.

    Il faut passé par l'intermédiaire du module GestionnaireQuicksave qui fournit des méthodes pour gérer les Quicksave    
=end

require "./Case.rb"
require "./Historique.rb"

class Quicksave

    private_class_method:new

    # Creation d'une nouvelle Quicksave. Cette Quicksave enregistre l'etat de la grille et l'historique des actions qui sont passé en parametre
    def Quicksave.nouveau( plateau, ha )

        new( plateau, ha )
    end

    def initialize ( plateau, ha )

        @plateau = plateau

        # premiere étape : sauvegarde du plateau
        
        tailleX = plateau.size()
        tailleY = plateau[0].size()

        @savePlateau = Array.new( ( 4 + 3 * (tailleX - 1 )) + ( (3 + 2 * ( tailleX - 1 )) * ( tailleY - 1 )), nil)
        
        0.upto( tailleX - 1 ) { |i|
            @savePlateau[i] = Array.new( tailleY, nil)
        }

        iArray = 0;

        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|

                if ( i == 0 ) then
                    @savePlateau[iArray] = plateau[i][j].getLigne(:HAUT).etat()
                    iArray += 1
                end

                if ( j == 0 ) then
                    @savePlateau[iArray] = plateau[i][j].getLigne(:GAUCHE).etat()
                    iArray += 1
                end

                @savePlateau[iArray] = plateau[i][j].getLigne(:BAS).etat()
                iArray += 1

                @savePlateau[iArray] = plateau[i][j].getLigne(:DROITE).etat()
                iArray += 1
            }
        }

        # deuxieme étape : sauvegarde de l'historique des actions

        @saveHistorique = Historique.new()
        savePos = ha.getPos()

        begin
            while ( true ) do
                ha.undo()
            end
        rescue EmptyHistoriqueError => e
            # on boucle jusqu'a ce que l'historique soit vide, l'erreur est normale
        end

        begin
            while ( true ) do
                @saveHistorique.ajouterAction( ha.redo());
            end
        rescue RedoHistoriqueError => e
            # on boucle jusqu'a ce que l'historique ait été parcouru en entier, l'erreur est normale
        end

        @saveHistorique.setPos( savePos)
        ha.setPos( savePos)
    end

    # Charge la Quicksave dans le plateau de jeu et l'historique des actions passé en parametre
    def charger ( plateau, ha )

        tailleX = plateau.size()
        tailleY = plateau[0].size()

        iArray = 0

        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|

                if ( i == 0 ) then
                    plateau[i][j].getLigne(:HAUT).setEtat( @savePlateau[iArray])
                    iArray += 1
                end

                if ( j == 0 ) then
                    plateau[i][j].getLigne(:GAUCHE).setEtat(  @savePlateau[iArray])
                    iArray += 1
                end

                plateau[i][j].getLigne(:BAS).setEtat( @savePlateau[iArray])
                iArray += 1

                plateau[i][j].getLigne(:DROITE).setEtat( @savePlateau[iArray])
                iArray += 1
            }
        }

        ha.reset( @saveHistorique )
    end
end