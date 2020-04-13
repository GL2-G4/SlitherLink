require "gtk3"
require_relative "../Noyau/Jeu.rb"
require_relative "./PartieUI.rb"
require_relative "../Noyau/LoadSaveGrilles/ChargeurGrille.rb"
require_relative "./ScreenPause.rb"

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
    @vBoxBis1 = Gtk::Box.new(:vertical)
    @vBoxBis2 = Gtk::Box.new(:vertical)
    @vBoxBis3 = Gtk::Box.new(:vertical)
    @hBox2 = Gtk::Box.new(:horizontal)
    @titre = Gtk::Label.new("Bienvenue dans le Tutoriel !")
    @titre.style_context.add_class("titre")
    @titre2 = Gtk::Label.new("Entraine toi et découvre les différents boutons !")
    @titre2.style_context.add_class("titre")


    @paragraphe = Gtk::Label.new("\n\n\nVoici une technique de base. Quand un 3 est dans un coin : \n\n\n")
    @paragraphe2 = Gtk::Label.new("\n\n\nVoici une technique de base. Quand deux 3 sont cotes à cotes : \n\n\n")
    @paragraphe3 = Gtk::Label.new("\n\n\nVoici une technique de base. Lorsque l'on rencontre un 0 : \n\n\n")
    

    p1 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique1.png")
    @iTech1 = Gtk::Image.new(:pixbuf => p1.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p2 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique2.png")
    @iTech2 = Gtk::Image.new(:pixbuf => p2.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p3 = GdkPixbuf::Pixbuf.new(:file => path + "/image/technique3.png")
    @iTech3 = Gtk::Image.new(:pixbuf => p3.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))

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
        changerBox(@vBoxBis2)
        @i += 1
      elsif(@i == 1)
        changerBox(@vBoxBis3)
        @i += 1
      elsif(@i == 2)
        @i +=1
        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grilleTuto")
        grille = @chargeurGrille.getGrilleIndex(0)
        
        jeu = Jeu.charger(grille)
        uiP = PartieUI.creer(@gMenu, self, jeu, grille)
        gMenu.changerMenu(uiP)
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
    @vBox2.add(@vBoxBis1)
    @vBox2.add(@hBox2)
    add(@vBox1)
    pack_end(@vBox2, :expand => true, :fill => true, :padding => 0)
  end

  def changerBox(maBox)
      @vBox2.each { |child|
         @vBox2.remove(child)
      }
      if(@i != 3)
        @vBox2.add(@titre)
      else
        @vBox2.add(@titre2)
      end
      @vBox2.add(maBox)
      if(@i != 3)
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