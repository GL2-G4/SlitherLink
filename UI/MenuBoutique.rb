require_relative "../Boutique/Boutique.rb"
require "gtk3"

class MenuBoutique < Gtk::Box

    private_class_method :new

    def MenuBoutique.creer(gMenu, menuPere, boutique)
        new(gMenu, menuPere, boutique)
    end

    def initialize(gMenu, menuPere, boutique)
        super(:horizontal)
        @gMenu = gMenu
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::Box.new(:vertical)
        @boutique = boutique

        @scrolled = Gtk::ScrolledWindow.new
        @scrolled.set_policy(:never, :automatic)
        @scrolled.set_hexpand(true)

        path = File.expand_path(File.dirname(__FILE__))
       

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            @gMenu.changerMenu(@pere)
        end

        @titre = Gtk::Label.new("Boutique")
        @titre.style_context.add_class("titre")
        @vBox2.add(@titre)

        p1 = GdkPixbuf::Pixbuf.new(:file => path + "/image/etoile.png")
        p2 = GdkPixbuf::Pixbuf.new(:file => path + "/image/argent.png")
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
        @sautdeligne = Gtk::Label.new("\n\n")

        @boutique.listeGrilles.each_index { |index|
            if(!@boutique.listeGrilles[index].debloque  && @boutique.listeGrilles[index].prixPieces > 0)
                boxBouton = Gtk::ButtonBox.new(:horizontal)
                boxBouton.set_width_request($longListe)
                border = Gtk::Frame.new()
                boxBouton.set_border_width(10)
                textBox = Gtk::Label.new("Acheter le puzzle pour " + @boutique.listeGrilles[index].prixPieces.to_s + " et " + @boutique.listeGrilles[index].prixEtoiles.to_s + " étoiles nécesaires")
                bouton = Gtk::Button.new()
                bouton.set_label("Puzzle n°" + index.to_s)
                bouton.signal_connect "clicked" do |_widget|
                    #Test pour avoir toujours assez d'argent
                    #gMenu.joueur.ajouterArgent(@boutique.listeGrilles[index].prixPieces)
                    #gMenu.joueur.ajouterEtoiles(@boutique.listeGrilles[index].prixEtoiles)
                    @boutique.acheterGrille(gMenu.joueur, index)
                    majMonnaie
                    if(@boutique.listeGrilles[index].debloque)
                        bouton.set_label("Acheté")
                        bouton.set_sensitive(false)
                    end
                end
                boxBouton.add(textBox)
                boxBouton.add(bouton)
                border.add(boxBouton)
                @vBox2.add(border)
            end
        }
        @vBox2.add(@sautdeligne)
        @boutique.listeThemes.each_index { |index|
            if(!@boutique.listeThemes[index].debloque)
                boxBouton = Gtk::ButtonBox.new(:horizontal)
                boxBouton.set_width_request($longListe)
                border = Gtk::Frame.new()
                boxBouton.set_border_width(10)
                textBox = Gtk::Label.new("Acheter le theme pour " + @boutique.listeThemes[index].prix.to_s)
                bouton = Gtk::Button.new()
                bouton.set_label(@boutique.listeThemes[index].nom)
                bouton.signal_connect "clicked" do |_widget|
                    #Test pour toujours avoir assez d'argent
                    #gMenu.joueur.ajouterArgent(@boutique.listeThemes[index].prix)
                    @boutique.acheterTheme(gMenu.joueur, index)
                    majMonnaie
                    if(@boutique.listeThemes[index].debloque)
                        bouton.set_label("Acheté")
                        bouton.set_sensitive(false)
                    end
                end
                boxBouton.add(textBox)
                boxBouton.add(bouton)
                border.add(boxBouton)
                @vBox2.add(border)
            end
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

    def majMonnaie()
        @etoile.set_label(@gMenu.joueur.etoiles.to_s())
        @argent.set_label(@gMenu.joueur.argent.to_s())
    end
end
