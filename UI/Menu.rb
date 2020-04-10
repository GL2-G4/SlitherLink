load "SousMenu.rb"
load "MenuRegles.rb"
load "MenuModeDeJeu.rb"
load "Tutoriel.rb"
load "ParametresUI.rb"
require "gtk3"

class Menu

    attr :sousMenu, true
    attr :menuRegles, true
    attr :menuModeDeJeu, true
    attr :tuto, true
    attr :parametres, true

    private_class_method :new

    def Menu.creer(gMenu)
        new(gMenu)
    end

    def initialize(gMenu)
        
        @gMenu = gMenu
        @hBox = gMenu.box
        @vBox1 = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)

        @button1 = Gtk::Button.new(:label => 'Tutoriel')
        @button1.signal_connect('clicked') {
            gMenu.changerMenu(@tuto, self)
        }
        @button2 = Gtk::Button.new(:label => 'Mode de jeu')
        @button2.signal_connect('clicked') {
            gMenu.changerMenu(@menuModeDeJeu, self)
        }
        @button3 = Gtk::Button.new(:label => 'Boutique')
        @button3.signal_connect('clicked') {
            gMenu.changerMenu(@boutique, self)
        }
        @button4 = Gtk::Button.new(:label => 'Paramètres')
        @button4.signal_connect('clicked') {
            gMenu.changerMenu(@parametres, self)
        }
        @button5 = Gtk::Button.new(:label => 'Règles et Techniques')
        @button5.signal_connect('clicked') {
            gMenu.changerMenu(@menuRegles, self)
        }
        @button6 = Gtk::Button.new(:label => 'Quitter')
        @button6.signal_connect('clicked') {
            gMenu.app.quit
            #Gtk.main_quit
        }

        

    end

    def afficheToi()
        @vBox1.pack_start(@button1, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox1.pack_start(@button2, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox1.pack_end(@button3, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_start(@button4, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_start(@button5, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.pack_end(@button6, :expand => true, :fill => true, :padding => $paddingBouton)
        @hBox.pack_start(@vBox1, :expand => true, :fill => true, :padding => $paddingBox)
        @hBox.pack_end(@vBox2, :expand => true, :fill => true, :padding => $paddingBox)
        @hBox.set_homogeneous(true)
    end

    def enleveToi()
        @vBox1.remove(@button1)
        @vBox1.remove(@button2)
        @vBox1.remove(@button3)
        @vBox2.remove(@button4)
        @vBox2.remove(@button5)
        @vBox2.remove(@button6)
        @hBox.remove(@vBox1)
        @hBox.remove(@vBox2)
        @hBox.set_homogeneous(false)
    end
end
