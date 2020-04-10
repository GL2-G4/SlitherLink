require "gtk3"
class Tutoriel

  def Tutoriel.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    @gMenu = gMenu
    @hBox = gMenu.box
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere, self)
    end
  end

  def afficheToi()
    @vBox1.add(@button)
    @hBox.add(@vBox1)
    @hBox.add(@vBox2)
  end

  def enleveToi()
    @hBox.remove(@vBox1)
    @hBox.remove(@vBox2)
  end

  def to_s()
    return "Tutoriel"
  end
end