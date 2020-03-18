
class Parametre

	#@listeThemes : la liste des thèmes du jeu
	#@themeCourant : le thème choisi par le joueur
	#@listeTailles : contient la liste des tailles disponibles
	#@tailleCourante : la taille choisie par le joueur
	#@autocompletion : booléen qui vaut vrai si l’autocomplétion est activée
	
	attr_accessor :autocompletion
	
	# Méthode de création des paramètres
	def Parametre.charger()
		new()
	end
	
	# Méthode d'initialisation des paramètres
	def initialize()
	
		@listeThemes = Array.new()
		@listeTailles = Array.new()
		@themeCourant = nil
		@tailleCourante = nil
		@autocompletion = false
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
		puts "Paramètres : "
		puts
		
		if enEntier
			@listeThemes.each do |theme|
				puts theme
				puts
			end
			
			@listeTailles.each do |taille|
				puts taille
				puts
			end
		end
		
		puts "\nThème choisi : "
		puts @themeCourant
		
		puts "\nTaille choisie : "
		puts @tailleCourante
		
		puts "\nAutocomplétion : #{@autocompletion}"
	end
	
end
