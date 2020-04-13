require "gtk3"
require_relative "./ImageManager.rb"

class Techniques < Gtk::Box

  def Techniques.creer(gMenu, menupere)
    new(gMenu, menupere)
  end

  def initialize(gMenu, menupere)
    super(:horizontal)
    @gMenu = gMenu
    @pere = menupere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    @scrolled = Gtk::ScrolledWindow.new
    @scrolled.set_policy(:never, :automatic)
    @path = File.expand_path(File.dirname(__FILE__))
      
    p00 = ImageManager.getImageFromFile(@path+"/image/1254.gif",200,200)
    p01 = ImageManager.getImageFromFile(@path+"/image/1255.gif",200,200)
    p10 = ImageManager.getImageFromFile(@path+"/image/1256.gif",200,200)
    p11 = ImageManager.getImageFromFile(@path+"/image/1257.gif",200,200)
    p20 = ImageManager.getImageFromFile(@path+"/image/1258.gif",200,200)
    p21 = ImageManager.getImageFromFile(@path+"/image/1259.gif",200,200)
    
    boxTechniques(p00, p01)
    boxTechniques(p10, p11)
    boxTechniques(p20, p21)

    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere)
    end
    ajouter()
end

  def ajouter()
    @vBox1.add(@button)
    add(@vBox1)
    #add(@vBox2)
    @scrolled.add(@vBox2)
    add(@scrolled)
  end

  def boxTechniques(i1, i2)
    box = Gtk::Box.new(:horizontal)
    i1.set_halign(Gtk::Align::START)
    i2.set_halign(Gtk::Align::END)
    i1.set_margin_right(50)
    i2.set_margin_left(50)
    img = ImageManager.getImageFromFile(@path+"/image/fleche.png",32,20)
    img.set_halign(Gtk::Align::CENTER)
    box.set_margin(20)
    box.add(i1)
    box.add(img)
    box.add(i2)
    @vBox2.add(box)
  end

  def to_s()
    return "Techniques"
  end
end