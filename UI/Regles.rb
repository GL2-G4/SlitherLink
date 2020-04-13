require "gtk3"

class Regles < Gtk::Box

  def Regles.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    path = File.expand_path(File.dirname(__FILE__))
    @gMenu = gMenu
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @hBox2 = Gtk::Box.new(:horizontal)
    @titre = Gtk::Label.new("Règles")
    @titre.style_context.add_class("titre")
    @paragraphe = Gtk::Label.new("\n\n\nChaque puzzle se compose d'un réseau rectangulaire de points avec quelques indices à divers endroits.\n L'objectif est de relier les points adjacents de la manière suivante:\n\n
    * La valeur de chaque case est égale au nombre de liens qui l'entourent.
    * Les cases vides peuvent être entourées d'un certain nombre de liens (de 0 à 3).
    * Une fois terminée, la solution forme une seule boucle continue sans croisements ni branches.\n
    
    Example : \n\n")

    p1 = GdkPixbuf::Pixbuf.new(:file => path + "/image/regles1.png")
    @iTech1 = Gtk::Image.new(:pixbuf => p1.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    p2 = GdkPixbuf::Pixbuf.new(:file => path + "/image/regles2.png")
    @iTech2 = Gtk::Image.new(:pixbuf => p2.scale_simple($imageTuto, $imageTuto, GdkPixbuf::InterpType::BILINEAR))
    @iTech1.set_margin_right(150)


    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere)
    end
    ajouter()
end

  def ajouter()
    @vBox1.pack_start(Gtk::Alignment.new(0, 0, 1, 1), :expand => false)
    @vBox1.add(@button)
    @vBox2.pack_start(Gtk::Alignment.new(1, 0, 0, 0), :expand => false)
    @vBox2.add(@titre)
    @vBox2.add(@paragraphe)
    @hBox2.add(@iTech1)
    @hBox2.add(@iTech2)
    @hBox2.set_halign(Gtk::Align::CENTER)
    @vBox2.add(@hBox2)
    add(@vBox1)
    pack_end(@vBox2, :expand => true, :fill => true, :padding => 0)
  end

  def to_s()
    return "Regles"
  end
end