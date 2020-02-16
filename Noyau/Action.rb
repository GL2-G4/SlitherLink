path = File.expand_path(File.dirname(__FILE__))

require path + "/Case"
require path + "/Ligne"
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

    def initialize (ligne,avant,apres)
        if ( ligne.class() != Ligne)
            raise LigneError, "Ligne Attendue : #{ligne}"
        end
        if ( ! TypeLigne.estValide?(avant) || ! TypeLigne.estValide?(apres))
            raise TypeLigneError, "Etat Ligne Incorrect : #{avant}, #{apres}"
        end

        @ligne, @avant, @apres = ligne,avant,apres
    end

    attr_reader :ligne, :avant, :apres

    def to_s
        return "   [ Ligne : [#{@ligne.etat} : #{@ligne}], etat avant/apres : #{@avant} / #{@apres} ]\n"
    end
end

class ActionError < RuntimeError
end