path = File.expand_path(File.dirname(__FILE__))

require path + "/Case"
require path + "/Historique"
require path + "/Action"
require path + "/GestionTechniques/GestionTechniques"
require path + "/Quicksave"
require path + "/Constante"

require "yaml"

module TypeCreation
    TAILLE      = 0
    CHARGER     = 1
    CHARGER_REP = 2

    extend OpConstante
end

class Jeu

    private_class_method :new

    def Jeu.creer( n, m )
        new( :TAILLE, n, m )
    end

    def Jeu.charger( grille )
        new( :CHARGER, grille )
    end

    def Jeu.charger_rep ( grille )
        new( :CHARGER_REP, grille )
    end

    def initialize( type, *args )
        @historiqueActions = Historique.new()
        @plateau = []

        if(TypeCreation.estValide?(type))
            case type
            when :TAILLE
                initTaille(args[0],args[1])
            when :CHARGER
                initTaille(args[0].nombreColonnes,args[0].nombreLignes)
                initGrille(args[0])
            when :CHARGER_REP
                initGrilleRep(args[0])
            end
        end
    end

    # Crée un plateau vide de taile n*m
    # n : nombre de colonnes
    # m : nombre de lignes
    def initTaille ( n, m )
        @plateau = Array.new(n, nil)

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

                @plateau[i][j] = Case.creer( 4, h)
            }
        }
    end

    # Charge un plateau à partir d'une grille
    def initGrille ( grille )
        plateauRep = grille.plateau
        nbCol = grille.nombreColonnes
        nbLi = grille.nombreLignes

        0.upto(nbCol - 1) { |i|
            0.upto(nbLi - 1) { |j|
                @plateau[i][j].nbLigneDevantEtrePleine = plateauRep[i][j].nbLigneDevantEtrePleine
            }
        }
    end

    # Charge le plateau d'une grille réponse
    def initGrilleRep ( grille )
        @plateau = YAML.load(YAML.dump(grille.plateau))
    end

    private :initTaille, :initGrille

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
                valC = @plateau[i][j].nbLigneDevantEtrePleine
                print @plateau[i][j].getLigne(:GAUCHE), " ", ((valC == 4) ? " " : valC ), " "
            }
            print @plateau[tailleX - 1][j].getLigne(:DROITE)
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

        return Quicksave.nouveau( @plateau, @historiqueActions)
    end

    def quicksaveCharger( quicksave)
        quicksave.charger( @plateau, @historiqueActions)
        return self
    end

    #
    # Aides et Techniques
    #
    def chercher(technique)
        GT.chercher(technique,@plateau)
    end
    
    def getZone(technique)
        GT.getZone(technique)
    end

    def getLignes(technique)
        GT.getLignes(technique)
    end
end
