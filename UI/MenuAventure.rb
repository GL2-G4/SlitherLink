require "gtk3"
require_relative './PartieUI.rb'
require_relative '../Noyau/LoadSaveGrilles/ChargeurGrille.rb'
require_relative './ImageManager.rb'

class MenuAventure < Gtk::Box

    private_class_method :new

    attr_reader :chargeurGrille

    def MenuAventure.creer(gMenu, menuPere)
        new(gMenu, menuPere)
    end

    def initialize(gMenu, menuPere)
        super(:horizontal)
        @gMenu = gMenu
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::ButtonBox.new(:vertical)
        #@listeBoutons = Array.new($nbPuzzles);

        @scrolled = Gtk::ScrolledWindow.new
        @scrolled.set_policy(:never, :automatic)

        path = File.expand_path(File.dirname(__FILE__))
       

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            @gMenu.changerMenu(@pere)
        end

        @titre = Gtk::Label.new("Aventure")
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

        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grilleAventure")
        @chargeurGrille.debloquerGrilles(@gMenu.joueur.etoiles)
        @chargeurGrille.sauvegarder(File.dirname(__FILE__) + "/../Grilles/grilleAventure")
        #@listeBoutons.each_index { |index|
        chargeurGrille.listeGrilles.each_index { |index|
            boxBouton = Gtk::ButtonBox.new(:horizontal)
            boxBouton.set_width_request($longListe)
            border = Gtk::Frame.new()
            boxBouton.set_border_width(10)
            grille = @chargeurGrille.getGrilleIndex(index)
            # Taille
            textBox = Gtk::Label.new("Puzzle #{grille.plateau[0].length}x#{grille.plateau.length}")
            # Temps
            if(grille.meilleurTemps != 0)
                hour = grille.meilleurTemps/60/60
                min = (grille.meilleurTemps - (hour*60))/60
                sec =  (grille.meilleurTemps - (hour*60) - (min*60))
                #puts "#{hour}:#{min}:#{sec}"
                temps = Gtk::Label.new(sprintf("%02d:%02d",min,sec))
            else
                temps = Gtk::Label.new("--:--")
            end
            # NB Etoiles
            etoiles = Gtk::Box.new(:horizontal)
            grille.nombreEtoiles.times(){
                etoiles.add(ImageManager.getImageFromFile(path + "/image/etoile.png",20,20))
            }
            # Bouton Jouer
            bouton = Gtk::Button.new(:label => "Jouer")
            bouton.signal_connect "clicked" do |_widget|
                puts "Jouer au puzzle n°" + (index+1).to_s
                jeu = Jeu.charger(grille)
                uiP = PartieUI.creer(@gMenu,self,jeu,grille)
                @gMenu.changerMenu(uiP)
            end
            if(@gMenu.joueur.grilleDebloquee?(chargeurGrille.getGrilleIndex(index)) == false)
                bouton.set_label("Bloquée")
                bouton.set_sensitive(false)
            end
            #@listeBoutons[index] = bouton
            boxBouton.add(textBox)
            boxBouton.add(temps)
            boxBouton.add(etoiles)
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
