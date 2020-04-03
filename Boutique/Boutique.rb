
class Boutique

	# @listeThemes : la liste des thèmes disponibles à la boutique
	# @listeGrilles : la liste des grilles déverrouillables à la boutique
	# @joueur : le joueur qui a accès à la boutique
	
	# Méthode de création
	def Boutique.charger(joueur)
		new(joueur)
	end
	
	# Méthode d'initialisation de la boutique
	def initialize(joueur)
		@joueur = joueur
		@listeGrilles = Array.new()
		@listeThemes = Array.new()
	end
	
	# Méthode pour ajouter une grille à la liste de grilles
	def ajouterGrille(grille)
		@listeGrilles.push(grille)
	end
	
	# Méthode pour ajouter un thème à la liste de thèmes
	def ajouterTheme(theme)
		@listeThemes.push(theme)
	end
	
	# Méthode pour faire acheter une grille au joueur
	def acheterGrille(numeroGrille)
	
		if numeroGrille < 0 
			raise ArgumentError, "Numéro de grille négatif."
		elsif numeroGrille >= @listeGrilles.size
			raise ArgumentError, "Numéro de grille trop grand."	
		else
			@joueur.acheterGrille(@listeGrilles[numeroGrille])
		end
	end
	
	# Méthode pour faire acheter une grille au joueur
	def acheterTheme(numeroTheme)
	
		if numeroTheme < 0 
			raise ArgumentError, "Numéro de thème négatif."
		elsif numeroTheme >= @listeThemes.size
			raise ArgumentError, "Numéro de thème trop grand."	
		else
			@joueur.acheterTheme(@listeThemes[numeroTheme])
		end
	end
	
	# Méthode qui affiche la boutique (à remplacer par une version IHM)
	def afficheToi() 
		
		numero = 0
		
		puts "\nBoutique : "
		
		# Affichage des informations utiles pour les grilles
		puts "\n--------------------\nGrilles\n--------------------\n"
		@listeGrilles.each do |grille|
			puts "Grille n°#{numero}"
			puts "Prix = #{grille.prixPieces}$"
			puts "Débloqué = #{grille.debloque}"
			numero += 1
		end
		
		numero = 0
		
		# Affichage des thèmes
		puts "\n--------------------\nThèmes\n--------------------\n"
		@listeThemes.each do |theme|
			puts "Thème n°#{numero}"
			theme.afficher()
			numero += 1
		end
	end
end
