
class Taille

	#@longueur : la longueur de l'écran de jeu
	#@largeur : la largeur de l'écran de jeu
	
	# Création du thème
	def Taille.creer(long, larg)
		new(long, larg)
	end
	
	# Initialisation dde la taille
	def initialize(long, larg)
		@longueur = long
		@largeur = larg
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
