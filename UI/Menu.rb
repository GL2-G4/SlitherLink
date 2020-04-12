require "gtk3"

require_relative "SousMenu.rb"
require_relative "MenuRegles.rb"
require_relative "MenuModeDeJeu.rb"
require_relative "Tutoriel.rb"
require_relative "ParametresUI.rb"
require_relative "MenuBoutique.rb"

class Menu < Gtk::Box

    attr :sousMenu, true
    attr :menuRegles, true
    attr :menuModeDeJeu, true
    attr :tuto, true
    attr :parametres, true
    attr :boutique, true

    private_class_method :new

    def Menu.creer(gMenu)
        new(gMenu)
    end

    def initialize(gMenu)
        super(:horizontal)
        @gMenu = gMenu
        #@hBox = gMenu.box
        @vBox1 = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)

        @button1 = Gtk::Button.new(:label => 'Tutoriel')
        @button1.signal_connect('clicked') {
            gMenu.changerMenu(@tuto)
        }
        @button2 = Gtk::Button.new(:label => 'Mode de jeu')
        @button2.signal_connect('clicked') {
            gMenu.changerMenu(@menuModeDeJeu)
        }
        @button3 = Gtk::Button.new(:label => 'Boutique')
        @button3.signal_connect('clicked') {
            gMenu.changerMenu(MenuBoutique.creer(@gMenu, self))
        }
        @button4 = Gtk::Button.new(:label => 'Paramètres')
        @button4.signal_connect('clicked') {
            gMenu.changerMenu(@parametres)
        }
        @button5 = Gtk::Button.new(:label => 'Règles et Techniques')
        @button5.signal_connect('clicked') {
            gMenu.changerMenu(@menuRegles)
        }
        @button6 = Gtk::Button.new(:label => 'Quitter')
        @button6.signal_connect('clicked') {
            gMenu.app.quit
            #Gtk.main_quit
        }

        ajouter()

    end

    def ajouter()
        @vBox1.pack_start(@button1, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox1.pack_start(@button2, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox1.pack_end(@button3, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_start(@button4, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_start(@button5, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_end(@button6, :expand => true, :fill => true, :padding => $paddingBouton)
        self.pack_start(@vBox1, :expand => true, :fill => true, :padding => $paddingBox)
        self.pack_end(@vBox2, :expand => true, :fill => true, :padding => $paddingBox)
        self.set_homogeneous(true)
    end
end
