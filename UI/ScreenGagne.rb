##
# File: ScreenGagne.rb
# Project: UI
# File Created: Saturday, 11th April 2020 4:19:13 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Saturday, 11th April 2020 7:22:01 pm
# Modified By: <CPietJa>Galbrun T.
#

require 'gtk3'
require_relative './ImageManager.rb'

=begin
    *=== Descriptif
    Ecran de win d'une partie.
=end
class ScreenGagne < Gtk::Box

    def initialize(gMenu,menu,temps)
        super(:vertical)
        @gMenu = gMenu
        @pere = menu
        @temps = temps
        @fenetre = Gtk::Box.new(:horizontal)
        @fenetre.set_homogeneous(true)
        #set_homogeneous(true)
        @fenetre.set_halign(Gtk::Align::CENTER)
        set_valign(Gtk::Align::CENTER)
        #override_background_color(:normal,ROUGE)

        # Titre
        titre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Bravo !</b></span>")
        #titre.set_margin_bottom(10)
        # Sous Titre
        stitre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Vous avez Gagné !</b></span>")
        stitre.set_margin_bottom(10)
        # Temps
        l_temps = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>#{@temps}</b></span>")
        l_temps.set_margin_bottom(30)
        # Btn Liste des niveaux
        creerBtn(:image => :ICON_DOC){
            #puts 'Liste des Niveaux'
            @gMenu.changerMenu(MenuAventure.creer(@gMenu, @gMenu.menu.menuModeDeJeu))
        }
        # Btn Quitter
        creerBtn(:image => :ICON_HOME){
            #puts 'Menu'
            @gMenu.changerMenu(@gMenu.menu)
        }

        add(titre)
        add(stitre)
        add(l_temps)
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