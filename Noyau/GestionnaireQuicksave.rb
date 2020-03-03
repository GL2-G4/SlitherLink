require "./Quicksave.rb"

class GestionnaireQuicksave

    private_class_method:new

    def GestionnaireQuicksave.nouveau( plateau, historiqueActions)

        new( plateau, historiqueActions)
    end

    def initialize( p, ha)

        @plateau = p
        @ha = ha
        @listeQs = Array.new()
    end

    def nouvelleQuicksave()

        @listeQs << Quicksave.nouveau( @plateau, @ha)
    end

    def charger()

        @listeQs.pop().charger( @plateau, @ha )
    end
end