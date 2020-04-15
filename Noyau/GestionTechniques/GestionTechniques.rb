##
# File: GestionTechniques.rb
# Project: Techniques
# File Created: Friday, 14th February 2020 5:40:31 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 15th April 2020 2:29:45 pm
# Modified By: <CPietJa>Galbrun T.
#
path = File.expand_path(File.dirname(__FILE__))

Dir[path + "/Techniques/*"].each { |folder|
    Dir[folder+"/*"].each { |file| require file }
}
require path + "/../Constante"
require path + "/Technique"

##
# * ===Description
# Cette classe permet de gérer un ensemble de Technique avec
# un ensemble d'opérations.
#
# * ===Méthodes de classe
# [listeDesTechniques] Renvoie la liste des techniques.
# [description(technique)] Renvoie la description d'une
# technique donnée.
# [setDescription(technique,description)] Change la description
# d'une technique donnée.
# [chercher(technique,plateau)] Cherche dans un plateau si la
# technique est applicable
# [getZone] Voir Technique#zone
# [getLignes] Voir Technique#lignesAModif
# [chercherAll(plateau)] Renvoie la première technique qui trouve un
# résultat, sinon renvoie nil.
# [autocompletion(plateau)] Renvoie la première technique d'autocomplétion
# qui trouve un résultat, sinon renvoie nil.
#
# * ===Variables de classe
# [listeTechniques] Table de Hashage contenant pour chaque clé
# une instance d'une technique.
#
class GestionTechniques
    attr_reader :listeTechniques

    # Liste Techniques
    @@listeTechniques = {
        :T1A3LB => UnAvecTroisLB.new("T1A3LB"),
        :T2A2LB => DeuxAvecDeuxLB.new("T2A2LB"),
        :T3A1LB => TroisAvecUneLB.new("T3A1LB"),
        :T0 => Zero.new("T0"),
        :T1A1LP => UnAvecUneLP.new(),
        :T2A2LP => DeuxAvecDeuxLP.new(),
        :T3A3LP => TroisAvecTroisLP.new(),
        :TNBCOIN => NbCoin.new("TNBCOIN"),
        :TCOINLB => CoinLB.new(),
        :TCOINLP => CoinLP.new(),
        :T3A0A => TroisAvecZeroAdj.new(),
        :T3A0D => TroisAvecZeroDiag.new(),
        :T3A3A => TroisAvecTroisAdj.new(),
        :T3A3D => TroisAvecTroisDiag.new(),
        :TLC => LigneContinuer.new(),
        :TLBC => LigneBloqueContinuer.new(),
        :TDLNB => DeuxLigneNoirBloque.new(),
        :TBCP => BloqueCasePleine.new()
    }

    # Renvoie la liste des techniques
    def self.listeDesTechniques
        return @@listeTechniques.keys()
    end

    # Renvoie la description d'une technique
    def self.description (technique)
        if (techniqueValide?(technique))
            return @@listeTechniques[technique].description()
        end
        raise TechniqueError, "Technique Incorrecte"
    end

    # Change la description d'une technique
    def self.setDescription (technique, description)
        if (techniqueValide?(technique))
            return @@listeTechniques[technique].description = description
        end
        raise TechniqueError, "Technique Incorrecte"
    end

    # Cherche dans un plateau si la technique est applicable
    def self.chercher (technique,plateau)
        if (techniqueValide?(technique))
            res = @@listeTechniques[technique].chercher(plateau)
            #puts @@listeTechniques[technique].to_s()
            return res
        end
        raise TechniqueError, "Technique Incorrecte"
    end

    # Voir Technique#zone
    def self.getZone(technique)
        if (techniqueValide?(technique))
            return @@listeTechniques[technique].zone()
        end
        raise TechniqueError, "Technique Incorrecte"
    end

    # Voir Technique#lignesAModif
    def self.getLignes(technique)
        if (techniqueValide?(technique))
            return @@listeTechniques[technique].lignesAModif()
        end
        raise TechniqueError, "Technique Incorrecte"
    end

    # Renvoie la première technique qui trouve un résultat, sinon renvoie nil.
    def self.chercherAll(plateau)
        @@listeTechniques.each{ |key,value|
            if(value.chercher(plateau))
                return key
            end
        }
        return nil
    end

    # Renvoie la première technique d'autocomplétion qui trouve un résultat, sinon renvoie nil.
    def self.autocompletion(plateau)
        if(@@listeTechniques[:T0].chercher(plateau))
            return :T0
        end
        if(@@listeTechniques[:T2A2LP].chercher(plateau))
            return :T2A2LP
        end
        if(@@listeTechniques[:T1A1LP].chercher(plateau))
            return :T1A1LP
        end
        if(@@listeTechniques[:T3A3LP].chercher(plateau))
            return :T3A3LP
        end
        #if(@@listeTechniques[:TCOINLB].chercher(plateau))
        #    return :TCOINLB
        #end
        if(@@listeTechniques[:TLBC].chercher(plateau))
            return :TLBC
        end
        if(@@listeTechniques[:TDLNB].chercher(plateau))
            return :TDLNB
        end
        return nil
    end

    private
    # Vérifie que la technique existe
    def self.techniqueValide? (technique)
        if(technique.class() != Symbol)
            return false
        end
        return @@listeTechniques.has_key?(technique)
    end

end

GT = GestionTechniques
