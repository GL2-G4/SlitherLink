require "gtk3"
require "optparse"
require "fileutils"
require_relative "../Noyau/Jeu.rb"

class PartieUI
	NOIR = Gdk::RGBA.new(0,0,0,1)
	BLANC = Gdk::RGBA.new(1,1,1,1)
	ROUGE = Gdk::RGBA.new(1,0,0,1)
	GRIS_BASE = Gdk::RGBA.new(0.94,0.94,0.94,1)

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
			box.override_background_color(:normal,BLANC);
			box.set_size_request(50,20)
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneHorizontale(index,h,:CLIC_GAUCHE)
					traiterCouleurLigneHorizontale(index,h)
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneHorizontale(index,h,:CLIC_DROIT)
					traiterCouleurLigneHorizontale(index,h)
				end
				#puts"clicked h "+index.to_s
			}
			box.signal_connect('focus_in_event'){
				puts("olaaaaaaa")
				box.override_background_color(:normal,Gdk::RGBA.new(0.5,0.5,0.5,1));
			}

			box.signal_connect('focus_out_event'){
				if(etat == "noir")
					box.override_background_color(:normal,NOIR);
				elsif(etat == "rouge")
					box.override_background_color(:normal,ROUGE);
				else
					box.override_background_color(:normal,BLANC);
				end
			}
			@traith[index] = box
		} 

		@traitv.each_index { |index|
			etat = "blanc"
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,BLANC);
			box.set_size_request(20,50)
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneVerticale(index,h,:CLIC_GAUCHE)
					traiterCouleurLigneVerticale(index,h)
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneVerticale(index,h,:CLIC_DROIT)
					traiterCouleurLigneVerticale(index,h)
				end
				#puts"clicked v "+index.to_s
			}
			box.signal_connect('focus_in_event'){
				puts("olaaaaaaa")
				box.override_background_color(:normal,Gdk::RGBA.new(0.5,0.5,0.5,1));
			}

			box.signal_connect('focus_out_event'){
				if(etat == "noir")
					box.override_background_color(:normal,NOIR);
				elsif(etat == "rouge")
					box.override_background_color(:normal,ROUGE);
				else
					box.override_background_color(:normal,BLANC);
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
						l = Gtk::Label.new("", {:use_underline => true}).override_background_color(:normal,GRIS_BASE);
						@grille.attach(l,i,j,1,1)
						#@grille.get_child_at(i,j).override_background_color(:normal,GRIS_BASE);
					else
						@grille.attach(@traitv[indicev],i,j,1,1)
						traiterCouleurLigneVerticale(indicev,h)
						indicev +=1
					end
				else
					if j % 2 == 0
						@grille.attach(@traith[indiceh],i,j,1,1)
						traiterCouleurLigneHorizontale(indiceh,h)
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

	def traiterCouleurLigneVerticale(index,h)
		if (index < h)
			l = @jeu.getCase(0,index).getLigne(:GAUCHE)
			traiterCouleurLigne(@traitv[index],l.etat)
			#puts "I [#{0};#{index*2}] [#{0};#{index*2+2}]"
			traiterCouleurIntersection(0,index*2)
			traiterCouleurIntersection(0,index*2+2)
		else
			l = @jeu.getCase((index-h)/h,index%h).getLigne(:DROITE)
			traiterCouleurLigne(@traitv[index],l.etat)
			#puts "I [#{(index-h)/h*2+2};#{(index%h)*2}] [#{(index-h)/h*2+2};#{(index%h)*2+2}]"
			traiterCouleurIntersection((index-h)/h*2+2,(index%h)*2)
			traiterCouleurIntersection((index-h)/h*2+2,(index%h)*2+2)
		end
	end

	def traiterCouleurLigneHorizontale(index,h)
		if (index%(h+1)==0)
			l = @jeu.getCase(index/(h+1),0).getLigne(:HAUT)
			traiterCouleurLigne(@traith[index],l.etat)
			#puts "I [#{index/(h+1)*2};#{0}] [#{index/(h+1)*2+2};#{0}]"
			traiterCouleurIntersection(index/(h+1)*2,0)
			traiterCouleurIntersection(index/(h+1)*2+2,0)
		else
			l = @jeu.getCase(index/(h+1),index%(h+1)-1).getLigne(:BAS)
			traiterCouleurLigne(@traith[index],l.etat)
			#puts "I [#{index/(h+1)*2};#{(index%(h+1)-1)*2+2}] [#{index/(h+1)*2+2};#{(index%(h+1)-1)*2+2}]"
			traiterCouleurIntersection(index/(h+1)*2,(index%(h+1)-1)*2+2)
			traiterCouleurIntersection(index/(h+1)*2+2,(index%(h+1)-1)*2+2)
		end
	end

	def traiterCouleurLigne(ligne,etat)
		traiterCouleur(ligne,etat)
	end

	def traiterCouleur(objet, etat)
		case etat
		when :PLEINE
			objet.override_background_color(:normal,NOIR);
		when :VIDE
			objet.override_background_color(:normal,BLANC);
		when :BLOQUE
			objet.override_background_color(:normal,ROUGE);
		else
			objet.override_background_color(:normal,BLANC);
		end
	end

	def traiterCouleurIntersection(x,y)
		#puts "[#{x};#{y}]"
		# On compte le nombre de ligne pleine, vide, bloque
		nb = {:BLOQUE => 0, :PLEINE => 0, :VIDE => 0}
		# Ligne du haut
		if((l = getLigne(x,y-1)) != nil)
			nb[l.etat] += 1
		end
		# Ligne de gauche
		if((l = getLigne(x-1,y)) != nil)
			nb[l.etat] += 1
		end
		# Ligne de droite
		if((l = getLigne(x+1,y)) != nil)
			nb[l.etat] += 1
		end
		# Ligne du bas
		if((l = getLigne(x,y+1)) != nil)
			nb[l.etat] += 1
		end
		#puts nb

		# On regarde qui à la majorité
		trier = nb.to_a.sort{|a,b| b[1] <=> a[1]}
		#puts trier.join("][")
		if((l = @grille.get_child_at(x,y)) == nil)
			return
		end
		if(trier[0][1] == trier[1][1])
			if(trier[0][0] == :PLEINE || trier[1][0] == :PLEINE)
				traiterCouleur(l,:PLEINE)
			elsif(trier[0][0] == :BLOQUE || trier[1][0] == :BLOQUE)
				traiterCouleur(l,:BLOQUE)
			end
		elsif(trier[0][0] == :VIDE)
			if(nb[:PLEINE] != 0)
				traiterCouleur(l,:PLEINE)
			elsif(nb[:BLOQUE] != 0)
				traiterCouleur(l,:BLOQUE)
			else
				traiterCouleur(l,:VIDE)
			end
		else
			if((l = @grille.get_child_at(x,y)) != nil)
				traiterCouleur(l,trier[0][0])
			end
		end
	end

	# Renvoie la ligne du Jeu de coordonnées x,y dans la grilleUI
	def getLigne(x,y)
		i,j = x/2,y/2
		#puts "[#{i};#{j}]"
		if(x%2 == 0)
			if(i >= @jeu.getTailleColonne)
				#puts "LV Droite"
				if((c = @jeu.getCase(i-1,j)) != nil)
					return c.getLigne(:DROITE)
				end
			else
				#puts "LV Gauche"
				if((c = @jeu.getCase(i,j)) != nil)
					return c.getLigne(:GAUCHE)
				end
			end
		else
			if(j >= @jeu.getTailleLigne)
				#puts "LH Bas"
				if((c = @jeu.getCase(i,j-1)) != nil)
					return c.getLigne(:BAS)
				end
			else
				#puts "LH Haut"
				if((c = @jeu.getCase(i,j)) != nil)
					return c.getLigne(:HAUT)
				end
			end
		end
		return nil
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
