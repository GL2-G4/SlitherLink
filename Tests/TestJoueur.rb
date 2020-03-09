path = File.expand_path(File.dirname(__FILE__))

require path + "/../Joueur/Joueur.rb"

j = Joueur.creer()
puts j
j.ajouterArgent(1500)
j.retirerArgent(1000)
j.retirerArgent(1000)
#j.retirerArgent(-1000)
#j.ajouterArgent(-50)
j.ajouterEtoiles(1)
#j.ajouterEtoiles(4)
#j.ajouterEtoiles(0)
puts j

f = File.open(path + "/../Joueur/joueur", "w")
Marshal.dump(j, f)
f.close()

f = File.open(path + "/../Joueur/joueur", "r")
j = Marshal.load(f)
puts j
