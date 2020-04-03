path = File.expand_path(File.dirname(__FILE__))

require path + "/Case"
require path + "/Historique"
require path + "/Action"
require path + "/GestionTechniques/GestionTechniques"
require path + "/Constante"
require path + "/GestionnaireQuicksave"

require "yaml"

=begin
    Auteurs :: Galbrun T.
    Version :: 0.5
    ---
    * ===Descriptif
    Un Jeu est caractérisé par un plateau(grille) de Case et un historique
    d'actions faites par le joueur.

    * ===Variables d'instance
    [historiqueActions] Historique d'actions faites par le joueur.
    [plateau] Le plateau de jeu.
    [grille_rep] Grille réponse.
    [erreurs] Tabnleau stockant les erreurs sur le plateau.

    * ===Méthodes de classe
    [creer(n,m)] Crée un nouveau jeu vide avec une grille de n colonnes
    et m lignes.
    [charger(grille)] Crée un jeu à partir d'une grille.
    [charger_rep(grille)] Crée un jeu en chargant la grille réponse.

    * ===Méthodes d'instance
    [lancerPartie] Lance une partie.
    [gagne?] Renvoie vrai si la grille est complété et sans erreur.
    [nbErreur] Renvoie le nombre d'erreur su la grille.
    [afficherErreur] Affiche les erreurs.
    [jouer(x,y,dirLigne,typeEvent)] Effectue une action sur la grille sur
    une ligne avec le clic effectué.
    [afficherPlateau] Affiche la grille dans la stdout.
    [getCase(x,y)] Récupère la case se trouvant aux coordonnées x,y.
    [getCaseDirection(x,y,direction)] Récupère le voisin de la case pour une direction donnée.
    [getTailleLigne] Renvoie le nombre de colonnes.
    [getTailleColonne] Renvoie le nombre de lignes.
    [undo] Revient à l'action précédente s'il y en a une.
    [redo] Revient à l'action suivante s'il y en a une.
=end

module TypeCreation
    TAILLE      = 0
    CHARGER     = 1
    CHARGER_REP = 2

    extend OpConstante
end

