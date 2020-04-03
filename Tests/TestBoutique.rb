path = File.expand_path(File.dirname(__FILE__))

require path + "/../Joueur/Joueur.rb"
require path + "/../Boutique/Boutique.rb"
require path + "/../Noyau/LoadSaveGrilles/ChargeurGrille.rb"
require path + "/../Parametres/Parametre.rb"

chargeurGrille = ChargeurGrille.charger(path + "/../Grilles/grille")
parametre = Parametre.charger(path + "/../Parametres/themes", path + "/../Parametres/tailles")

j = Joueur.creer()
j.ajouterArgent(500)
j.ajouterEtoiles(1)
puts j

b = Boutique.charger(j)

# Ajout de toutes les grilles ayant un prix dans la boutique
chargeurGrille.listeGrilles.each do |grille|
	if grille.prixPieces > 0
		b.ajouterGrille(grille)
	end
end

# Ajout de tous les thèmes ayant un prix dans la boutique
parametre.listeThemes.each do |theme|
	if theme.prix > 0
		b.ajouterTheme(theme)
	end
end
	
b.afficheToi()

puts "\n--------------------\nLe joueur achète la grille n°0"
b.acheterGrille(0)

puts "\nLe joueur a gagné 2 étoiles."
j.ajouterEtoiles(2)
puts j

puts "\n--------------------\nLe joueur achète la grille n°0"
b.acheterGrille(0)

puts "\nLe joueur a gagné 1000 pièces d'or."
j.ajouterArgent(1000)
puts j

puts "\n--------------------\nLe joueur achète la grille n°0"
b.acheterGrille(0)

puts "\nLe joueur a gagné 1000 pièces d'or."
j.ajouterArgent(1000)
puts j

puts "\n--------------------\nLe joueur achète le thème n°0"
b.acheterTheme(0)
b.afficheToi()

puts "\nSauvegarde puis chargement de la boutique."
f = File.open(path + "/../Boutique/boutique", "w")
Marshal.dump(b, f)
f.close()

f = File.open(path + "/../Boutique/boutique", "r")
b = Marshal.load(f)
b.afficheToi()

chargeurGrille.sauvegarder(path + "/../Grilles/grille2")
parametre.sauvegarder(path + "/../Parametres/themes2", path + "/../Parametres/tailles2")
