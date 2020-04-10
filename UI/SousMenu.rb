require "gtk3"
class SousMenu

  def SousMenu.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    @gMenu = gMenu
    @box = gMenu.box
    @pere = menuPere
    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere, self)
    end
  end

  def afficheToi()
    @box.add(@button)
  end

  def enleveToi()
    @box.remove(@button)
  end

  def to_s()
    return "je suis le second menu et j'existe"
  end
end