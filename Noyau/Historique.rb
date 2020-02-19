require "./Action"
=begin
    Auteurs :: Galbrun T. Vaudeleau M.
    Version :: 0.1
    ---
    * ===Descriptif
=end

class Historique

    def initialize

        @historiqueActions = []
        @position = -1
    end

    def ajouterAction (action)
        
        if (action.class() != Action)
            raise ActionError, "Action Invalide !"
        end

        if (@position != @historiqueActions.size()-1)
            @historiqueActions.pop(@historiqueActions.size()-1-@position)
        end

        @historiqueActions.push(action)
        @position += 1

        return self
    end

    def undo

        if (@position == -1)
            raise EmptyHistoriqueError, "Undo Impossible !"
        end

        @position -= 1
        return @historiqueActions[@position+1]
    end

    def redo

        if (@position == @historiqueActions.size()-1)
            raise RedoHistoriqueError, "Redo Impossible !"
        end

        @position += 1
        return @historiqueActions[@position]
    end

    def getAction()

        return @historiqueActions
    end

    def getPos()

        return @position
    end

    def setPos( pos)

        @position = pos
        return self
    end

    def reset( ha, pos)

        @historiqueActions = ha
        @position = pos
    end

    def to_s

        chaine = "\n\t\t\t===== Historique =====\n"

        @historiqueActions.each() { |a|

            chaine += a.to_s()
        }
        return chaine
    end
end

class HistoriqueError < RuntimeError
end
class EmptyHistoriqueError < HistoriqueError
end
class RedoHistoriqueError < HistoriqueError
end