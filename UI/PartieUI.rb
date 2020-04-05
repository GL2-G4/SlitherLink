require "gtk3"
require "optparse"
require "fileutils"
require_relative "../Noyau/Jeu.rb"

class PartieUI
	NOIR = Gdk::RGBA.new(0,0,0,1)
	BLANC = Gdk::RGBA.new(1,1,1,1)
	ROUGE = Gdk::RGBA.new(1,0,0,0.5)
	GRIS_BASE = Gdk::RGBA.new(0.94,0.94,0.94,1)

	private_class_method :new
	def PartieUI.creer(jeu)
		new(jeu)
	end

	def initialize(jeu)
		@jeu = jeu
		@window = Gtk::Window.new
		@grille = Gtk::Grid.new
		fenetre = Gtk::Box.new(:horizontal, 100)
		menu = Gtk::Box.new(:vertical, 20)
		menuh = Gtk::Box.new(:horizontal, 5)
		menub = Gtk::Box.new(:horizontal, 5)
		home = Gtk::Button.new
		ar = Gtk::Button.new
		av = Gtk::Button.new
		check = Gtk::Button.new
		hint = Gtk::Button.new
		#info = Gtk::Box.new(:vertical, nil)
		info = Gtk::Label.new("infos")
		save = Gtk::Box.new(:vertical, nil)
		saveh = Gtk::Box.new(:horizontal,20)
		#saveb = Gtk::Box.new(:vertical,nil)
		saveb = Gtk::Label.new("Quicksave")
		savet = Gtk::Label.new("QuickSave")
		savep = Gtk::Button.new
		boutons = Gtk::Box.new(:vertical,5)
		@timer = Gtk::Label.new("--:--")
		gritim = Gtk::Box.new(:vertical,20)

		scrolled = Gtk::ScrolledWindow.new
		scrolled.set_policy(:never, :automatic)

		home.set_label("menu")
		ar.set_label("ar")
		av.set_label("av")
		check.set_label("check")
		hint.set_label("hint")
		savep.set_label("+")

		saveb.set_size_request(200,200)
		info.set_size_request(200,200)
		
		
		@grille.set_border_width(10)
		@h = @jeu.getTailleLigne()
		@l = @jeu.getTailleColonne()
		
		saveh.add(savet)
		saveh.add(savep)
		save.add(saveh)
		save.add(saveb)
		menuh.add(ar)
		menuh.add(av)
		menuh.add(home)
		menub.add(check)
		menub.add(hint)
		boutons.add(menuh)
		boutons.add(menub)
		menu.add(boutons)
		menu.add(info)
		menu.add(save)
		gritim.add(@grille)
		gritim.add(@timer)
		fenetre.add(gritim)
		fenetre.add(menu)
		@window.add(fenetre)


		@traith = Array.new(@l*(@h+1))
		@traitv = Array.new(@h*(@l+1))
		signaux()

		# Signaux boutons
		ar.signal_connect('button_release_event'){
			#puts "UNDO"
			@jeu.undo()
			@jeu.afficherPlateau
			majGrille()
		}
		av.signal_connect('button_release_event'){
			#puts "REDO"
			@jeu.redo()
			@jeu.afficherPlateau
			majGrille()
		}
		check.signal_connect('button_release_event'){
			#puts "CHECK"
			@jeu.gagne?()
			@erreurs = @jeu.getErreursJoueur()
			@jeu.afficherErreur(tabErr: @erreurs)
			#info.set_label("Vous avez #{@erreurs.size()} erreur(s)")
			info.set_markup("<span font_desc=\"15.0\"><b>Vous avez #{@erreurs.size()} erreur(s)</b></span>");
		}

		@traith.each_index { |index|
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,BLANC);
			box.set_size_request(50,20)

			# Quand on click sur la ligne
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneHorizontale(index,:CLIC_GAUCHE)
					traiterCouleurLigneHorizontale(index)
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneHorizontale(index,:CLIC_DROIT)
					traiterCouleurLigneHorizontale(index)
				end
				#puts"clicked h "+index.to_s
			}
			c = getXYIntersection(index,false)
			i1,i2 = c[0],c[1]
			# Quand on est sur la ligne
			box.signal_connect('enter_notify_event'){
				#puts "On rentre sur la ligne"
				box.set_opacity(0.3)
				@grille.get_child_at(i1[0],i1[1]).set_opacity(0.3)
				@grille.get_child_at(i2[0],i2[1]).set_opacity(0.3)
			}

			# Quand on sort de la ligne
			box.signal_connect('leave_notify_event'){
				#puts "On sort de la ligne"
				box.set_opacity(1)
				@grille.get_child_at(i1[0],i1[1]).set_opacity(1)
				@grille.get_child_at(i2[0],i2[1]).set_opacity(1)
			}

			@traith[index] = box
		}

		@traitv.each_index { |index|
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,Gdk::RGBA.new(1,1,1,1));
			box.set_size_request(20,50)

			# Quand on click sur la ligne
			box.signal_connect('button_release_event'){|widget,event|
				if(event.state.button1_mask?)
					#puts "CLICK GAUCHE !"
					traiterLigneVerticale(index,:CLIC_GAUCHE)
					traiterCouleurLigneVerticale(index)
				elsif(event.state.button2_mask?)
					#puts "CLICK MOLETTE !"
				elsif(event.state.button3_mask?)
					#puts "CLICK DROIT !"
					traiterLigneVerticale(index,:CLIC_DROIT)
					traiterCouleurLigneVerticale(index)
				end
				#puts"clicked v "+index.to_s
			}
			c = getXYIntersection(index,true)
			i1,i2 = c[0],c[1]
			# Quand on est sur la ligne
			box.signal_connect('enter_notify_event'){
				#puts "On rentre sur la ligne"
				box.set_opacity(0.3)
				@grille.get_child_at(i1[0],i1[1]).set_opacity(0.3)
				@grille.get_child_at(i2[0],i2[1]).set_opacity(0.3)
			}

			# Quand on sort de la ligne
			box.signal_connect('leave_notify_event'){
				#puts "On sort de la ligne"
				box.set_opacity(1)
				@grille.get_child_at(i1[0],i1[1]).set_opacity(1)
				@grille.get_child_at(i2[0],i2[1]).set_opacity(1)
			}
			@traitv[index] = box
		}

		indiceh=0
		indicev=0
		for i in 0..@l*2
			for j in 0..@h*2
				if i % 2 == 0
					if j % 2 == 0
						l = Gtk::Label.new("", {:use_underline => true}).override_background_color(:normal,GRIS_BASE);
						@grille.attach(l,i,j,1,1)
						#@grille.get_child_at(i,j).override_background_color(:normal,GRIS_BASE);
					else
						@grille.attach(@traitv[indicev],i,j,1,1)
						#traiterCouleurLigneVerticale(indicev)
						indicev +=1
					end
				else
					if j % 2 == 0
						@grille.attach(@traith[indiceh],i,j,1,1)
						#traiterCouleurLigneHorizontale(indiceh)
						indiceh += 1
					else
						# "case [#{j/2};#{i/2}]" #{c.nbLigneDevantEtrePleine}
						c = @jeu.getCase(i/2,j/2);
						if(c.nbLigneDevantEtrePleine != 4)
							l = Gtk::Label.new("", {:use_underline => true})
							l.set_markup("<span font_desc=\"20.0\"><b>#{c.nbLigneDevantEtrePleine}</b></span>");
							@grille.attach(l,i,j,1,1)
						else
							@grille.attach(Gtk::Label.new("", {:use_underline => true}),i,j,1,1)
						end
					end
				end
			end
		end
		majGrille()
