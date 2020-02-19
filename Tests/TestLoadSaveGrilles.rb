path = File.expand_path(File.dirname(__FILE__))

require path + "/../Noyau/LoadSaveGrilles/ChargeurGrille"

chargeurGrille = ChargeurGrille.charger(path + "/../Grilles/grille")
#chargeurGrille.getGrilleIndex(0).afficher
chargeurGrille.afficherGrilles
chargeurGrille.sauvegarder(path + "/../Grilles/grille2")

