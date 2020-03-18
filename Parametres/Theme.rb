path = File.expand_path(File.dirname(__FILE__))

require path + "/../Noyau/Constante.rb"

class Theme 

	#@couleur1 : la première couleur du thème
	#@couleur2 : la deuxième couleur du thème
	#@couleur3 : la troisième couleur du thème
	#@debloque : booléen qui vaut vrai si le thème est débloqué, faux sinon
	#@prix : le prix à payer pour débloquer le thème
	
	module Couleur
	
		BLANC = 0
		NOIR = 1
		BLEU = 2
		VERT = 3
		JAUNE = 4
		ROUGE = 5
		
		extend OpConstante
	end
	
	attr_reader :debloque, :prix
	
	# Création du thème
	def Theme.creer(c1, c2, c3, estDebloque, p)
		new(c1, c2, c3, estDebloque, p)
	end
	
	# Initialisation du thème
	def initialize(c1, c2, c3, estDebloque, p)
		@couleur1 = c1
		@couleur2 = c2
		@couleur3 = c3
		@debloque = estDebloque
		@prix = p
	end
	
	# Méthode pour débloquer le thème
	def debloquer()
		@debloque = true
	end
	
	# Méthode qui effectue les actions nécessaires à l'application du thème à l'interface graphique
	def appliqueToi()
		# À faire (IHM)
	end
	
	# Méthode d'affichage
	def to_s() 
		return "Couleur 1 = " + toString(@couleur1) + "\nCouleur 2 = " + toString(@couleur2) + "\nCouleur 3 = " + toString(@couleur3) + "\nDebloque = #{@debloque}\nPrix = #{@prix}"
	end
	
	# Méthode d'affichage de couleur
	def toString(couleur)
	
		case couleur
			when :BLANC
				return "blanc"
			when :NOIR
				return "noir"
			when :BLEU
				return "bleu"
			when :VERT
				return "vert"
			when :JAUNE
				return "jaune"
			when :ROUGE
				return "rouge"
		end
	end
	
end
