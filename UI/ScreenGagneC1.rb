##
# File: ScreenGagneC1.rb
# Project: UI
# File Created: Monday, 13th April 2020 7:45:52 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 14th April 2020 4:51:48 pm
# Modified By: <CPietJa>Galbrun T.
#

require 'gtk3'
require_relative './ImageManager.rb'

=begin
    *=== Descriptif
    Ecran de win d'une partie.
=end
class ScreenGagneC1 < Gtk::Box

    def initialize(gMenu,partie)
        super(:vertical)
        @gMenu = gMenu
        @pere = partie
        @partieS = @pere.pere.partieSuivante()
        @pere.pere.temps += partie.chrono.getSec()
        @fenetre = Gtk::Box.new(:horizontal)
        @fenetre.set_homogeneous(true)
        #set_homogeneous(true)
        @fenetre.set_halign(Gtk::Align::CENTER)
        set_valign(Gtk::Align::CENTER)
        #override_background_color(:normal,ROUGE)

        path = File.expand_path(File.dirname(__FILE__))

        # Titre
        titre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Bravo !</b></span>")
        #titre.set_margin_bottom(10)
        # Sous Titre
        stitre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Vous avez fini #{@pere.pere.index}/5 !</b></span>")
        stitre.set_margin_bottom(30)
        # Btn Grille Suivante
        creerBtn(:image => :ICON_PLAY){
            #puts 'Grille Suivante'
            @gMenu.changerMenu(@partieS)
        }

        add(titre)
        add(stitre)
        add(@fenetre)
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