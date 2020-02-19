path = File.expand_path(File.dirname(__FILE__))

require path + "/Grille"

# Classe possédant des méthodes permettant de charger et de sauvegarder des grilles.
# Contient la liste des grilles chargées à partir d'un fichier.
class ChargeurGrille

	#@listeGrilles : la liste des grilles chargées à partir du fichier
	
	# Méthode de création d'un chargeur de grille
	def ChargeurGrille.charger(nomFichier)
		new(nomFichier)
	end
	
	# Méthode d'initialisation qui transforme chacune des lignes du fichier de grilles en une grille et l'ajoute à la liste des grilles
	def initialize(nomFichier)
	
		# Ouverture du fichier
		fichier = File.open(nomFichier, "r")
		
		# Lecture de chacune des lignes du fichier
		lignes = fichier.readlines()
		
		# Création des grilles en fonction des lignes lues
		@listeGrilles = Array.new()
		lignes.each do |l|
			if(l.size >= 33)
				@listeGrilles.push(Grille.charger(l))
			end
		end
		
		# Fermeture du fichier
		fichier.close()
		
		#self.afficherGrilles
	end
	
	# Sauvegarde chacune des grilles de la liste de grilles dans le fichier
	def sauvegarder(nomFichier)
	
		# Ouverture du fichier
		fichier = File.open(nomFichier, "w")
		
		# Traduction de chacune des grilles de la liste des grilles en ligne de fichier
		ligne = ""
		@listeGrilles.each do |grille|
			ligne = grille.toLigneFichier()
			fichier.write(ligne)
		end
		
		# Fermeture du fichier
		fichier.close()
	end
	
	# Méthode d'affichage de la liste de grilles (pour le débugage)
	def afficherGrilles
		@listeGrilles.each do |grille|
			grille.afficher
		end
	end
	
	def getGrilleIndex(index)
		if(index < 0 || index >= @listeGrilles.size)
			raise ArgumentError, "Index invalide !"
		end
		return @listeGrilles[index]
	end
	

end

CG = ChargeurGrille
