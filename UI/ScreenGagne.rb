##
# File: ScreenGagne.rb
# Project: UI
# File Created: Saturday, 11th April 2020 4:19:13 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Monday, 13th April 2020 7:15:16 pm
# Modified By: <CPietJa>Galbrun T.
#

require 'gtk3'
require_relative './ImageManager.rb'

=begin
    *=== Descriptif
    Ecran de win d'une partie.
=end
class ScreenGagne < Gtk::Box

    def initialize(gMenu,partie)
        super(:vertical)
        @gMenu = gMenu
        @pere = partie
        @temps = partie.chrono.getTime.strftime("%M:%S")
        etoiles = partie.grilleS.nombreEtoiles - partie.etoile
        argent = @gMenu.joueur.argent - partie.argent
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
        stitre = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>Vous avez Gagné !</b></span>")
        stitre.set_margin_bottom(10)
        # Temps
        l_temps = Gtk::Label.new.set_markup("<span font_desc=\"30.0\"><b>#{@temps}</b></span>")
        l_temps.set_margin_bottom(10)
        # Etoiles
        bEtoiles = Gtk::Box.new(:horizontal).set_margin_bottom(10).set_halign(Gtk::Align::CENTER)
        @pere.grilleS.nombreEtoiles.times(){
            bEtoiles.add(ImageManager.getImageFromFile(path + "/image/etoile.png",60,60))
        }
        bRec = Gtk::Box.new(:horizontal).set_margin_bottom(30).set_halign(Gtk::Align::CENTER)
        bRec.add(Gtk::Label.new.set_markup("<span font_desc=\"20.0\"><b>+#{etoiles}</b></span>"))
        bRec.add(ImageManager.getImageFromFile(path + "/image/etoile.png",30,30).set_margin_right(10))
        bRec.add(Gtk::Label.new.set_markup("<span font_desc=\"20.0\"><b>+#{argent}</b></span>"))
        bRec.add(ImageManager.getImageFromFile(path + "/image/argent.png",30,30))
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
        add(bEtoiles)
        add(bRec)
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