##
# File: ChallengeManager.rb
# Project: UI
# File Created: Tuesday, 14th April 2020 2:57:40 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Tuesday, 14th April 2020 3:38:29 pm
# Modified By: <CPietJa>Galbrun T.
#
require 'json'

=begin
    *=== Descriptif
    Gère la sauvergarde et le chargement des challenges.
=end
class ChallengeManager
    
    private_class_method :new
    attr_reader :pwd
    attr_accessor :challenges

    # Charge un ensemble de challenges
    def self.charger(path_file)
        new(path_file)
    end
    def initialize(pwd)
        @pwd = pwd
        # Récupération data fichier
        fd = File.open(@pwd)
        f_data = fd.read()
        fd.close()
        @challenges = JSON.parse(f_data)
        return self
    end

    # Sauvegarde un ensemble de challenges
    def sauvegarder()
        res_json = JSON.generate(@challenges)
        fd = File.open(@pwd, "w")
        fd.write(res_json)
        fd.close()
        return self
    end
end
