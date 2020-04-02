##
# File: Zone.rb
# Project: Techniques
# File Created: Friday, 14th February 2020 5:41:08 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 26th March 2020 4:17:40 pm
# Modified By: <CPietJa>Galbrun T.
#

##
# * ===Description
# Une Zone comprend 2 coordonnées (x1,y1) et (x2,y2) qui
# permettent de la délimiter sous la forme d'un rectangle.
#
# * ===Méthodes d'instance
# [setCoordUn] Permet de modifier la 1ère coordonnée.
# [setCoordDeux] Permet de modifier la 2ème coordonnée.
#
# * ===Variables d'instance
# [x1] X de la 1ère coordonnée.
# [y1] Y de la 1ère coordonnée.
# [x2] X de la 2ème coordonnée.
# [y2] Y de la 2ème coordonnée.
#
class Zone
    attr_accessor :x1, :x2, :y1, :y2

    def initialize (x1, y1, x2, y2)
        @x1,@x2,@y1,@y2 = x1,x2,y1,y2
    end

    def to_s
        return "Debut[#{@x1},#{@y1}] -> Fin[#{@x2},#{@y2}]"
    end

    def setCoordUn (x1,y1)
        @x1,@y1 = x1,y1
    end

    def setCoordDeux (x2,y2)
        @x2,@y2 = x2,y2
    end

end
