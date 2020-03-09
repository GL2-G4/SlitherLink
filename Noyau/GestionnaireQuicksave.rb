=begin
    Auteurs :: Vaudeleau M.
    Version :: 0.1
    ---
    * ===Descriptif
    Les objets GestionnaireQuicksave permmettent de gérer des Quicksave.
    On peut avec ces objets demander a sauvegardé l'état de la grille a un certain moment ou charger une grille a un moment donné. 
=end

require "./Quicksave.rb"

class GestionnaireQuicksave

    private_class_method:new

    # Creation d'un nouveau Gestionnaire de Quicksave. Il ne devrait y avoir qu'un seul GestionnaireQuicksave par grille
    # Ce Gestionnaire de Quicksave doit connaitre le plateau de jeu et l'historique des actions de jeu
    def GestionnaireQuicksave.nouveau( plateau, historiqueActions)

        new( plateau, historiqueActions)
    end

    def initialize( p, ha)

        @plateau = p
        @ha = ha
        @listeQs = Array.new()
        @dernierChargement = 0
        @chargementSafe = false
    end

    # permet d'enregistrer une nouvelle Quicksave dans le gestionnaire
    #
    # Si la sauvegarde est effectué aprés le chargement d'une quicksave, toutes les quicksave réalisé aprés la quicksave qui a été chargé sont supprimé. Il n'y a aucun moyen de les récupérer
    def nouvelleQuicksave()

        if ( @dernierChargement > @listeQs.size() ) then

            @listeQs.drop( @listeQs.size() - @dernierChargement - 1)
        end

        @listeQs << Quicksave.nouveau( @plateau, @ha)
        @chargementSafe = false
    end

    # charge une Quicksave en jeu en lui passant le numero de la Quicksave qui doit etre chargé
    #
    # Avant le chargement de la Quicksave, le plateau de jeu et l'historique est sauvegardé.
    # On peut charger cette sauvegarde a l'aide de la méthode chargerSafe().
    # Cette sauvegarde ne peut plus etre chargé a partir du moment ou une nouvelle Quicksave est créer a l'aide de la méthode nouvelleQuicksave
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

        @chargementSafe = true

        return self
    end

    # Permet le chargement de la grille juste avant le dernier chargement d'un Quicksave.
    #
    # Si une quicksave a été enregistré aprés le dernier chargement d'une quicksave, ne fait rien
    def chargerSafe()

        if ( @chargementSafe == true ) then
            @safeSave.charger( @plateau, @ha)
        end

        return self
    end
end

class NoQuicksaveSave < RuntimeError
end

class QuicksaveSaveOutOfBounds < RuntimeError
end