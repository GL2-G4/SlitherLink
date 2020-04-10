require "gtk3"

class Tutoriel < Gtk::Box

  def Tutoriel.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    @gMenu = gMenu
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere)
    end
    ajouter()
  end

  def ajouter()
    @vBox1.add(@button)
    add(@vBox1)
    add(@vBox2)
  end

  def to_s()
    return "Tutoriel"
  end
end