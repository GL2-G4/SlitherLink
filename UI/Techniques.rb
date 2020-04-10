require "gtk3"
class Techniques

  def Techniques.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    @gMenu = gMenu
    @hBox = gMenu.box
    @pere = menuPere
    @vBox1 = Gtk::Box.new(:vertical)
    @vBox2 = Gtk::Box.new(:vertical)
    temp = Gtk::TextBuffer.new()
    temp.set_text(
        "Quelques techniques afin d'etoffer votre stratégie !
        
        
                                        Mettre des images :

                             Situation non resolue       ->       Resolue                            
                             Situation non resolue       ->       Resolue
                             Situation non resolue       ->       Resolue
                             Situation non resolue       ->       Resolue
        
        "
        )
    @text = Gtk::TextView.new(temp)
    @text.editable=(false)
    @button = Gtk::Button.new(:label => "- Retour -")
    @button.signal_connect "clicked" do |_widget|
    gMenu.changerMenu(@pere, self)
    end
end

  def afficheToi()
    @vBox1.add(@button)
    @vBox2.add(@text)
    @hBox.add(@vBox1)
    @hBox.add(@vBox2)
  end

  def enleveToi()
    @hBox.remove(@vBox1)
    @hBox.remove(@vBox2)
  end

  def to_s()
    return "Techniques"
  end
end