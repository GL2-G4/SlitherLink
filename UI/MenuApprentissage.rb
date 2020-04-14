require "gtk3"
require_relative './PartieUI.rb'
require_relative '../Noyau/LoadSaveGrilles/ChargeurGrille.rb'
require_relative './ImageManager.rb'
require_relative './ScreenGagne2.rb'

class MenuApprentissage < Gtk::Box

    private_class_method :new

    attr_reader :chargeurGrille

    def MenuApprentissage.creer(gMenu, menuPere)
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
        @scrolled.set_hexpand(true)

        path = File.expand_path(File.dirname(__FILE__))
       

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            @gMenu.changerMenu(@pere)
        end

        @titre = Gtk::Label.new("Apprentissage")
        @titre.style_context.add_class("titre")
        @vBox2.add(@titre)

        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grilleApprentissage")
        @chargeurGrille.debloquerGrilles(@gMenu.joueur.etoiles)
        @chargeurGrille.sauvegarder(File.dirname(__FILE__) + "/../Grilles/grilleApprentissage")
        #@listeBoutons.each_index { |index|
        @chargeurGrille.listeGrilles.each_index { |index|
            # if(index == 0)
            #     @facile = Gtk::Label.new("FACILE")
            #     @facile.style_context.add_class("titre")
            #     @vBox2.add(@facile)
            # end
            # if(index == 55)
            #     @moyen = Gtk::Label.new("MOYEN")
            #     @moyen.style_context.add_class("titre")
            #     @vBox2.add(@moyen)
            # end
            # if(index == 100)
            #     @difficile = Gtk::Label.new("DIFFICILE")
            #     @difficile.style_context.add_class("titre")
            #     @vBox2.add(@difficile)
            # end
            boxBouton = Gtk::ButtonBox.new(:horizontal)
            boxBouton.set_width_request($longListe)
            border = Gtk::Frame.new()
            boxBouton.set_border_width(10)
            grille = @chargeurGrille.getGrilleIndex(index)
            # Taille
            textBox = Gtk::Label.new("Entrainement avec un puzzle #{grille.plateau[0].length}x#{grille.plateau.length}")
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
            # Bouton Jouer
            bouton = Gtk::Button.new(:label => "Jouer")
            bouton.signal_connect "clicked" do |_widget|
                #puts "Jouer au puzzle n°" + (index+1).to_s
                $apprOrAdventure = 1
                Sauv.recupÎnfo( 1, index)
                jeu = Jeu.charger(grille)
                uiP = PartieUI.creer(@gMenu,self,jeu,grille,screenG:ScreenGagne2)
                @gMenu.changerMenu(uiP)
            end
            if(@gMenu.joueur.grilleDebloquee?(@chargeurGrille.getGrilleIndex(index)) == false)
                #bouton.set_label("Bloquée")
                bouton.set_sensitive(false)
                if(grille.prixEtoiles != 0)
                    bouton.set_label(grille.prixEtoiles.to_s)
                    bouton.set_image(ImageManager.getImageFromFile(path + "/image/etoile.png",15,15))
                else
                    bouton.set_label(grille.prixPieces.to_s)
                    bouton.set_image(ImageManager.getImageFromFile(path + "/image/argent.png",15,15))
                end
            end
            bouton.set_always_show_image(true)
            #@listeBoutons[index] = bouton
            boxBouton.add(textBox)
            boxBouton.add(temps)
            boxBouton.add(bouton)
            border.add(boxBouton)
            @vBox2.add(border)
        }
        ajouter()
    end

    def ajouter()
        @vBox.add(@button1)
        add(@vBox)
        @scrolled.add(@vBox2)
        add(@scrolled)
    end
    
end
