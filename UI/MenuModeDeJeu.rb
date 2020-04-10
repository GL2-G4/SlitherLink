require_relative "MenuAventure.rb"
require_relative "MenuApprentissage.rb"
require_relative "MenuChallenge.rb"

require "gtk3"

class MenuModeDeJeu < Gtk::Box

    private_class_method :new

    def MenuModeDeJeu.creer(gMenu, menuPere)
        new(gMenu, menuPere)
    end

    def initialize(gMenu, menuPere)
        super(:horizontal)
        @gMenu = gMenu
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)

        @titre = Gtk::Label.new("Mode de jeu")
        @titre.style_context.add_class("titre")
        @vBox.add(@titre)

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(@pere)
        end
        @button2 = Gtk::Button.new(:label => "Aventure")
        @button2.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuAventure.creer(@gMenu, self))
        end
        @button3 = Gtk::Button.new(:label => "Apprentissage")
        @button3.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuApprentissage.creer(@gMenu, self))
        end
        @button4 = Gtk::Button.new(:label => "Challenge")
        @button4.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuChallenge.creer(@gMenu, self))
        end
        ajouter()
    end

    def ajouter()
        @vBox.pack_start(@button2, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox.pack_start(@button3, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox.pack_end(@button4, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.add(@button1)
        add(@vBox2)
        pack_end(@vBox, :expand => true, :fill => true, :padding => 0)
    end
end