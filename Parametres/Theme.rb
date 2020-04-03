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
	def Theme.charger(contenuFichier)
		new(contenuFichier)
	end
	
	# Constructeur d'un thème chargé à partir d'un fichier.
	def initialize(contenuFichier)
	
		self.charger(contenuFichier)
	end
	
	# Méthode gérant le chargement des différentes informations concernant le thème
	def charger(contenuFichier)
		
		# Séparation des différentes informations du fichier (séparateur ";")
		contenu = contenuFichier.split(";")
		
		# Chargement des 3 couleurs, du booléen debloque et du prix
		@couleur1 = self.toCouleur(contenu[0])
		@couleur2 = self.toCouleur(contenu[1])
		@couleur3 = self.toCouleur(contenu[2])
		@debloque = self.toBooleen(contenu[3].chomp)
		@prix = contenu[4].to_i
	end
	
	# Méthode transformant un thème en une ligne de fichier.
	# Retourne la ligne de fichier ainsi créée.
	def toLigneFichier()
	
		# La ligne de fichier correspondant au thème
		contenuFichier = ""
		
		# Ajout des autres champs du thème
		contenuFichier += self.toString(@couleur1)
		contenuFichier += ";" + self.toString(@couleur2)
		contenuFichier += ";" + self.toString(@couleur3)
		contenuFichier += ";" + self.toCaractereBooleen(@debloque)
		contenuFichier += ";" + @prix.to_s
		contenuFichier += "\n"
		
		# Retour de la ligne de fichier
		return contenuFichier			
	end
	
	# Méthode pour débloquer le thème
	def debloquer()
		@debloque = true
	end
	
	# Méthode qui effectue les actions nécessaires à l'application du thème à l'interface graphique
	def appliqueToi()
		# À faire (IHM)
	end
	
	# Méthode d'affichage par la boutique
	def afficher()
		puts self.to_s()
	end
	
	# Méthode d'affichage
	def to_s() 
		return "Couleur 1 = " + toString(@couleur1) + "\nCouleur 2 = " + toString(@couleur2) + "\nCouleur 3 = " + toString(@couleur3) + "\nDébloqué = #{@debloque}\nPrix = #{@prix}$"
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
	
	# Méthode dde transformation de chaîne de caractère en couleur
	def toCouleur(string)
	
		case string
			when "blanc"
				return :BLANC
			when "noir"
				return :NOIR
			when "bleu"
				return :BLEU
			when "vert"
				return :VERT
			when "jaune"
				return :JAUNE
			when "rouge"
				return :ROUGE
		end
	end
	
	# Méthode transformant le caractère reçu du fichier en booléen
	def toBooleen(caractere)
	
		case caractere
			when "V"
				return true
			when "F"
				return false
			else
				raise ArgumentError, caractere + " n'est pas un caractère valide (V ou F)"
			end
	end
	
	# Méthode transformant le booléen en caractère pour être inséré dans le fichier
	def toCaractereBooleen(booleen)
	
		case booleen
			when true
				return "V"
			when false
				return "F"
			end
	end	
end
