path = File.expand_path(File.dirname(__FILE__))

require path + "/Ligne.rb"
require path + "/Constante.rb"
=begin
    Auteurs :: Galbrun T. Vaudeleau M.
    Version :: 0.1
    ---
    * ===Descriptif
    Une Case est caractérisée par un nombre entre 1 et 4, et possède
    4 lignes (HAUT,BAS,DROITE,GAUCHE).

    * ===Variables d'instance
    [lignes] Tableau stockant les 4 lignes voisines de la Case.
    [nbLigneDevantEtrePleine] Nombre de lignes pleines sur la Case.

    * ===Méthodes d'instance
    [getLigne(direction)] Retourne la ligne à une direction donnée.
    [modifierLigneClic(dirLigne,typeModif)] Modifie une ligne à la
    direction 'dirLigne' en fonction du clic et de l'état de celle-ci.
    [modifierLigneEtat(dirLigne,etatModif)] Modifie une ligne à la
    direction 'dirLigne' avec son nouvel état 'etatMofif'.
    [getLigneEtat(etat)] Renvoie la liste des lignes qui ont l'état demandé.
    [nbLigneEtat(etat)] Renvoie le nombre de ligne ayant un état donné.
    [setAllLignes(etat)] Met toutes les lignes à un état donné.
    [execAllLignes] Exécute un block sur l'ensemble des lignes.
=end

module Direction
    HAUT   = 0
    DROITE = 1
    BAS    = 2
    GAUCHE = 3

    HAUTGAUCHE = 4
    HAUTDROITE = 5
    BASGAUCHE  = 6
    BASDROITE  = 7

    extend OpConstante
end

module Clic
    CLIC_DROIT  = 1
    CLIC_GAUCHE = 2

    extend OpConstante
end

class Case

    # Accès L/E
    attr_accessor :nbLigneDevantEtrePleine

    private_class_method :new

    def Case.creer( num, table )

        new( num, table )
    end

    def initialize( n, t)

        if(n >= 0 && n <= 4)
            @nbLigneDevantEtrePleine = n
        else
            @nbLigneDevantEtrePleine = 4
        end

        @lignes = Array.new(4, nil)

        if ( t[:HAUT] != nil && t[:HAUT].class == Ligne) then
            @lignes[Direction::HAUT] = t[:HAUT]
        else
            @lignes[Direction::HAUT] = Ligne.creer(:VIDE)
        end

        if ( t[:GAUCHE] != nil && t[:GAUCHE].class == Ligne) then
            @lignes[Direction::GAUCHE] = t[:GAUCHE]
        else
            @lignes[Direction::GAUCHE] = Ligne.creer(:VIDE)
        end

        if ( t[:DROITE] != nil && t[:DROITE].class == Ligne) then
            @lignes[Direction::DROITE] = t[:DROITE]
        else
            @lignes[Direction::DROITE] = Ligne.creer(:VIDE)
        end
        
        if ( t[:BAS] != nil && t[:BAS].class == Ligne) then
            @lignes[Direction::BAS] = t[:BAS]
        else
            @lignes[Direction::BAS] = Ligne.creer(:VIDE)
        end
    end

    # Retourne la ligne à une direction donnée
    def getLigne( direction )

        if(Direction.estValide?(direction))
            case direction
            when :HAUT
                return @lignes[Direction::HAUT]
            when :DROITE
                return @lignes[Direction::DROITE]
            when :BAS
                return @lignes[Direction::BAS]
            when :GAUCHE
                return @lignes[Direction::GAUCHE]
            else
                #puts("Mauvaise Direction : "+direction)
                raise DirectionError, "Mauvaise Direction : "+direction.to_s
            end
        end
        raise ArgumentError, "Direction Incorrecte : "+direction.to_s
    end

    # Modifie une ligne à la direction 'dirLigne' en
    # fonction du clic et de l'état de celle-ci.
    def modifierLigneClic( dirLigne, typeModif )
        l = self.getLigne(dirLigne)
        prec = l.etat()

        if(!Clic.estValide?(typeModif))
            return
        end

        case typeModif
            when :CLIC_DROIT
                case l.etat()
                    when :VIDE
                        l.setEtat(:BLOQUE)
                    when :PLEINE
                        l.setEtat(:BLOQUE)
                    when :BLOQUE
                        l.setEtat(:VIDE)
                end
            when :CLIC_GAUCHE
                case l.etat
                    when :VIDE
                        l.setEtat(:PLEINE)
                    when :PLEINE
                        l.setEtat(:VIDE)
                    when :BLOQUE
                        l.setEtat(:PLEINE)
                end
        end

        return prec
    end

    # Modifie une ligne à la direction 'dirLigne' avec son
    # nouvel état 'etatMofif'.
    def modifierLigneEtat( dirLigne, etatModif )

        self.getLigne(dirLigne).setEtat(etatModif)

        return self
    end

    def to_s
        #s = "." + @lignes[Direction::HAUT].to_s() + ".\n"
        #s += @lignes[Direction::GAUCHE].to_s() + @nbLigneDevantEtrePleine.to_s()
        #s += @lignes[Direction::DROITE].to_s() + "\n"
        #s += "." + @lignes[Direction::BAS].to_s() + "."
        s = "|" + @nbLigneDevantEtrePleine.to_s()
        s += ":H=" + @lignes[Direction::HAUT].to_s()
        s += ",G=" + @lignes[Direction::GAUCHE].to_s()
        s += ",B=" + @lignes[Direction::BAS].to_s()
        s += ",D=" + @lignes[Direction::DROITE].to_s()
        s += "|"
        return s
    end

    # Renvoie la liste des lignes qui ont l'état demandé
    def getLigneEtat (etat)
        tls = []
        if (TypeLigne.estValide?(etat))
            for l in @lignes
                if l.etat == etat
                    tls << l
                end
            end
        end
        return tls
    end

    # Renvoie le nombre de ligne ayant un état donné
    def nbLigneEtat(etat)
        nb = 0
        if (TypeLigne.estValide?(etat))
            for l in @lignes
                if l.etat == etat
                    nb += 1
                end
            end
        end
        return nb
    end

    # Met toutes les lignes à un état donné.
    def setAllLignes(etat)
        if (TypeLigne.estValide?(etat))
            execAllLignes{ |l|
                l.setEtat(etat)
            }
        end
    end

    # Exécute un block sur l'ensemble des lignes.
    def execAllLignes()
        for l in @lignes
            yield(l)
        end
    end
end

class CaseError < RuntimeError
end
class DirectionError < CaseError
end