class Jeu

    private_class_method :new

    # Crée un nouveau jeu vide avec une grille de n colonnes
    # et m lignes.
    def Jeu.creer( n, m )
        new( :TAILLE, n, m )
    end

    # Crée un jeu à partir d'une grille.
    def Jeu.charger( grille )
        new( :CHARGER, grille )
    end

    # Crée un jeu en chargant la grille réponse.
    def Jeu.charger_rep ( grille )
        new( :CHARGER_REP, grille )
    end

    def initialize( type, *args )
        @historiqueActions = Historique.new()
        @plateau = []
        @grille_rep = nil
        @erreurs = []

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

        @quickSave = GestionnaireQuicksave.nouveau( @plateau, @historiqueActions)
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
        @grille_rep = grille.plateau
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
        @grille_rep = grille.plateau
        @plateau = YAML.load(YAML.dump(grille.plateau))
    end

    private :initTaille, :initGrille

    # Lance une partie.
    def lancerPartie()
        return self
    end

    # Renvoie vrai si la grille est complété et sans erreur.
    def gagne?()
        @erreurs = []
        nbCol = getTailleColonne()
        nbLi = getTailleLigne()
        0.upto(nbCol - 1) { |i|
            0.upto(nbLi - 1) { |j|
                c1 = @grille_rep[i][j]
                c2 = @plateau[i][j]
                if( !checkCase(c2) )
                    if( j == 0 && checkLignes(c1.getLigne(:HAUT),c2.getLigne(:HAUT)) )
                        @erreurs << [i,j,"Ligne Incorrecte"]
                    end
                    if( checkLignes(c1.getLigne(:BAS),c2.getLigne(:BAS)) )
                        @erreurs << [i,j,"Ligne Incorrecte"]
                    end
                    if ( i == 0 && checkLignes(c1.getLigne(:GAUCHE),c2.getLigne(:GAUCHE)) )
                        @erreurs << [i,j,"Ligne Incorrecte"]
                    end
                    if( checkLignes(c1.getLigne(:DROITE),c2.getLigne(:DROITE)) )
                        @erreurs << [i,j,"Ligne Incorrecte"]
                    end
                else
                    @erreurs << [i,j,"Nombre de ligne(s) pleine(s) incorrect"]
                end
            }
        }
        return @erreurs.size() == 0
    end

    # Renvoie le nombre d'erreur su la grille.
    def nbErreur()
        return @erreurs.size()
    end

    def checkCase(c)
        if(c.nbLigneEtat(:PLEINE) == 4)
            return true
        end

        if( c.nbLigneDevantEtrePleine != 4 &&  c.nbLigneEtat(:PLEINE) != c.nbLigneDevantEtrePleine )
            return true
        end
        return false
    end

    def checkLignes(l1, l2)
        case l1.etat
        when :PLEINE
            if(l2.etat != :PLEINE)
                return true
            end
        else
            if(l2.etat != :VIDE && l2.etat != :BLOQUE)
               return true
            end
        end
        return false
    end

    # Affiche les erreurs, si index == -1 : affichage de toutes les erreurs, sinon affichage d'une erreur.
    def afficherErreur(index = -1)
        if(index < -1 || index >= @erreurs.size)
            raise ArgumentError, "Index d'erreur incorrect"
        end
        if (index == -1)
            @erreurs.each_index do |i|
                print "Erreur n°#{i+1}\n", " - Sur : [#{@erreurs[i][0]};#{@erreurs[i][1]}]\n - ", @erreurs[i][2], "\n"
            end
        else
            print "Erreur n°#{index+1}\n", " - Sur : [#{@erreurs[index][0]};#{@erreurs[index][1]}]\n - ", @erreurs[index][2], "\n"
        end
        return self
    end

    # Effectue une action sur la grille sur une ligne avec le clic effectué.
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

    # Affiche la grille dans la stdout.
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
        self
    end

    # Récupère la case se trouvant aux coordonnées x,y.
    def getCase(x,y)
        if(y < 0 || x < 0 || x >= getTailleColonne() || y >= getTailleLigne())
            return nil
        end
        return @plateau[x][y]
    end

    # Récupère le voisin de la case pour une direction donnée
    def getCaseDirection(x,y,direction)
        if(Direction.estValide?(direction))
            if(y < 0 || x < 0 || x >= getTailleColonne() || y >= getTailleLigne())
                return nil
            end
            case direction
            when :HAUT
                if (y-1 < 0)
                    return nil
                end
                return @plateau[x][y-1]
            when :DROITE
                if (x+1 >= getTailleColonne())
                    return nil
                end
                return @plateau[x+1][y]
            when :BAS
                if (y+1 >= getTailleLigne())
                    return nil
                end
                return @plateau[x][y+1]
            when :GAUCHE
                if (x-1 < 0)
                    return nil
                end
                return @plateau[x-1][y]
            end
        end
        return nil
    end

    def to_s
        return "Plateau[Taille:#{@plateau.size}x#{@plateau[0].size}]#{@historiqueActions}"
    end

    # Renvoie le nombre de lignes.
    def getTailleLigne
        return @plateau[0].size()
    end

    # Renvoie le nombre de colonnes.
    def getTailleColonne
        return @plateau.size()
    end

    # Revient à l'action précédente s'il y en a une.
    def undo

        begin
            action = @historiqueActions.undo()
        rescue EmptyHistoriqueError => e
            e.message()
            return self
        end

        action.ligne.setEtat(action.avant)
    end

    # Revient à l'action suivante s'il y en a une.
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

    def quicksaveCharger( numQS )

        @quickSave.charger( numQS )
        return self
    end

    def quicksaveChargerSafe()

        @quickSave.chargerSafe()
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
