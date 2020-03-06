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
        @dernierChargement = 0
    end

    def nouvelleQuicksave()

        if ( @dernierChargement > @listeQs.size() ) then

            @listeQs.drop( @listeQs.size() - @dernierChargement - 1)
        end

        @listeQs << Quicksave.nouveau( @plateau, @ha)
    end

    def charger( numQS )

        if ( @listeQs.empty?() ) then

            raise NoQuicksaveSave.new( "Aucune quicksave enregistré, impossible d'en charger une")
        end

        if ( numQS.to_i() >= @listeQs.size() ) then

            raise QuicksaveSaveOutOfBounds.new( "Aucune quicksave enregistré a l'emplacement " + numQS )
        end

        @safeSave = Quicksave.nouveau( @plateau, @ha )
        @listeQs.at( numQS ).charger( @plateau, @ha )
        @dernierChargement = numQS
    end

    def chargerSafe()

        @safeSave.charger( @plateau, @ha)
    end
end

class NoQuicksaveSave < RuntimeError
end

class QuicksaveSaveOutOfBounds < RuntimeError
end