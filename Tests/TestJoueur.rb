path = File.expand_path(File.dirname(__FILE__))

require path + "/../Joueur/Joueur.rb"
require path + "/../Noyau/LoadSaveGrilles/ChargeurGrille"

chargeurGrille = ChargeurGrille.charger(path + "/../Grilles/grille")

j = Joueur.creer()
puts j
puts "\nLe joueur a gagné 1500 pièces d'or."
j.ajouterArgent(1500)
puts j
puts "\nLe joueur a dépensé 1000 pièces d'or."
j.retirerArgent(1000)
puts j
puts "\nLe joueur a dépensé 1000 pièces d'or."
j.retirerArgent(1000)
puts j
#j.retirerArgent(-1000)
#j.ajouterArgent(-50)
puts "\nLe joueur a gagné une étoile."
j.ajouterEtoiles(1)
#j.ajouterEtoiles(4)
#j.ajouterEtoiles(0)
puts j

puts "\nLe joueur peut accéder à la première grille (3* 1000$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(0)).to_s
puts "Le joueur peut accéder à la deuxième grille (1* 0$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(1)).to_s

puts "\nDéblocage des grilles ..."
chargeurGrille.debloquerGrilles(j.etoiles)

puts "\nLe joueur peut accéder à la première grille (3* 1000$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(0)).to_s
puts "Le joueur peut accéder à la deuxième grille (1* 0$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(1)).to_s

puts "\nLe joueur veut acheter la première grille."
j.acheterGrille(chargeurGrille.getGrilleIndex(0))

puts "\nLe joueur a gagné 2 étoiles."
j.ajouterEtoiles(2)
puts j

puts "\nLe joueur veut acheter la première grille."
j.acheterGrille(chargeurGrille.getGrilleIndex(0))

puts "\nLe joueur a gagné 1000 pièces d'or."
j.ajouterArgent(1000)
puts j

puts "\nLe joueur veut acheter la première grille."
j.acheterGrille(chargeurGrille.getGrilleIndex(0))

puts "\nLe joueur peut accéder à la première grille (3* 1000$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(0)).to_s
puts "Le joueur peut accéder à la deuxième grille (1* 0$) : " + j.grilleDebloquee?(chargeurGrille.getGrilleIndex(1)).to_s

puts "\nSauvegarde puis chargement du joueur."
f = File.open(path + "/../Joueur/joueur", "w")
Marshal.dump(j, f)
f.close()

f = File.open(path + "/../Joueur/joueur", "r")
j = Marshal.load(f)
puts j

chargeurGrille.sauvegarder(path + "/../Grilles/grille2")
