require_relative "../Boutique/Boutique.rb"
require "gtk3"

class MenuBoutique < Gtk::Box

    private_class_method :new

    def MenuBoutique.creer(gMenu, menuPere)
        new(gMenu, menuPere)
    end

    def initialize(gMenu, menuPere)
        super(:horizontal)
        @gMenu = gMenu
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)
        @listeGrilles = Array.new($nbPuzzlesPayants)
        @listeThemes = Array.new(3)

        @scrolled = Gtk::ScrolledWindow.new
        @scrolled.set_policy(:never, :automatic)
       

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            @gMenu.changerMenu(@pere)
        end

        @titre = Gtk::Label.new("Boutique")
        @titre.style_context.add_class("titre")
        @vBox2.add(@titre)

        p1 = GdkPixbuf::Pixbuf.new(:file => "./image/etoile.png")
        p2 = GdkPixbuf::Pixbuf.new(:file => "./image/argent.png")
        @iEtoile = Gtk::Image.new(:pixbuf => p1.scale_simple($icone, $icone, GdkPixbuf::InterpType::BILINEAR))
        @etoile = Gtk::Label.new(@gMenu.joueur.etoiles.to_s())
        @boxEtoile = Gtk::Box.new(:horizontal)
        @boxEtoile.pack_start(@iEtoile, :expand => true)
        @boxEtoile.pack_end(@etoile, :expand => true)
        @iArgent = Gtk::Image.new(:pixbuf => p2.scale_simple($icone, $icone, GdkPixbuf::InterpType::BILINEAR))
        @argent = Gtk::Label.new(@gMenu.joueur.argent.to_s())
        @boxArgent = Gtk::Box.new(:horizontal)
        @boxArgent.pack_start(@iArgent, :expand => true)
        @boxArgent.pack_end(@argent, :expand => true)
        @boxJoueur = Gtk::Box.new(:vertical)
        @borderJoueur = Gtk::Frame.new()

        @listeGrilles.each_index { |index|
            boxBouton = Gtk::ButtonBox.new(:horizontal)
            boxBouton.set_width_request($longListe)
            border = Gtk::Frame.new()
            boxBouton.set_border_width(10)
            textBox = Gtk::Label.new("Acheter le puzzle n°" + index.to_s)
            bouton = Gtk::Button.new()
            bouton.set_label("Puzzle n°" + index.to_s)
            bouton.signal_connect "clicked" do |_widget|
                puts "Acheter le puzzle n°" + index.to_s
            end
            @listeGrilles[index] = bouton
            boxBouton.add(textBox)
            boxBouton.add(bouton)
            border.add(boxBouton)
            @vBox2.add(border)
        }

        @listeThemes.each_index { |index|
            boxBouton = Gtk::ButtonBox.new(:horizontal)
            boxBouton.set_width_request($longListe)
            border = Gtk::Frame.new()
            boxBouton.set_border_width(10)
            textBox = Gtk::Label.new("Acheter le theme n°" + index.to_s)
            bouton = Gtk::Button.new()
            bouton.set_label("Theme n°" + index.to_s)
            bouton.signal_connect "clicked" do |_widget|
                puts "Acheter le theme n°" + index.to_s
            end
            @listeThemes[index] = bouton
            boxBouton.add(textBox)
            boxBouton.add(bouton)
            border.add(boxBouton)
            @vBox2.add(border)
        }

        ajouter()

    end

    def ajouter()
        @vBox.add(@button1) 
        @boxJoueur.add(@boxEtoile)
        @boxJoueur.add(@boxArgent)
        @borderJoueur.add(@boxJoueur)
        @vBox.pack_end(@borderJoueur)
        add(@vBox)
        @scrolled.add(@vBox2)
        add(@scrolled)
    end
end