=begin
		sec = 0
		min = 0
		t = Thread.new {
			if(sec >= 60)
				sec = 0
				min += 1
			end
			@timer.set_label(min.to_s+":"+sec.to_s)
			sleep(1000)
		}
		t.join
=end
	end

	def getXYIntersection(index,vertical)
		c = getXY(index,vertical)
		if(vertical)
			if (index < @h)
				return [[c[0],c[1]*2],[c[0],c[1]*2+2]]
			else
				return [[c[0]*2+2,c[1]*2],[c[0]*2+2,c[1]*2+2]]
			end
		else
			if (index%(@h+1)==0)
				return [[c[0]*2,c[1]],[c[0]*2+2,c[1]]]
			else
				return [[c[0]*2,c[1]*2+2],[c[0]*2+2,c[1]*2+2]]
			end
		end
	end

	def getXY(index,vertical)
		if(vertical) # Vertical
			if (index < @h) # Gauche
				return [0,index]
			else # Droite
				return [(index-@h)/@h,index% @h]
			end
		else # Horizontal
			if (index%(@h+1)==0) # Haut
				return [index/(@h+1),0]
			else # Bas
				return [index/(@h+1),index%(@h+1)-1]
			end
		end
	end

	def traiterCouleurLigneVerticale(index)
		c1 = getXY(index,true)
		c2 = @jeu.getCase(c1[0],c1[1])
		c = getXYIntersection(index,true)
		i1,i2 = c[0],c[1]
		if (index < @h)
			l = c2.getLigne(:GAUCHE)
			traiterCouleurLigne(@traitv[index],l.etat)
		else
			l = c2.getLigne(:DROITE)
			traiterCouleurLigne(@traitv[index],l.etat)
		end
		traiterCouleurIntersection(i1[0],i1[1])
		traiterCouleurIntersection(i2[0],i2[1])
	end

	def traiterCouleurLigneHorizontale(index)
		c1 = getXY(index,false)
		c2 = @jeu.getCase(c1[0],c1[1])
		c = getXYIntersection(index,false)
		i1,i2 = c[0],c[1]
		if (index%(@h+1)==0)
			l = c2.getLigne(:HAUT)
			traiterCouleurLigne(@traith[index],l.etat)
		else
			l = c2.getLigne(:BAS)
			traiterCouleurLigne(@traith[index],l.etat)
		end
		traiterCouleurIntersection(i1[0],i1[1])
		traiterCouleurIntersection(i2[0],i2[1])
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

	def traiterLigneHorizontale(index, clique)
		if(index%(@h+1)==0)
			@jeu.jouer( (index/(@h+1)).to_i, 0, :HAUT , clique)
			puts "jouer(#{(index/(@h+1)).to_i}, 0, :HAUT, #{clique})"
			#puts"case bas,"+(index/(@h+1)).to_i.to_s+", 0"
		else
			@jeu.jouer( (index/(@h+1)).to_i, index%(@h+1)-1, :BAS , clique)
			puts "jouer(#{(index/(@h+1)).to_i}, #{index%(@h+1)-1}, :BAS, #{clique})"
			#puts"case haut, "+ (index/(@h+1)).to_i.to_s + ", " + (index%(@h+1)-1).to_s 
		end
		@jeu.afficherPlateau
	end

	def traiterLigneVerticale(index, clique)
		if(index < @h)
			#puts"case droite, 0 ,"+index.to_s
			puts "jouer(0, #{index}, :GAUCHE, #{clique})"
			@jeu.jouer(0, index, :GAUCHE, clique)
		else
			#puts"case gauche,"+((index-@h)/@h.to_i).to_s + ", " + (index% @h).to_s
			puts "jouer(#{(index-@h)/@h.to_i}, #{index% @h}, :DROITE, #{clique})"
			@jeu.jouer((index-@h)/@h.to_i, index% @h, :DROITE, clique)
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

	def majGrille()
		@traith.each_index { |index|
			traiterCouleurLigneHorizontale(index)
		}
		@traitv.each_index { |index|
			traiterCouleurLigneVerticale(index)
		}
	end
end
