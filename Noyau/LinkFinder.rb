##
# @author KAJAK Rémi
# @version 1.0
# Ruby 2.3.3
#
# La classe "LinkFinder" définit des objets dont le rôle est de rechercher un fichier dans l'arborescence de l'application. Les objets lancent cette
# recherche depuis leur position courante, puis lorsqu'ils localisent le fichier cible, ils renvoient son lien relatif ; ou null, le cas échéant.
##
class LinkFinder
  attr_reader :rootLink

  # = Constantes
  #   BACK-UP_FILE Nom du fichier de sauvegarde des données de l'utilitaire
  #   BACK-UP_REPERTORY Nom du répertoire où est censé se trouver le fichier de sauvegarde des données de l'utilitaire
  BACKUP_FILE, BACKUP_REPERTORY = "saveLinkFinder.txt", "Tools"

  ##
  # La classe interne "RelativeLinks" définit la structure de stockage des liens relatifs trouvés par les instances de la classe "LinkFinder" pour un
  # fichier donné.
  ##
  class RelativeLinks
    attr_reader :fileName

    ##
    # = Variables d'instances
    #   @fileName Le nom du fichier recherché
    #   @links  Tableau associatif qui renseigne la correspondance entre un répertoire d'origine et un lien relatif
    ##
    def initialize(fileName,links=nil) # Fonctionnelle
      @fileName, @links = fileName, (links != nil) ? links : Hash.new
    end

    ##
    # Documentation à ajouter
    ##
    def to_s # Fonctionnelle
      i, sentence = 0, "#{@fileName} : "

      if self.hasLinks?
        @links.each { |repertory,relativeLink|
          sentence += "#{repertory} => #{relativeLink}"

          if i+1 < @links.length
            sentence += "|"
          end
          i += 1
        }
      else
        sentence += "ne possède aucun lien relatif connu"
      end
      return sentence
    end

    ##
    # Documentation à ajouter
    ##
    def hasLinks? # Fonctionnelle
      return !@links.empty?
    end

    ##
    # Documentation à ajouter
    ##
    def addOrUpdateLinks(repAndLink) # Fonctionnelle
      @links.merge!(repAndLink)
    end

    ##
    # Documentation à ajouter
    ##
    def hasLinkFor?(repOrigin) # Fonctionnelle
      return (self.hasLinks?) ? @links.has_key?(repOrigin) : false
    end

    ##
    # Documentation à ajouter
    ##
    def getLinkFor(repOrigin) # Fonctionnelle
      return (self.hasLinkFor?(repOrigin)) ? @links.values_at(repOrigin).pop : nil
    end

    ##
    # Documentation à ajouter
    ##
    def removeLink(repertory) # Fonctionnelle
      if self.hasLinkFor?(repertory)
        @links.delete(repertory)
      end
    end
  end

  ##
  # = Variables d'instance
  #   @appRepertory Nom du répertoire racine de l'application (limite maximale du champ de recherche)
  #   @lostFiles  Tableau contenant le nom des fichiers introuvables
  #   @rootLink Chaîne de caractères indiquant le répertoire d'origine de la recherche (nécessaire pour la création des liens relatifs)
  #   @backupLocation Chaîne de caractères indiquant le chemin du fichier de sauvegarde des liens relatifs
  #   @relativeLinks  Tableau d'instances "RelativeLinks" qui référencie les liens relatifs de tous les fichiers recherchés (tous répertoires confondus)
  ##
  def initialize(limitOfSearch=nil)
    @appRepertory, @lostFiles, @rootLink = (limitOfSearch != nil) ? limitOfSearch : File.basename(Dir.getwd), Array.new, Dir.getwd
    @backupLocation = self.searchFile(BACKUP_FILE)
    @relativeLinks = self.loadDatasFromBackup
  end

  ############################
  ### Méthodes principales ###
  ############################

  ##
  # Documentation à ajouter
  ##
  def endOfSearch # Fonctionnelle
    if !@lostFiles.empty? # Génération d'un log pour les fichiers non trouvés
      puts "Les fichiers ci-dessous n'ont pas pu être trouvés dans l'arborescence de l'application :"
      @lostFiles.each { |fileName|
        puts "- "+ fileName
      }
    end
    if !@relativeLinks.empty? # Sauvegarde de tous les liens relatifs trouvés dans le fichier spécifique
      self.saveDatas
    end
  end

  ##
  # Documentation à ajouter
  ##
  def searchFile(fileName) # Fonctionnelle
    backupSearch, relativeLink = (fileName == BACKUP_FILE || fileName == BACKUP_REPERTORY), nil

    if fileName != BACKUP_FILE # Dans le cas du fichier de sauvegarde des liens relatifs, on passe directement à la recherche dans l'arborescence
      # Recherche initiale dans le tableau des instances "RelativeLinks"
      rLinks = self.checkLinks(fileName)

      if rLinks != nil # Si une instance existe, on vérifie ses données
        relativeLink = rLinks.getLinkFor(self.getKeyForLink)

        if relativeLink != nil # Si un lien relatif existe pour le répertoire instanciateur, on le teste
          if !File.exist?(relativeLink) # S'il est incorrect, on le supprime de l'instance et on lance une nouvelle recherche (au cas où)
            rLinks.removeLink(self.getKeyForLink)
            relativeLink = nil
          end
        end
      end
    end

    if relativeLink == nil # Sinon, on lance une recherche dans l'arborescence
      previousSearchField, repertoryToSeek, resultOfSearch = nil, @rootLink, nil

      loop do
        resultOfSearch = self.searchFileInRepertory(fileName,repertoryToSeek,previousSearchField)

        if resultOfSearch == nil
          previousSearchField = File.basename(repertoryToSeek)
          repertoryToSeek = self.obtainParentDirectory(repertoryToSeek)
        end
        break if resultOfSearch != nil || File.basename(previousSearchField) == @appRepertory # Tant que le répertoire limite n'a pas été atteint
      end

      if resultOfSearch != nil # Fichier trouvé
        relativeLink = self.createRelativeLink(resultOfSearch) # Génération du lien relatif

        if fileName != BACKUP_FILE
          self.addOrUpdateLink(fileName,relativeLink) # Sauvegarde dans @relativeLinks
        end
      elsif !backupSearch # Fichier introuvable
        @lostFiles.push(fileName)
      end
    end

    if fileName != BACKUP_FILE
      return relativeLink
    else # Résultat final de la recherche du fichier de sauvegarde de l'utilitaire
      return (relativeLink != nil) ? relativeLink : File.expand_path(BACKUP_FILE,self.searchFile(BACKUP_REPERTORY))
    end
  end

  ##
  # Documentation à ajouter
  ##
  def searchFileInRepertory(fileName,repertory,repertoryToIgnore=nil) # Fonctionnelle
    if !repertory.empty?
      Dir.foreach(repertory) { |fileLooked|
        if fileLooked != "." && fileLooked != ".." && fileLooked != ".git"
          currentFileLink = File.expand_path(fileLooked,repertory) # Création du lien absolu du fichier analysé
          # Comparaison entre le fichier analysé et le fichier à trouver
          if fileLooked == fileName
            return currentFileLink
          end
          # Si le fichier analysé s'avère être un dossier et qu'il ne doit pas être ignoré
          if File.directory?(currentFileLink) && fileLooked != repertoryToIgnore
            linkFound = self.searchFileInRepertory(fileName,currentFileLink)
          end

          if linkFound != nil # Ne pas retirer : l'instruction permet d'interrompre la recherche en cas de résultat positif
            return linkFound
          end
        elsif fileLooked == repertoryToIgnore
          return File.expand_path(fileLooked,repertory)
        end
      }
      return nil # Fichier introuvable dans le répertoire fouillé
    end
  end

  #######################################################################
  ### Méthodes de génération de données à partir de variables connues ###
  #######################################################################

  ##
  # Documentation à ajouter
  ##
  def createRelativeLink(fileAbsoluteLink) # Fonctionnelle
    fileLinkParts = fileAbsoluteLink.split("/").drop_while {|part| part == ""}
    rootParts = @rootLink.split("/").drop_while {|part| part == ""}
    fileName, relativeLink = fileLinkParts.pop, ""

    # Dans le cas où le lien relatif à générer concerne l'emplacement du répertoire instanciateur
    if fileName == rootParts.last
      return "./"
    else
      # On retire tous les éléments identiques aux deux liens qui se trouvent aux mêmes positions
      while(rootParts.first == fileLinkParts.first && !rootParts.empty? && !fileLinkParts.empty?)
        fileLinkParts.shift
        rootParts.shift
      end

      # Ajout d'un nombre de retours arrières équivalent au nombre de dossiers restants du lien racine
      for i in 1..rootParts.length
        relativeLink += "../"
      end
      # Ajout des dossiers restants du lien fichier pour finaliser le lien relatif
      if !fileLinkParts.empty?
        relativeLink += fileLinkParts.join("/") + "/"
      end
      return relativeLink + fileName
    end
  end

  ##
  # Documentation à ajouter
  ##
  def getKeyForLink # Fonctionnelle
    return @rootLink.split("/").slice(@rootLink.split("/").rindex(@appRepertory)..@rootLink.split("/").size).join("/")
  end

  ##
  # Documentation à ajouter
  ##
  def obtainParentDirectory(repertoryPath) # Fonctionnelle
    return repertoryPath.split("/").shift(repertoryPath.split("/").length-1).join("/")
  end

  #######################################################################
  ### Méthodes d'accès et de modifications des données des structures ###
  #######################################################################

  ##
  # Documentation à ajouter
  ##
  def checkLinks(fileName) # Fonctionnelle
    if @relativeLinks != nil && !@relativeLinks.empty?
      @relativeLinks.each { |rLinks|
        if rLinks.fileName == fileName # Si une instance pour le fichier recherché existe déjà
          return rLinks
        end
      }
    end
    return nil
  end

  ##
  # Documentation à ajouter
  ##
  def addOrUpdateLink(fileName,relativeLink) # Fonctionnelle
    key, rLinks = self.getKeyForLink, self.checkLinks(fileName)

    if rLinks != nil # Si une instance pour le fichier recherché existe déjà
      rLinks.addOrUpdateLinks(Hash[key => relativeLink])
    elsif @relativeLinks != nil
      @relativeLinks.push(RelativeLinks.new(fileName,Hash[key => relativeLink]))
    end
  end

  ##
  # Documentation à ajouter
  ##
  def deleteRootLink(fileName) # Fonctionnelle
    rLinks = self.checkLinks(fileName)

    if rLinks != nil # Si une instance pour le fichier recherché existe
      if rLinks.hasLinkFor?(@rootLink)
        rLinks.removeLink(@rootLink)
      end

      if rLinks.hasLinks? # Si le fichier recherché ne possède plus aucun lien valide, on supprime son espace de stockage du tableau
        @relativeLinks.delete(rLinks)
      end
    end
  end

  #############################################
  ### Méthodes de conservation des données  ###
  #############################################

  ##
  # Documentation à ajouter
  ##
  def loadDatasFromBackup # Fonctionnelle
    if !File.exist?(@backupLocation) # Si le fichier de sauvegarde de l'utilitaire n'existe pas
      return Array.new
    else
      fd, relativeLinks = File.open(@backupLocation,"r"), Array.new
      fd.each_line { |line|
        fileLinks, repAndLinks = line.split(" : ").last, Hash.new
        # Remplissage du nouveau tableau associatif
        fileLinks.split("|").each { |hash|
          hashParts = hash.split(" => ")
          repAndLinks.merge!(Hash[hashParts.first.to_s => hashParts.last.delete("\n")])
        }
        relativeLinks.push(RelativeLinks.new(line.split(" : ").first,repAndLinks))
      }
      fd.close
      return relativeLinks
    end
  end

  ##
  # Documentation à ajouter
  ##
  def saveDatas # Fonctionnelle
    fd = (File.exist?(@backupLocation)) ? File.open(@backupLocation,"w") : File.new(@backupLocation,"w",0644)
    @relativeLinks.each { |rLinks| fd.puts(rLinks.to_s) } # Écriture dans le fichier de sauvegarde de l'utilitaire
    fd.close
  end
end

def testerLinkFinder(searcher,fileName)
  resultat = searcher.searchFile(fileName)

  if resultat != nil
    puts "Résultat de la recherche => "+ resultat
  else
    puts "Fichier introuvable !\n\n"
  end
end

test = LinkFinder.new("TestLinkFinder")
testerLinkFinder(test,"tasDeBlurf.png")
test.endOfSearch
