##
# File: Zone.rb
# Project: Techniques
# File Created: Friday, 14th February 2020 5:41:08 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Friday, 6th March 2020 3:56:02 pm
# Modified By: <CPietJa>Galbrun T.
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
