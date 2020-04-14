##
# File: ScreenPause.rb
# Project: UI
# File Created: Wednesday, 8th April 2020 3:56:39 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Sunday, 12th April 2020 6:09:53 pm
# Modified By: <CPietJa>Galbrun T.
#
require 'gtk3'
require_relative './ImageManager.rb'

=begin
    *=== Descriptif
    Ecran de pause d'une partie.
=end
class ScreenPause < Gtk::Box
    ROUGE = Gdk::RGBA.new(1,0,0,0.5)

    def initialize(gMenu,partie)
        super(:vertical)
        @gMenu = gMenu
        @partie = partie
        @fenetre = Gtk::Box.new(:horizontal)
        @fenetre.set_homogeneous(true)
        #set_homogeneous(true)
        @fenetre.set_halign(Gtk::Align::CENTER)
        set_valign(Gtk::Align::CENTER)
        #override_background_color(:normal,ROUGE)

        # Titre
        titre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Pause</b></span>")
        titre.set_margin_bottom(30)
        # Btn Continuer
        creerBtn(:image => :ICON_PLAY){
            #puts 'Continuer'
            @gMenu.changerMenu(@partie)
            @partie.playChrono()
        }
        # Btn Recommencer
        creerBtn(:image => :ICON_RESTART){
            #puts 'Restart'
            jeu = Jeu.charger(@partie.grilleS)
            uiP = PartieUI.creer(@gMenu,@partie.pere,jeu,@partie.grilleS)
            @gMenu.changerMenu(uiP)
        }
        # Btn Règles
        creerBtn(:image => :ICON_DOC){
            #puts 'Règles'
            $apprOrAdventure = 0
            @gMenu.changerMenu(@gMenu.menu.menuRegles)
        }
        # Btn Quitter
        creerBtn(:image => :ICON_HOME){
            #puts 'Menu'
            @gMenu.changerMenu(@partie.pere)
            $apprOrAdventure = 0
        }

        add(titre)
        add(@fenetre)
    end

    def afficheToi()
        @fenetre.show_all
    end

    def effaceToi()
        @fenetre.hide
    end
    
    private
    def creerBtn(label:"",image:nil)
        box = Gtk::Box.new(:vertical)
        btn = Gtk::Button.new(:label => label)
        btn.set_margin_left(20)
        btn.set_margin_right(20)
        if(image != nil)
            btn.set_image(ImageManager.getImageFromStock(image,50,50))
            btn.set_always_show_image(true)
        end
        btn.signal_connect('button_release_event'){ |widget,event|
            yield(widget,event)
        }
        btn.set_yalign(0.5)
        btn.set_xalign(0.5)
        box.add(btn)
        @fenetre.add(box)
        return self
    end
end