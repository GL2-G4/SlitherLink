##
# File: Challenge.rb
# Project: UI
# File Created: Tuesday, 14th April 2020 3:52:18 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 14th April 2020 5:07:09 pm
# Modified By: <CPietJa>Galbrun T.
#
require 'gtk3'
require_relative './PartieUI.rb'
require_relative './ScreenGagneC1.rb'
require_relative './ScreenGagneC2.rb'
require_relative './ChallengeManager.rb'

=begin
    *=== Descriptif
    Gère un challenge en enchainant les grilles à jouer.
=end
class Challenge
    attr_reader :index, :chargeurGrille
    attr_accessor :temps

    def initialize(gMenu,pere,challenge)
        @gMenu = gMenu
        @pere = pere
        @challenge = challenge
        @index = 0
        @temps = 0

        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/Challenges/"+challenge["grilles"])
        grille = @chargeurGrille.getGrilleIndex(index)
        jeu = Jeu.charger(grille)
        uiP = PartieUI.creer(@gMenu,self,jeu,grille,screenG:ScreenGagneC1)
        @gMenu.changerMenu(uiP)
    end

    def partieSuivante
        @index += 1
        grille = @chargeurGrille.getGrilleIndex(@index)
        jeu = Jeu.charger(grille)
        if(index < @chargeurGrille.listeGrilles.length - 1)
            # ScreenG C1
            uiP = PartieUI.creer(@gMenu,self,jeu,grille,screenG:ScreenGagneC1)
        else
            # ScreenG C2
            uiP = PartieUI.creer(@gMenu,self,jeu,grille,screenG:ScreenGagneC2)
        end
        return uiP
    end

    def fini
        @challenge["temps"] = @temps
        if(@temps < @challenge["m_temps"] || @challenge["m_temps"] == 0)
            @challenge["m_temps"] = @temps
        end
        @pere.challenges.sauvegarder()
    end
end
