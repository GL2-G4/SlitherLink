=begin
    Auteurs :: Galbrun T.
    Version :: 0.1
    ---
    * ===Description
    Ensemble de module contenant des constantes et des
    méthodes permettant leurs vérifications.
=end

module OpConstante
    def estValide?(constante)
        if(constante.class() != Symbol)
            return false
        end
        return self.constants.include?(constante)
    end
end

=begin
module TypeLigne
    VIDE   = 0
    PLEINE = 1
    BLOQUE = 2

    extend OpConstante
end
=begin
class Test
    include TypeLigne

    attr_reader :etat
    def initialize etat
        if(estValide?(etat))
            @etat = etat
            puts @etat.to_i
        end
    end
end

=end