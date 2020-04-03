path = File.expand_path(File.dirname(__FILE__))

require path + "/../Parametres/Parametre.rb"
require path + "/../Parametres/Theme.rb"
require path + "/../Parametres/Taille.rb"

parametre = Parametre.charger(path + "/../Parametres/themes", path + "/../Parametres/tailles")
parametre.sauvegarder(path + "/../Parametres/themes2", path + "/../Parametres/tailles2")

parametre.appliquerDefaut()

parametre.afficheToi(true)

# Tests
puts "\nJe choisis le thème 1"
parametre.changerTheme(1)
puts "Je choisis la taille 1"
parametre.changerTaille(1)
puts "J'active l'autocomplétion"
parametre.autocompletion = true
parametre.afficheToi(false)

puts "\nJe choisis le thème 2"
parametre.changerTheme(2)
parametre.debloquerTheme(2)
puts "Déblocage du thème 2"
puts "Je choisis le thème 2"
parametre.changerTheme(2)
parametre.afficheToi(false)

puts "\nSauvegarde puis chargement des paramètres."
f = File.open(path + "/../Parametres/parametres", "w")
Marshal.dump(parametre, f)
f.close()

f = File.open(path + "/../Parametres/parametres", "r")
parametre = Marshal.load(f)
parametre.afficheToi(true)


