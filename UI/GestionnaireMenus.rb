require_relative "Menu.rb"
require_relative "SousMenu.rb"
require "optparse"
require "fileutils"
require_relative "../Parametres/Parametre.rb"
require_relative "../Joueur/Joueur.rb"
require_relative "./ScreenPause.rb"
require_relative "../Noyau/Sauv.rb"
require_relative "./Popup.rb"


require "gtk3"
require "gdk3"

$nbPuzzles = 30
$nbPuzzlesPayants = 5
$paddingBouton = 40
$paddingBox = 30
$longListe = 550
$icone = 15
$imageTuto = 250
$apprOrAdventure = 0

class GestionnaireMenus

    attr :box, true
    attr :window, true
    attr :app, true
    attr :joueur, true
    attr :menu, true
    attr_reader :boutique, :chargeurGrille

    def GestionnaireMenus.creer(window, application)
        new(window, application)
    end
 
    def initialize(window, application)

        at_exit do
            Sauv.enregistrer()
        end

        @window = window
        @app = application
        @box =  Gtk::Box.new(:horizontal)
        @box.set_spacing($paddingBox)
        @window.add(@box)
        @joueur = Joueur.creer()
        @chargeurGrille = ChargeurGrille.charger(File.dirname(__FILE__) + "/../Grilles/grilleAventure")

        @menu = Menu.creer(self)
        @menu.sousMenu = SousMenu.creer(self, @menu)
        @menu.menuRegles = MenuRegles.creer(self,@menu)
        @menu.menuModeDeJeu = MenuModeDeJeu.creer(self, @menu)
        @path = File.expand_path(File.dirname(__FILE__))
        @menu.parametres = ParametresUI.creer(self, @menu, Parametre.charger(@path + "/../Parametres/themes", @path + "/../Parametres/tailles"))
        @boutique = Boutique.charger(@chargeurGrille.listeGrilles, @menu.parametres.param.listeThemes)
        @menu.boutique = MenuBoutique.creer(self, @menu, @boutique)
        @menu.tuto = Tutoriel.creer(self, @menu)
        changerMenu(@menu)

        Sauv.recup( self)
    end

    def changerMenu(menuAff)
        @window.each { |child|
			@window.remove(child)
        }
        @window.add(menuAff)
        @window.show_all
    end

    def changerTaille(t)
        if(t == "1920 x 1080")
            window.set_size_request(1920, 1080)
            $longListe = 1750
            $paddingBox = 240
            $paddingBouton = 250
        elsif (t == "1600 x 900")
            window.set_size_request(1600, 900)
            $longListe = 1430
            $paddingBox = 170
            $paddingBouton = 180
        elsif (t == "1280 x 720")
            window.set_size_request(1280, 720)
            $longListe = 1110
            $paddingBox = 100
            $paddingBouton = 110
        elsif (t == "720 x 480")
            window.set_size_request(720, 480)
            $longListe = 550
            $paddingBox = 30
            $paddingBouton = 40
        end
        @window.show_all
    end

    def changerTheme(t)
        if(t == "Default Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/white.css")
        elsif(t == "Dark Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/dark.css")
        elsif (t == "Red Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/red.css")
        elsif (t == "Space Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/space.css")
        elsif (t == "Happy Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/happy.css")
        elsif (t == "Shrek Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/shrek.css")
        elsif (t == "Licorne Theme")
            provider = Gtk::CssProvider.new
            provider.load(path: @path + "/css/licorne.css")
        end
        Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, provider, Gtk::StyleProvider::PRIORITY_USER)
    end

end

path = File.expand_path(File.dirname(__FILE__))
application = Gtk::Application.new
application.signal_connect(:activate) do
    provider = Gtk::CssProvider.new
    provider.load(path: path + "/css/white.css")

    window = Gtk::ApplicationWindow.new(application)
    gMenu = GestionnaireMenus.new(window, application)
=begin
    f = File.open(path + "/../Joueur/joueurOfficiel", "w")
    Marshal.dump(gMenu.joueur, f)
    f.close()
=end
    f = File.open(path + "/../Joueur/joueurOfficiel", "r")
    gMenu.joueur = Marshal.load(f)
    f.close()

    Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, provider, Gtk::StyleProvider::PRIORITY_USER)
   
    window.set_default_size(1280, 720)
    window.set_size_request(1280, 720) # Ne pas enlever
    window.resizable=(false)
    window.set_border_width(10)
    window.window_position=Gtk::WindowPosition::CENTER
    
    window.signal_connect("delete-event") { |_widget|
        f = File.open(path + "/../Joueur/joueurOfficiel", "w")
        Marshal.dump(gMenu.joueur, f)
        f.close()

        application.quit
    }

    puts gMenu.menu.parametres.param.tailleCourante.to_s
    puts gMenu.menu.parametres.param.themeCourant.to_s
    gMenu.changerTaille(gMenu.menu.parametres.param.tailleCourante.to_s)
    gMenu.changerTheme(gMenu.menu.parametres.param.themeCourant.to_s)
    window.set_position('center_always')
    window.show_all
end
application.run
#Gtk.main
