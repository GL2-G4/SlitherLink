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
    @vBox3 = Gtk::Box.new(:vertical)
    @scrolled = Gtk::ScrolledWindow.new
    @scrolled.set_policy(:never, :automatic)
    @scrolled.set_hexpand(true)
    @scrolled.set_vexpand(true)
    @scrolled.set_margin_bottom(20)
    @scrolled.set_margin_top(20)

    @titre = Gtk::Label.new("Techniques")
    @titre.style_context.add_class("titre")

    @paragraphe = Gtk::Label.new("Voci une liste de quelques techniques.
Cette liste est non exhaustive, cherchez par vous-même pour en trouver d'avantage !")

    @path = File.expand_path(File.dirname(__FILE__))
      
    p00 = ImageManager.getImageFromFile(@path+"/image/1254.gif",200,200)
    p01 = ImageManager.getImageFromFile(@path+"/image/1255.gif",200,200)
    p10 = ImageManager.getImageFromFile(@path+"/image/1256.gif",200,200)
    p11 = ImageManager.getImageFromFile(@path+"/image/1257.gif",200,200)
    p20 = ImageManager.getImageFromFile(@path+"/image/1258.gif",200,200)
    p21 = ImageManager.getImageFromFile(@path+"/image/1259.gif",200,200)
    p30 = ImageManager.getImageFromFile(@path+"/image/1254.gif",200,200)
    p31 = ImageManager.getImageFromFile(@path+"/image/1255.gif",200,200)
    p40 = ImageManager.getImageFromFile(@path+"/image/1256.gif",200,200)
    p11 = ImageManager.getImageFromFile(@path+"/image/1257.gif",200,200)
    p40 = ImageManager.getImageFromFile(@path+"/image/1258.gif",200,200)
    p41 = ImageManager.getImageFromFile(@path+"/image/1259.gif",200,200)
    p50 = ImageManager.getImageFromFile(@path+"/image/1254.gif",200,200)
    p51 = ImageManager.getImageFromFile(@path+"/image/1255.gif",200,200)
    p60 = ImageManager.getImageFromFile(@path+"/image/1256.gif",200,200)
    p61 = ImageManager.getImageFromFile(@path+"/image/1257.gif",200,200)
    p70 = ImageManager.getImageFromFile(@path+"/image/1258.gif",200,200)
    p71 = ImageManager.getImageFromFile(@path+"/image/1259.gif",200,200)

    boxTechniques(p00, p01)
    boxTechniques(p10, p11)
    boxTechniques(p20, p21)
    boxTechniques(p30, p31)
    boxTechniques(p40, p41)
    boxTechniques(p50, p51)
    boxTechniques(p60, p61)
    boxTechniques(p70, p71)

    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
      gMenu.changerMenu(@pere)
    end
    ajouter()
end

  def ajouter()
    @vBox1.pack_start(Gtk::Alignment.new(0, 0, 1, 1), :expand => false)
    @vBox1.add(@button)
    add(@vBox1)
    @vBox3.add(@titre)
    @vBox3.add(@paragraphe)
    @vBox3.set_halign(Gtk::Align::CENTER)
    @scrolled.add(@vBox2)
    @scrolled.set_halign(Gtk::Align::CENTER)
    @vBox3.add(@scrolled)
    pack_end(@vBox3, :expand => true, :fill => true, :padding => 100)
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