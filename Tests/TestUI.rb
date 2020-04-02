##
# File: TestUI.rb
# Project: Tests
# File Created: Thursday, 2nd April 2020 3:29:53 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Thursday, 2nd April 2020 3:36:09 pm
# Modified By: <CPietJa>Galbrun T.
#
require "gtk3"
require_relative "../Noyau/Jeu.rb"
require_relative "../UI/PartieUI.rb"

Gtk.init

jeu = Jeu.creer(10,5)
jUI = PartieUI.creer(jeu)

jUI.run


Gtk.main