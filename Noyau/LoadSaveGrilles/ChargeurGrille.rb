path = File.expand_path(File.dirname(__FILE__))

require path + "/Grille"

# Classe possédant des méthodes permettant de charger et de sauvegarder des grilles.
# Contient la liste des grilles chargées à partir d'un fichier.
class ChargeurGrille
	attr_reader :pwd_fichier
	#@listeGrilles : la liste des grilles chargées à partir du fichier
	
	# Méthode de création d'un chargeur de grille
	def ChargeurGrille.charger(nomFichier)
		new(nomFichier)
	end
	
	attr_reader :listeGrilles
	
	# Méthode d'initialisation qui transforme chacune des lignes du fichier de grilles en une grille et l'ajoute à la liste des grilles
	def initialize(nomFichier)
		@pwd_fichier = nomFichier
		# Ouverture du fichier
		fichier = File.open(nomFichier, "r")
		
		# Lecture de chacune des lignes du fichier
		lignes = fichier.readlines()
		
		# Création des grilles en fonction des lignes lues
		@listeGrilles = Array.new()
		lignes.each do |l|
			if (l.size >= 33)
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
	
	# Méthode qui débloque les grilles dont le nombre d'étoiles passé en paramètres est supérieur ou égal au nombre d'étoiles pour débloquer ces grilles
	def debloquerGrilles(nombreEtoiles)
	
		@listeGrilles.each do |grille|
			if !grille.debloque && grille.prixEtoiles <= nombreEtoiles && grille.prixPieces == 0
				grille.debloquer()
			end
		end
	end
	
	# Méthode d'affichage de la liste de grilles (pour le débugage)
	def afficherGrilles
		@listeGrilles.each do |grille|
			grille.afficher
		end
	end
	
	# Getter sur la liste des grilles (avec contrôles supplémentaires)
	def getGrilleIndex(index)
	
		if index < 0
			raise ArgumentError, "Index négatif : #{index}"
		elsif index >= @listeGrilles.size
			raise ArgumentError, "Index trop grand : #{index} (index maximum #{@listeGrilles.size - 1})"
		else
			return @listeGrilles[index]
		end
	end
end

CG = ChargeurGrille
