##
# File: Zone.rb
# Project: Techniques
# File Created: Friday, 14th February 2020 5:41:08 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Saturday, 15th February 2020 3:51:58 pm
# Modified By: <CPietJa>Galbrun T.
#


class Zone
    attr_reader :x1, :x2, :y1, :y2

    def initialize (x1, y1, x2, y2)
        @x1,@x2,@y1,@y2 = x1,x2,y1,y2
    end

    def to_s
        return "Debut[#{@x1},#{@y1}] -> Fin[#{@x2},#{@y2}]"
    end

end
