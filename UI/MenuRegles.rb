load "Regles.rb"
load "Techniques.rb"
require "gtk3"
class MenuRegles

  def MenuRegles.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    @gMenu = gMenu
    @hBox = gMenu.box
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)

    @titre = Gtk::Label.new("Règles et techniques")
    @titre.style_context.add_class("titre")
    @vBox2.add(@titre)

    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere, self)
    end
    @button2 = Gtk::Button.new(:label => 'Règles')
    @button2.signal_connect('clicked') {
        gMenu.changerMenu(Regles.creer(@gMenu,self), self)
    }
    @button3 = Gtk::Button.new(:label => 'Techniques')
    @button3.signal_connect('clicked') {
        gMenu.changerMenu(Techniques.creer(@gMenu,self), self)
    }
end

  def afficheToi()
    @vBox1.add(@button)
    @vBox2.pack_start(@button2, :expand => true, :fill => true, :padding => $paddingBouton)
    @vBox2.pack_start(@button3, :expand => true, :fill => true, :padding => $paddingBouton)
    @hBox.add(@vBox1)
    @hBox.pack_end(@vBox2, :expand => true, :fill => true, :padding => $paddingBox)
  end

  def enleveToi()
    @vBox1.remove(@button)
    @vBox2.remove(@button2)
    @vBox2.remove(@button3)
    @hBox.remove(@vBox1)
    @hBox.remove(@vBox2)
  end

  def to_s()
    return "MenuRegles"
  end
end