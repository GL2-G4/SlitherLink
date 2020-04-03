require "gtk3"
require "optparse"
require "fileutils"
require_relative "../Noyau/Jeu.rb"

class PartieUI
	private_class_method :new
	def PartieUI.creer(jeu)
		new(jeu)
	end

	def initialize(jeu)
		@jeu = jeu
		@window = Gtk::Window.new
		@grille = Gtk::Grid.new
		@grille.set_border_width(10)
		h = @jeu.getTailleLigne()
		l = @jeu.getTailleColonne()
		@window.add(@grille)
		@traith = Array.new(l*(h+1))
		@traitv = Array.new(h*(l+1))
		signaux()

		@traith.each_index { |index|
			etat = "blanc"
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
			box.set_size_request(50,20)
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneHorizontale(index,h,:CLIC_GAUCHE)
					if(etat != "noir")
						box.override_background_color(:normal,Gdk::RGBA.new(0,0,0,1));
						etat = "noir"
					else
						box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
						etat = "blanc"
					end
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneHorizontale(index,h,:CLIC_DROIT)
					if(etat != "rouge")
						box.override_background_color(:normal,Gdk::RGBA.new(1,0,0,1));
						etat = "rouge"
					else
						box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
						etat = "blanc"
					end
				end
				#puts"clicked h "+index.to_s
			}
			box.signal_connect('focus_in_event'){
				puts("olaaaaaaa")
				box.override_background_color(:normal,Gdk::RGBA.new(0.5,0.5,0.5,1));
			}

			box.signal_connect('focus_out_event'){
				if(etat == "noir")
					box.override_background_color(:normal,Gdk::RGBA.new(0,0,0,1));
				elsif(etat == "rouge")
					box.override_background_color(:normal,Gdk::RGBA.new(1,0,0,1));
				else
					box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
				end
			}
			@traith[index] = box
		} 

		@traitv.each_index { |index|
			etat = "blanc"
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
			box.set_size_request(20,50)
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneVerticale(index,h,:CLIC_GAUCHE)
					if(etat != "noir")
						box.override_background_color(:normal,Gdk::RGBA.new(0,0,0,1));
						etat = "noir"
					else
						box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
						etat = "blanc"
					end
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneVerticale(index,h,:CLIC_DROIT)
					if(etat != "rouge")
						box.override_background_color(:normal,Gdk::RGBA.new(1,0,0,1));
						etat = "rouge"
					else
						box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
						etat = "blanc"
					end
				end
				#puts"clicked v "+index.to_s
			}
			box.signal_connect('focus_in_event'){
				puts("olaaaaaaa")
				box.override_background_color(:normal,Gdk::RGBA.new(0.5,0.5,0.5,1));
			}

			box.signal_connect('focus_out_event'){
				if(etat == "noir")
					box.override_background_color(:normal,Gdk::RGBA.new(0,0,0,1));
				elsif(etat == "rouge")
					box.override_background_color(:normal,Gdk::RGBA.new(1,0,0,1));
				else
					box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
				end
			}
			@traitv[index] = box
		} 

		indiceh=0
		indicev=0
		for i in 0..l*2
			for j in 0..h*2
				if i % 2 == 0
					if j % 2 == 0
						@grille.attach(Gtk::Label.new("+", {:use_underline => true}),i,j,1,1)
						
					else
						@grille.attach(@traitv[indicev],i,j,1,1)
						indicev +=1
					end
				else
					if j % 2 == 0
						@grille.attach(@traith[indiceh],i,j,1,1)
						indiceh += 1
					else
						# "case [#{j/2};#{i/2}]" #{c.nbLigneDevantEtrePleine}
						c = @jeu.getCase(i/2,j/2);
						if(c.nbLigneDevantEtrePleine != 4)
							@grille.attach(Gtk::Label.new("#{c.nbLigneDevantEtrePleine}", {:use_underline => true}),i,j,1,1)
						else
							@grille.attach(Gtk::Label.new("", {:use_underline => true}),i,j,1,1)
						end
					end
				end
			end
		end

	end

	def traiterLigneHorizontale(index, h, clique)
		if(index%(h+1)==0)
			@jeu.jouer( (index/(h+1)).to_i, 0, :HAUT , clique)
			puts "jouer(#{(index/(h+1)).to_i}, 0, :HAUT, #{clique})"
			#puts"case bas,"+(index/(h+1)).to_i.to_s+", 0"
		else
			@jeu.jouer( (index/(h+1)).to_i, index%(h+1)-1, :BAS , clique)
			puts "jouer(#{(index/(h+1)).to_i}, #{index%(h+1)-1}, :BAS, #{clique})"
			#puts"case haut, "+ (index/(h+1)).to_i.to_s + ", " + (index%(h+1)-1).to_s 
		end
		@jeu.afficherPlateau
	end

	def traiterLigneVerticale(index, h, clique)
		if(index < h)
			#puts"case droite, 0 ,"+index.to_s
			puts "jouer(0, #{index}, :GAUCHE, #{clique})"
			@jeu.jouer(0, index, :GAUCHE, clique)
		else
			#puts"case gauche,"+((index-h)/h.to_i).to_s + ", " + (index%h).to_s
			puts "jouer(#{(index-h)/h.to_i}, #{index%h}, :DROITE, #{clique})"
			@jeu.jouer((index-h)/h.to_i, index%h, :DROITE, clique)
		end
		@jeu.afficherPlateau
	end

	def run
		@window.show_all
		@jeu.afficherPlateau
	end

	def signaux
		# Fermeture fenêtre
		@window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
	end

	def majGrille
		;
	end
end
