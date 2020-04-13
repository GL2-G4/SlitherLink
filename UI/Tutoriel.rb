require "gtk3"
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"

class Tutoriel < Gtk::Box

  attr_reader :chargeurGrille

  def Tutoriel.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    path = File.expand_path(File.dirname(__FILE__))
    @gMenu = gMenu
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @vBoxBis0 = Gtk::Box.new(:vertical)
    @vBoxBis1 = Gtk::Box.new(:vertical)
    @vBoxBis2 = Gtk::Box.new(:vertical)
    @vBoxBis3 = Gtk::Box.new(:vertical)
    @hBox2 = Gtk::Box.new(:horizontal)
    @hBox = Gtk::Box.new(:horizontal)
    @titre = Gtk::Label.new("Bienvenue dans le Tutoriel !")
    @titre.style_context.add_class("titre")
    @titre2 = Gtk::Label.new("Entraine toi et découvre les différents boutons !")
    @titre2.style_context.add_class("titre")


    @paragraphe = Gtk::Label.new("\n\n\nVoici une technique de base. Quand un 3 est dans un coin : \n\n\n")
    @paragraphe2 = Gtk::Label.new("\n\n\nVoici une technique de base. Quand deux 3 sont cotes à cotes : \n\n\n")
    @paragraphe3 = Gtk::Label.new("\n\n\nVoici une technique de base. Lorsque l'on rencontre un 0 : \n\n\n")
    @paragraphe4 = Gtk::Label.new("\n\n\nChaque puzzle se compose d'un réseau rectangulaire de points avec quelques indices à divers endroits.\n L'objectif est de relier les points adjacents de la manière suivante:\n\n
    * La valeur de chaque case est égale au nombre de liens qui l'entourent.
    * Les cases vides peuvent être entourées d'un certain nombre de liens (de 0 à 3).
    * Une fois terminée, la solution forme une seule boucle continue sans croisements ni branches.\n
    
    Exemple : \n\n")
    

    p1 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique1.png")
    @iTech1 = Gtk::Image.new(:pixbuf => p1.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p2 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique2.png")
    @iTech2 = Gtk::Image.new(:pixbuf => p2.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p3 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique3.png")
    @iTech3 = Gtk::Image.new(:pixbuf => p3.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))

    p4 = GdkPixbuf::Pixbuf.new(:file => path + "/image/regles1.png")
    @iTech4 = Gtk::Image.new(:pixbuf => p1.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p5 = GdkPixbuf::Pixbuf.new(:file => path + "/image/regles2.png")
    @iTech5 = Gtk::Image.new(:pixbuf => p2.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    @iTech4.set_margin_right(150)


    @vBoxBis0.add(@paragraphe4)
    @hBox.add(@iTech4)
    @hBox.add(@iTech5)
    @vBoxBis0.add(@hBox)

    @vBoxBis1.add(@paragraphe)
    @vBoxBis1.add(@iTech1)

    @vBoxBis2.add(@paragraphe2)
    @vBoxBis2.add(@iTech2)

    @vBoxBis3.add(@paragraphe3)
    @vBoxBis3.add(@iTech3)

    @i = 0;

    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      changerBox(@vBoxBis1)
      @i = 0
      gMenu.changerMenu(@pere)
    end
    @button2 = Gtk::Button.new(:label => "- Suivant -")
    @button2.signal_connect "clicked" do |_widget|
      if(@i == 0) 
        changerBox(@vBoxBis1)
        @i += 1
      elsif(@i == 1)
        changerBox(@vBoxBis2)
        @i += 1
      elsif(@i == 2)
        changerBox(@vBoxBis3)
        @i += 1
      elsif(@i == 3)
        @i +=1
        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grilleTuto")
        grille = @chargeurGrille.getGrilleIndex(0)
        
        jeu = Jeu.charger(grille)
        uiP = PartieUI.creer(@gMenu, self, jeu, grille)
        changerBox(uiP)
      end
    end
    @hBox2.add(@button2)
    @hBox2.set_halign(Gtk::Align::CENTER)
    ajouter()
end

  def ajouter()
    @vBox1.pack_start(Gtk::Alignment.new(0, 0, 1, 1), :expand => false)
    @vBox1.add(@button)
    @vBox2.set_width_request($longListe)
    @vBox2.add(@titre)
    @vBox2.add(@vBoxBis0)
    @vBox2.add(@hBox2)
    add(@vBox1)
    pack_end(@vBox2, :expand => true, :fill => true, :padding => 0)
  end

  def changerBox(maBox)
      @vBox2.each { |child|
         @vBox2.remove(child)
      }
      if(@i != 4)
        @vBox2.add(@titre)
      else
        @vBox2.add(@titre2)
      end
      @vBox2.add(maBox)
      if(@i != 4)
        @vBox2.add(@hBox2)
      else
        @i = 0
      end
      @vBox2.show_all
end

  def to_s()
    return "Tuto"
  end
end