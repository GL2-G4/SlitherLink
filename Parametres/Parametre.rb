path = File.expand_path(File.dirname(__FILE__))

require path + "/Theme.rb"
require path + "/Taille.rb"

class Parametre

	#@listeThemes : la liste des thèmes du jeu
	#@themeCourant : le thème choisi par le joueur
	#@listeTailles : contient la liste des tailles disponibles
	#@tailleCourante : la taille choisie par le joueur
	#@autocompletion : booléen qui vaut vrai si l’autocomplétion est activée
	
	attr_reader :listeThemes, :listeTailles
	attr_accessor :autocompletion
	
	# Méthode de création des paramètres
	def Parametre.charger(nomFichier1, nomFichier2)
		new(nomFichier1, nomFichier2)
	end
	
	# Méthode d'initialisation des paramètres
	def initialize(nomFichier1, nomFichier2)
	
		@themeCourant = nil
		@tailleCourante = nil
		@autocompletion = false
		
		# Ouverture des fichiers
		fichierTheme = File.open(nomFichier1, "r")
		fichierTaille = File.open(nomFichier2, "r")
		
		# Lecture de chacune des lignes du fichier de thèmes
		lignes = fichierTheme.readlines()
		
		# Création des thèmes en fonction des lignes lues
		@listeThemes = Array.new()
		lignes.each do |l|
			if (l.size >= 18)
				@listeThemes.push(Theme.charger(l))
			end
		end
		
		# Fermeture du fichier de thèmes
		fichierTheme.close()
		
		# Lecture de chacune des lignes du fichier de tailles
		lignes = fichierTaille.readlines()
		
		# Création des tailles en fonction des lignes lues
		@listeTailles = Array.new()
		lignes.each do |l|
			if (l.size >= 7)
				@listeTailles.push(Taille.charger(l))
			end
		end
		
		# Fermeture du fichier de tailles
		fichierTaille.close()
	end
	
	# Sauvegarde chacun des tailles et des thèmes de la liste de tailles et de thèmes dans les fichiers correspondants
	def sauvegarder(nomFichier1, nomFichier2)
	
		# Ouverture du fichier de thèmes
		fichierTheme = File.open(nomFichier1, "w")
		
		# Traduction de chacun des thèmes de la liste des thèmes en ligne de fichier
		ligne = ""
		@listeThemes.each do |theme|
			ligne = theme.toLigneFichier()
			fichierTheme.write(ligne)
		end
		
		# Fermeture du fichier de thèmes
		fichierTheme.close()
		
		# Ouverture du fichier de tailles
		fichierTaille = File.open(nomFichier2, "w")
		
		# Traduction de chacune des tailles de la liste des tailles en ligne de fichier
		ligne = ""
		@listeTailles.each do |taille|
			ligne = taille.toLigneFichier()
			fichierTaille.write(ligne)
		end
		
		# Fermeture du fichier de tailles
		fichierTaille.close()
	end
	
	# Méthode pour ajouter un thème à la liste de thèmes
	def ajouterTheme(theme)
		@listeThemes.push(theme)
	end
	
	# Méthode pour ajouter une taille à la liste de tailles
	def ajouterTaille(taille)
		@listeTailles.push(taille)
	end
	
	# Méthode qui change le thème choisi par le joueur
	def changerTheme(numeroTheme)
	
		if @listeThemes[numeroTheme].debloque
			@themeCourant = @listeThemes[numeroTheme]
		else
			puts "Le thème est bloqué."
		end
	end
	
	# Méthode qui change la taille choisie par le joueur
	def changerTaille(numeroTaille)
		@tailleCourante = @listeTailles[numeroTaille]
	end
	
	# Méthode pour débloquer un thème
	def debloquerTheme(numeroTheme)
		@listeThemes[numeroTheme].debloquer()
	end
	
	# Rétablit les paramètres par défaut
	def appliquerDefaut()
		@themeCourant = @listeThemes[0]
		@tailleCourante = @listeTailles[0]
		@autocompletion = false
	end
	
	# Méthode qui affiche la liste des paramètres
	# Les paramètres non débloqués doivent apparaître différemment (grisés) et si le joueur les sélectionne, un message indiquant que le paramètre doit être débloqué doit s’afficher.
	def afficheToi(enEntier)
		# À coder (IHM)
		
		# Version console
		puts "\nParamètres : "
		puts 
		numero = 0
		
		if enEntier
		
			puts "--------------------\nThèmes\n--------------------\n"
			@listeThemes.each do |theme|
				puts "Thème n°#{numero}"
				puts theme
				puts
				numero += 1
			end
			
			numero = 0
			
			puts "--------------------\nTailles\n--------------------\n"
			@listeTailles.each do |taille|
				puts "Taille n°#{numero}"
				puts taille
				puts
				numero += 1
			end
		end
		
		puts "--------------------\nThème choisi :\n--------------------\n"
		puts @themeCourant
		
		puts "--------------------\nTaille choisie :\n--------------------\n"
		puts @tailleCourante
		
		puts "--------------------\nAutocomplétion : #{@autocompletion}\n--------------------\n"
	end
	
	
	# Getter sur la liste des thèmes (avec contrôles supplémentaires)
	def getThemeIndex(index)
	
		if index < 0
			raise ArgumentError, "Index négatif : #{index}"
		elsif index >= @listeThemes.size
			raise ArgumentError, "Index trop grand : #{index} (index maximum #{@listeThemes.size - 1})"
		else
			return @listeThemes[index]
		end
	end
	
	# Getter sur la liste des tailes (avec contrôles supplémentaires)
	def getTailleIndex(index)
	
		if index < 0
			raise ArgumentError, "Index négatif : #{index}"
		elsif index >= @listeTailles.size
			raise ArgumentError, "Index trop grand : #{index} (index maximum #{@listeThemes.size - 1})"
		else
			return @listeTailles[index]
		end
	end
	
end
