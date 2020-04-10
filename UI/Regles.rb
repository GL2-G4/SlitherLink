require "gtk3"

class Regles < Gtk::Box

  def Regles.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    @gMenu = gMenu
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @hBox2 = Gtk::Box.new(:horizontal)
    @titre = Gtk::Label.new("Each puzzle consists of a rectangular lattice of dots with some clues in various places.
      The object is to link adjacent dots so:\n
      \t*The value of each clue equals the number of links surrounding it.
      \t*Empty squares may be surrounded by any number of links.
      \t*When completed, the solution forms a single continuous loop with no crossings or branches.")
    #@image1 = Gtk::Image.new("regles1.jpg")
    @image2 = Gtk::Image.new :file => "regles2.jpg", :size => :dialog
    @image1 = Gtk::Image.new :file => "regles1.jpg"
    @image1.set_padding(10, 10)
    @image2.set_padding(10, 10)
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
    @image1.halign = :center
    @image1.valign = :center
    @image2.halign = :center
    @image2.valign = :center
    @hBox2.add(@image1)
    @hBox2.add(@image2)
    @vBox2.add(@hBox2)
    add(@vBox1)
    add(@vBox2)
  end

  def to_s()
    return "Regles"
  end
end

#http://pochopoch.blogspot.com/2013/04/layout-management-in-ruby-gtk.html