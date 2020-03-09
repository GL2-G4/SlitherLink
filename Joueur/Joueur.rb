
class Joueur

	#@argent : l'argent dont dispose le joueur
	#@etoiles : le nombre d'étoiles dont dispose le joueur
	#@parametres : table de hachage qui contient des paires cle => valeur correspondant à "nom paramètre" => ID
	#@listeGrillesDebloquees : la liste des ID des grilles débloquées
	#@listeObjetsDebloques : la liste des ID des objets débloqués par le joueur

	# Création du joueur
	def Joueur.creer()
		new()
	end
	
	# Accès en lecture aux variables argent, etoiles, parametres
	attr_reader :argent, :etoiles, :parametres
	
	# Accès en écriture aux paramètres
	attr_writer :parametres
	
	# Constructeur d'un joueur
	def initialize()
	
		@argent = 0
		@etoiles = 0
		@parametres = Hash.new()
		self.parametresDefaut()
		@listeGrillesDebloquees = Array.new()
		@listeObjetsDebloques = Array.new()
	end
	
	# Affecte les paramètres par défaut au joueur
	def parametresDefaut()
	
		@parametres = {
			"theme" => 1,
			"taille" => 4,
			"autocompletion" => false
		}
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
		elsif somme < 0
			raise ArgumentError, "Erreur : somme négative"
		else 
			puts "Pas assez d'argent"
		end
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
	
	# Méthode d'affichage d'un joueur
	def to_s
	
		puts "Argent = #{@argent}$"
		puts "Etoiles = #{@etoiles}*"
		puts @parametres
		puts @listeGrillesDebloquees
		puts @listeObjetsDebloques
	end

end
