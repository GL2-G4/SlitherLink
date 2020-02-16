path = File.expand_path(File.dirname(__FILE__))

require path + "/Constante"

=begin
    Auteurs :: Galbrun T. Vaudeleau M.
    Version :: 0.1
    ---
    * ===Variables d'instance
    [etat] Etat de la ligne [VIDE|PLEINE|BLOQUE]
=end

module TypeLigne
    VIDE   = 0
    PLEINE = 1
    BLOQUE = 2

    extend OpConstante
end

class Ligne

    # Accès L
    attr_reader :etat

    private_class_method :new

    def Ligne.creer( etat )
        new ( etat )
    end

    def initialize( e )
        if (TypeLigne.estValide?(e))
            @etat = e
        else
            @etat = :VIDE
        end
    end

    def setEtat( etat )
        if (TypeLigne.estValide?(etat))
            @etat = etat
        end
        self
    end

    def to_s
        case @etat
        when :VIDE
            return " "
        when :PLEINE
            return "="
        when :BLOQUE
            return "x"
        else
            return " "
        end
    end
end

class LigneError < RuntimeError
end
class TypeLigneError < LigneError
end