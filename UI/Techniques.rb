require "gtk3"

class Techniques < Gtk::Box

  def Techniques.creer(gMenu, menuPere)
    new(gMenu, menuPere)
  end

  def initialize(gMenu, menuPere)
    super(:horizontal)
    @gMenu = gMenu
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
      gMenu.changerMenu(@pere)
    end
    ajouter()
end

  def ajouter()
    @vBox1.add(@button)
    @vBox2.add(@text)
    add(@vBox1)
    add(@vBox2)
  end

  def to_s()
    return "Techniques"
  end
end