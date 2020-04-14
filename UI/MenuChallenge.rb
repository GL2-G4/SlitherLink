require "gtk3"

require_relative './ChallengeManager.rb'
require_relative './Challenge.rb'

class MenuChallenge < Gtk::Box

    private_class_method :new
    attr_reader :challenges

    def MenuChallenge.creer(gMenu, menuPere)
        new(gMenu, menuPere)
    end

    def initialize(gMenu, menuPere)
        super(:horizontal)
        @gMenu = gMenu
        @pere = menuPere
        @vBox = Gtk::Box.new(:vertical)
        @vBox2 = Gtk::ButtonBox.new(:vertical)

        @scrolled = Gtk::ScrolledWindow.new
        @scrolled.set_policy(:never, :automatic)
        @scrolled.set_hexpand(true)
       

        @button1 = Gtk::Button.new(:label => "- Retour -")
        @button1.signal_connect "clicked" do |_widget|
            @gMenu.changerMenu(@pere)
        end

        @titre = Gtk::Label.new("Challenge")
        @titre.style_context.add_class("titre")
        @vBox2.add(@titre)

        path = File.expand_path(File.dirname(__FILE__))

        @challenges = ChallengeManager.charger(path + "/../Grilles/challenges.json")
        #puts @challenges.to_s
        i = 0


        @challenges.challenges["challenges"].each { |c|
            if(i == 0)
                @facile = Gtk::Label.new("FACILE")
                @facile.style_context.add_class("titre")
                @vBox2.add(@facile)
            end
            if(i == 3)
                @moyen = Gtk::Label.new("MOYEN")
                @moyen.style_context.add_class("titre")
                @vBox2.add(@moyen)
            end
            if(i == 7)
                @difficile = Gtk::Label.new("DIFFICILE")
                @difficile.style_context.add_class("titre")
                @vBox2.add(@difficile)
            end
            i += 1
            boxBouton = Gtk::ButtonBox.new(:horizontal)
            boxBouton.set_width_request($longListe)
            border = Gtk::Frame.new()
            boxBouton.set_border_width(10)
            # Titre
            textBox = Gtk::Label.new(c["nom"])
            # Temps
            t = c["m_temps"]
            if(t != 0)
                hour = t/60/60
                min = (t - (hour*60))/60
                sec =  (t - (hour*60) - (min*60))
                #puts "#{hour}:#{min}:#{sec}"
                temps = Gtk::Label.new(sprintf("%02d:%02d",min,sec))
            else
                temps = Gtk::Label.new("--:--")
            end
            # Bouton JOUER
            bouton = Gtk::Button.new()
            bouton.set_label("Jouer")
            bouton.signal_connect "clicked" do |_widget|
                #puts "Jouer au challenge"
                Challenge.new(@gMenu,self,c)
            end
            boxBouton.add(textBox)
            boxBouton.add(temps)
            boxBouton.add(bouton)
            border.add(boxBouton)
            @vBox2.add(border)
        }
        ajouter()
    end

    def ajouter()
        @vBox.add(@button1) 
        add(@vBox)
        @scrolled.add(@vBox2)
        add(@scrolled)
    end
end