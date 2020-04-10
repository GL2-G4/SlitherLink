load "MenuAventure.rb"
load "MenuApprentissage.rb"
load "MenuChallenge.rb"

require "gtk3"

class MenuModeDeJeu

    private_class_method :new

    def MenuModeDeJeu.creer(gMenu, menuPere)
        new(gMenu, menuPere)
    end

    def initialize(gMenu, menuPere)
        @gMenu = gMenu
        @box = gMenu.box
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)

        @titre = Gtk::Label.new("Mode de jeu")
        @titre.style_context.add_class("titre")
        @vBox.add(@titre)

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(@pere, self)
        end
        @button2 = Gtk::Button.new(:label => "Aventure")
        @button2.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuAventure.creer(@gMenu, self), self)
        end
        @button3 = Gtk::Button.new(:label => "Apprentissage")
        @button3.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuApprentissage.creer(@gMenu, self), self)
        end
        @button4 = Gtk::Button.new(:label => "Challenge")
        @button4.signal_connect "clicked" do |_widget|
            gMenu.changerMenu(MenuChallenge.creer(@gMenu, self), self)
        end
    end

    def afficheToi()
        @vBox.pack_start(@button2, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox.pack_start(@button3, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox.pack_end(@button4, :expand => true, :fill => true, :padding => $paddingBouton)
        @vBox2.add(@button1)
        @box.add(@vBox2)
        @box.pack_end(@vBox, :expand => true, :fill => true, :padding => 0)
    end

    def enleveToi()
        @vBox.remove(@button2)
        @vBox.remove(@button3)
        @vBox.remove(@button4)
        @vBox2.remove(@button1)
        @box.remove(@vBox2)
        @box.remove(@vBox)
    end
end