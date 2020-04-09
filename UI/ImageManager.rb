##
# File: ImageManager.rb
# Project: UI
# File Created: Tuesday, 7th April 2020 11:12:17 pm
# Author: <CPietJa>Galbrun T.
# -----
# Last Modified: Wednesday, 8th April 2020 4:15:45 pm
# Modified By: <CPietJa>Galbrun T.
#
require 'gtk3'


class ImageManager
    private_class_method :new

    PATH = File.expand_path(File.dirname(__FILE__))
    Stock = {
        :ICON_HOME => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-accueil-50.png'),
        :ICON_UNDO => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-annuler-50-2.png'),
        :ICON_REDO => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-refaire-50.png'),
        :ICON_CHECK => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-coche-50.png'),
        :ICON_AIDE => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-idée-50.png'),
        :ICON_ADD => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-plus-50.png'),
        :ICON_PLAY => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-jouer-50.png'),
        :ICON_DEL => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-effacer-50-2.png'),
        :ICON_RESTART => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-redémarrer-50.png'),
        :ICON_DOC => GdkPixbuf::Pixbuf.new(:file => PATH + '/../Assets/Icons/IconesNoir/icons8-document-50.png'),
    }
    
    def self.getImageFromStock(name,width,height)
        return Gtk::Image.new(:pixbuf => Stock[name].copy().scale_simple(width,height,GdkPixbuf::InterpType::BILINEAR))
    end

    def self.getImageFromFile(file,width,height)
        p = GdkPixbuf::Pixbuf.new(:file => file)
        return Gtk::Image.new(:pixbuf => p.scale_simple(width,height,GdkPixbuf::InterpType::BILINEAR))
    end
end