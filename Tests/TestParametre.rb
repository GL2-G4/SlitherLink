path = File.expand_path(File.dirname(__FILE__))

require path + "/../Parametres/Parametre.rb"
require path + "/../Parametres/Theme.rb"
require path + "/../Parametres/Taille.rb"

# Création de thèmes et de tailles
theme0 = Theme.creer(:NOIR, :BLANC, :NOIR, true, 0)
theme1 = Theme.creer(:ROUGE, :VERT, :BLEU, true, 0)
theme2 = Theme.creer(:BLEU, :BLANC, :ROUGE, false, 1000)
taille0 = Taille.creer(600, 800)
taille1 = Taille.creer(900, 1200)

# Ajout à la liste des paramètres
parametre = Parametre.charger()
parametre.ajouterTheme(theme0)
parametre.ajouterTheme(theme1)
parametre.ajouterTheme(theme2)
parametre.ajouterTaille(taille0)
parametre.ajouterTaille(taille1)

parametre.appliquerDefaut()

parametre.afficheToi(true)

# Tests
puts "Je choisis le thème 1"
parametre.changerTheme(1)
puts "Je choisis la taille 1"
parametre.changerTaille(1)
puts "J'active l'autocomplétion"
parametre.autocompletion = true
parametre.afficheToi(false)

puts "Je choisis le thème 2"
parametre.changerTheme(2)
parametre.debloquerTheme(2)
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


