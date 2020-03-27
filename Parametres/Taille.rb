
class Taille

	#@longueur : la longueur de l'écran de jeu
	#@largeur : la largeur de l'écran de jeu
	
	# Création de la taille
	def Taille.charger(contenuFichier)
		new(contenuFichier)
	end
	
	# Constructeur d'une taille chargé à partir d'un fichier.
	def initialize(contenuFichier)
	
		self.charger(contenuFichier)
	end
	
	# Méthode gérant le chargement des différentes informations concernant la taille
	def charger(contenuFichier)
		
		# Séparation des différentes informations du fichier (séparateur ";")
		contenu = contenuFichier.split(";")
		
		# Chargement de la longueur et de la largeur
		@longueur = contenu[0].to_i
		@largeur = contenu[1].to_i
	end
	
	# Méthode transformant une taille en une ligne de fichier.
	# Retourne la ligne de fichier ainsi créée.
	def toLigneFichier()
	
		# La ligne de fichier correspondant à la taille
		contenuFichier = ""
		
		# Ajout des autres champs de la taille
		contenuFichier += @longueur.to_s
		contenuFichier += ";" + @largeur.to_s
		contenuFichier += "\n"
		
		# Retour de la ligne de fichier
		return contenuFichier			
	end
	
	# Méthode qui effectue les actions nécessaires à l'application de la taille à l'interface graphique
	def appliqueToi()
		# À faire (IHM)
	end
	
	# Méthode d'affichage
	def to_s()
		return "Longueur = #{@longueur}\nLargeur = #{@largeur}"
	end
end
