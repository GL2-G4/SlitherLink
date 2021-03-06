
class Joueur

	#@argent : l'argent dont dispose le joueur
	#@etoiles : le nombre d'étoiles dont dispose le joueur

	# Création du joueur
	def Joueur.creer()
		new()
	end
	
	# Accès en lecture aux variables argent, etoiles
	attr_reader :argent, :etoiles
	
	# Constructeur d'un joueur
	def initialize()
	
		@argent = 100000
		@etoiles = 0
	end
	
	# Méthode ajoutant une somme d'argent au joueur
	def ajouterArgent(somme) 
	
		if somme >= 0
			@argent += somme
		else
			raise ArgumentError, "Erreur : somme négative"
		end
	end
	
	# Méthode retirant une somme d'argent au joueur
	def retirerArgent(somme) 
	
		if somme <= @argent and somme >= 0
			@argent -= somme
			return true
		elsif somme < 0
			raise ArgumentError, "Erreur : somme négative"
		else 
			puts "Pas assez d'argent."
		end
		
		return false
	end
	
	# Méthode permettant d'ajouter un certain nombre d'étoiles au joueur
	def ajouterEtoiles(nombreEtoiles)
	
		if nombreEtoiles > 0 and nombreEtoiles <= 3
			@etoiles += nombreEtoiles
		elsif nombreEtoiles <= 0
			raise ArgumentError, "Erreur : nombre négatif ou nul d'étoiles"
		else
			raise ArgumentError, "Erreur : nombre d'étoiles supérieur à 3"
		end		
	end
	
	# Méthode vérifiant que le joueur peut jouer à la grille
	def grilleDebloquee?(grille)
		return grille.debloque
	end
	
	# Méthode vérifiant que le joueur a assez d'étoiles pour débloquer la grille
	def aAssezDEtoiles(grille)
		return @etoiles >= grille.prixEtoiles
	end
	
	# Méthode gérant l'achat d'une grille par le joueur
	def acheterGrille(grille)
		
		if !self.aAssezDEtoiles(grille)
			puts "Pour acheter cette grille, vous devez avoir au moins #{grille.prixEtoiles} étoiles, vous n'en avez que #{@etoiles}."
		elsif self.retirerArgent(grille.prixPieces)
			puts "Grille achetée avec succès !"
			grille.debloquer()
		else
			p = Popup.new()
			p.set_titre(titre:"Vous ne pouvez pas débloquer ce puzzle. Vérifiez que vous avez assez d'argent.") 
			p.addBouton(titre:"Quitter"){ p.stop }
			p.run()
			puts "La grille n'a pas pu être débloquée."
		end
	end
	
	# Méthode gérant l'achat d'un thème par le joueur
	def acheterTheme(theme)
		
		if self.retirerArgent(theme.prix)
			puts "Thème acheté avec succès !"
			theme.debloquer()
		else
			p = Popup.new()
			p.set_titre(titre:"Vous ne pouvez pas débloquer ce theme. Vérifiez que vous avez assez d'argent.") 
			p.addBouton(titre:"Quitter"){ p.stop }
			p.run()
			puts "Le thème n'a pas pu être débloqué."
		end
	end
	
	# Méthode d'affichage d'un joueur
	def to_s
		return "Joueur : \nArgent = #{@argent}$\n" + "Etoiles = #{@etoiles}*\n" 
	end

end
