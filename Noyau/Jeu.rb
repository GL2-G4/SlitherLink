require "./Case.rb"
require "./Historique"
require "./Action"
require "./GestionnaireQuicksave.rb"

class Jeu

    private_class_method :new

    def Jeu.creer( n, m)

        new( n, m)
    end

    def initialize( n, m)

        @historiqueActions = Historique.new()
        @plateau = Array.new(n, nil)
        @quickSave = GestionnaireQuicksave.nouveau( @plateau, @historiqueActions)

        0.upto(n-1) { |i|
            @plateau[i] = Array.new(m, nil)
        }

        0.upto(n-1) { |i|
            0.upto(m-1) { |j|
                h = Hash.new( nil)

                if ( i != 0 ) then
                    h[:GAUCHE] = @plateau[i-1][j].getLigne(:DROITE)
                end

                if ( j != 0 ) then
                    h[:HAUT] = @plateau[i][j-1].getLigne(:BAS)
                end

                @plateau[i][j] = Case.creer( 0, h)
            }
        }
    end

    def lancerPartie()
        return self
    end

    def gagne?()

        return false
    end

    def nbErreur()

        return 0
    end

    def afficherErreur()

        return self
    end

    def jouer( x, y, dirLigne, typeEvent )

        if ( x < 0)
            raise ArgumentError, "Coordonnées Incorrectes : [#{x},#{y}]"
        end
        if ( y < 0 )
            raise ArgumentError, "Coordonnées Incorrectes : [#{x},#{y}]"
        end
        if ( x >= @plateau.size())
            raise ArgumentError, "Coordonnées Incorrectes : [#{x},#{y}]"
        end
        if ( y >= @plateau[0].size() )
            raise ArgumentError, "Coordonnées Incorrectes : [#{x},#{y}]"
        end

        begin
            etatPrec = @plateau[x][y].modifierLigneClic( dirLigne, typeEvent)
            puts "#{typeEvent} en #{dirLigne} sur [#{x},#{y}]"
            ligne = @plateau[x][y].getLigne(dirLigne);
            @historiqueActions.ajouterAction(Action.new(ligne,etatPrec,ligne.etat))
        rescue DirectionError => e
            e.message()
        rescue ActionError => e
            e.message()
        end

        return self
    end

    def afficherPlateau
        
        tailleX = @plateau.size()
        tailleY = @plateau[0].size()

        0.upto( tailleX - 1 ) { |i|
            print "  #{i} "
        }

        print "\n"
        0.upto( tailleY - 1 ) { |j|
            0.upto( tailleX - 1 ) { |i|
                print ". ", @plateau[i][j].getLigne(:HAUT), " "
            }

            print ".\n"

            0.upto( tailleX - 1 ) { |i|
                print @plateau[i][j].getLigne(:GAUCHE), " ", @plateau[i][j].nbLigneDevantEtrePleine, " "
            }

            print "  ", j, "\n"
        }

        0.upto( tailleX - 1 ) { |i|
            print ". ", @plateau[i][tailleY - 1].getLigne(:BAS), " "
        }

        print ".\n"
    end

    def to_s
        return "Plateau[Taille:#{@plateau.size}x#{@plateau[0].size}]#{@historiqueActions}"
    end

    def getTailleLigne
        return @plateau[0].size()
    end

    def getTailleColonne
        return @plateau.size()
    end

    def undo

        begin
            action = @historiqueActions.undo()
        rescue EmptyHistoriqueError => e
            e.message()
            return self
        end

        action.ligne.setEtat(action.avant)
    end

    def redo

        begin
            action = @historiqueActions.redo()
        rescue RedoHistoriqueError => e
            e.message()
            return self
        end

        action.ligne.setEtat(action.apres)
    end

    def quicksaveEnregistrer()

        @quickSave.nouvelleQuicksave()
        return self
    end

    def quicksaveCharger()

        @quickSave.charger()
        return self
    end
end
