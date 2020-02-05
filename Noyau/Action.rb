require "./Case"
require "./Ligne"
=begin
    Auteurs :: Galbrun T. Vaudeleau M.
    Version :: 0.1
    ---
    * ===Descriptif
    La class Action permet de stocké des objets qui contienne une et unique action joué par l'utilisateur.
=end

class Action

=begin
    * ===Variables d'instance
    [x] cooronnées en x ( colonne ) de la case appartenant a la ligne ayant été modifié
    [y] cooronnées en y ( ligne ) de la case appartenant a la ligne ayant été modifié
    [direction] direction ( haut, droit ... ) de la ligne ayant été modifié par rapport a la case
    [avant] état de la ligne avant sa modification
    [apres] état de la ligne aprés sa modification
=end

    def initialize (x,y,direction,avant,apres)
        if ( ! Direction.estValide?(direction))
            raise DirectionError, "Direction Incorrecte : #{direction}"
        end
        if ( ! TypeLigne.estValide?(avant) || ! TypeLigne.estValide?(apres))
            raise TypeLigneError, "Etat Ligne Incorrect : #{avant}, #{apres}"
        end

        @x, @y, @direction, @avant, @apres = x,y,direction,avant,apres
    end

    attr_reader :x, :y, :direction, :avant, :apres

    def to_s
        return "   [ case [#{@x}, #{@y}] Ligne : #{@direction}, etat avant/apres : #{@avant} / #{@apres} ]\n"
    end
end

class ActionError < RuntimeError
end