require "gtk3"

class SousMenu < Gtk::Box

  def SousMenu.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    @gMenu = gMenu
    @pere = menuPere
    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere)
    end
    ajouter()
  end

  def ajouter()
    add(@button)
  end

  def to_s()
    return "je suis le second menu et j'existe"
  end
end