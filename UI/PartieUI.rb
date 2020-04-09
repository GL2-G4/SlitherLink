require "gtk3"
require "optparse"
require "fileutils"
require "thread"
require_relative "../Noyau/Jeu.rb"
require_relative "./Popup.rb"
require_relative "./ImageManager.rb"
require_relative "./Chrono.rb"


class PartieUI
	NOIR = Gdk::RGBA.new(0,0,0,1)
	BLANC = Gdk::RGBA.new(1,1,1,1)
	ROUGE = Gdk::RGBA.new(1,0,0,0.5)
	VERT = Gdk::RGBA.new(0,1,0,0.5)
	GRIS_BASE = Gdk::RGBA.new(0.94,0.94,0.94,1)

	private_class_method :new
	def PartieUI.creer(jeu,w:600, h:500, fs:false)
		new(jeu,w,h,fs)
	end

	def initialize(jeu,w,h,fs)
		@jeu = jeu
		@h = @jeu.getTailleLigne()
		@l = @jeu.getTailleColonne()
		@window = Gtk::Window.new
		@chrono = Chrono.new
		if(fs)
			@window.fullscreen().set_resizable(false)
			#@window.maximize().set_resizable(false)
			@width, @height = @window.screen.width, @window.screen.height
		else
			@width, @height = w,h
			@window.set_default_size(@width,@height).set_resizable(false)
			@window.set_position('center_always')
		end
		@grille = Gtk::Grid.new
		grilleW, grilleH = @width*0.5,@height*0.6
		lignesDim = grilleWH(grilleW,grilleH)

		fenetre = Gtk::Box.new(:horizontal)
		menu = Gtk::Box.new(:vertical).set_size_request(@width*0.5,@height)
		menuh = Gtk::Box.new(:horizontal).set_homogeneous(true)
		menub = Gtk::Box.new(:horizontal).set_homogeneous(true)
		home = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_HOME,50,50)).set_border_width(10)
		ar = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_UNDO,50,50)).set_border_width(10)
		av = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_REDO,50,50)).set_border_width(10)
		check = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_CHECK,50,50)).set_border_width(10)
		hint = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_AIDE,50,50)).set_border_width(10)
		effacer = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_DEL,50,50)).set_border_width(10)
		@info = Gtk::Box.new(:vertical)
		#@info = Gtk::Label.new("")#.set_height_request(@height*0.3)#.override_background_color(:normal,VERT)
		save = Gtk::Box.new(:vertical)
		saveBtn = Gtk::Grid.new.set_row_homogeneous(true)
		saveh = Gtk::Box.new(:horizontal).set_homogeneous(true)
		@saveb = Gtk::Box.new(:vertical)
		savet = Gtk::Label.new.set_markup("<span font_desc=\"#{lignesDim[1]*0.9}\"><b> QuickSave </b></span>")
		savep = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_ADD,25,25)).set_border_width(10)
		qsChargerSafe = Gtk::Button.new.set_image(ImageManager.getImageFromStock(:ICON_PLAY,25,25)).set_border_width(10)
		boutons = Gtk::Box.new(:vertical)
		@timer = Gtk::Label.new("coucou")
		gritim = Gtk::Box.new(:vertical)

		popupErreur = Popup.new()
		popupNoErreur = Popup.new()

		scrolled = Gtk::ScrolledWindow.new
		scrolled.set_policy(:never, :automatic)
		scrolledInfo = Gtk::ScrolledWindow.new
		scrolledInfo.set_policy(:automatic, :automatic)

		@grille.set_border_width(20)
		@grille.set_size_request(grilleW,grilleH)
		menu.set_border_width(20)
		scrolledInfo.set_height_request(@height*0.3)
		scrolled.set_height_request(@height*0.4)
		@info.set_margin_bottom(15)
		@info.set_margin_right(20)
		@info.set_margin_top(5)
		
		# Ajout Zone QuickSave
		saveh.add(savep)
		saveh.add(qsChargerSafe)
		saveBtn.attach(savet,0,0,2,1)
		saveBtn.attach(saveh,2,0,1,1)
		save.add(saveBtn)
		scrolled.add(@saveb)
		save.add(scrolled)#.override_background_color(:normal,ROUGE)
		# Ajout Btn UNDO, REDO, MENU
		menuh.add(ar)
		menuh.add(av)
		menuh.add(home)
		# Ajout Btn CHECK, AIDE, EFFACER
		menub.add(check)
		menub.add(hint)
		menub.add(effacer)
		# Ajout Listes Btn
		boutons.add(menuh)
		boutons.add(menub)#.override_background_color(:normal,ROUGE)
		scrolledInfo.add(@info)
		menu.add(boutons)
		menu.add(scrolledInfo)
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
		popupErreur.addBouton(titre:"Voir erreur(s)"){
			#puts "Voir Erreur"
			popupErreur.stop()
			affichageErreurs()
		}
		popupErreur.addBouton(titre:"Fermer"){
			popupErreur.stop()
		}
		popupNoErreur.addBouton(titre:"Fermer"){
			popupNoErreur.stop()
		}
		check.signal_connect('button_release_event'){
			#puts "CHECK"
			remove_all_child(@info)
			@jeu.gagne?()
			@erreurs = @jeu.getErreursJoueur()
			if(@erreurs.size() == 0)
				popupNoErreur.set_titre(titre:"Vous avez #{@erreurs.size()} erreur")
				popupNoErreur.run()
			else
				popupErreur.set_titre(titre:"Vous avez #{@erreurs.size()} erreur(s)")
				popupErreur.run()
			end
		}
		savep.signal_connect('button_release_event'){
			#puts "NEW QUICKSAVE"
			@jeu.quicksaveEnregistrer()
			majQS()
		}
		majQS()
		qsChargerSafe.signal_connect('button_release_event'){
			#puts "RETOUR A LA GRILLE COURANTE"
			@jeu.quicksaveChargerSafe()
			majGrille()
		}
		effacer.signal_connect('button_release_event'){
			#puts "EFFACER"
			@jeu.effacerGrille()
			majGrille()
			majQS()
		}
		hint.signal_connect('button_release_event'){
			t = @jeu.chercherAll()
			if(t != nil)
				d = @jeu.getDescription(t)
				z = @jeu.getZone(t)
				l = @jeu.getLignes(t)
				puts "Technique : " + d.to_s()
				puts "Zone : " + z.to_s()
				puts "Lignes : " + l.to_s()
				for ll in l
					ll[0].setEtat(ll[1])
				end
				majGrille()
			end
		}

		@traith.each_index { |index|
			box = Gtk::EventBox.new()
			box.override_background_color(:normal,BLANC);
			box.set_size_request(lignesDim[0],lignesDim[1])

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
			box.set_size_request(lignesDim[1],lignesDim[0])

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
							l.set_markup("<span font_desc=\"#{lignesDim[1]*0.9}\"><b>#{c.nbLigneDevantEtrePleine}</b></span>")
							@grille.attach(l,i,j,1,1)
						else
							l = Gtk::Label.new("", {:use_underline => true})
							l.set_markup("<span font_desc=\"#{lignesDim[1]*0.9}\"> </span>")
							@grille.attach(l,i,j,1,1)
						end
					end
				end
			end
		end
		majGrille()
		@chrono.start
		t = Thread.new{affichageChrono}
	end

	def addMessage(msg)
		boxM = Gtk::Box.new(:horizontal)
		boxM.set_margin_top(5)
		boxM.set_margin_bottom(5)
		labelM = Gtk::Label.new().set_xalign(0).set_yalign(0.5)
		labelM.set_markup("<span font_desc=\"10.0\"><b>#{msg}</b></span>")
		boxM.add(labelM)
		@info.add(boxM)
	end

	def addMessageErreur(e)
		boxE = Gtk::Box.new(:horizontal)
		boxE.set_margin_top(5)
		boxE.set_margin_bottom(5)
		boxI = Gtk::Box.new(:vertical)
		boxI.set_homogeneous(false)
		boxI.set_margin_right(20)
		labelC = Gtk::Label.new().set_xalign(0)
		labelD = Gtk::Label.new().set_xalign(0)
		btn = Gtk::Button.new(:label => "Voir")
		iconDel = ImageManager.getImageFromStock(:ICON_DEL,20,20)
		boxBtnE = Gtk::Box.new(:horizontal)
		boxBtnE.set_margin_left(10)
		#boxBtnE.set_margin_right(20)
		btnE = Gtk::Button.new.set_image(iconDel)
		btnE.signal_connect('button_release_event') {
			@info.remove(boxE)
		}

		x,y = e[1]*2+1,e[2]*2+1
		case e[0]
		when :NB_LIGNES_INCORRECT
			labelC.set_markup("<span font_desc=\"10.0\"><b>Case [#{e[1]},#{e[2]}]</b></span>")
			labelD.set_markup("<span font_desc=\"10.0\">#{e[3]}</span>")
		when :LIGNE_PLEINE_NON_VALIDE || :LIGNE_PLEINE_NON_PRESENTE
			labelC.set_markup("<span font_desc=\"10.0\"><b>Case [#{e[1]},#{e[2]}] Ligne #{e[3]}</b></span>")
			labelD.set_markup("<span font_desc=\"10.0\">#{e[4]}</span>")
			case e[3]
			when :DROITE
				x += 1
			when :GAUCHE
				x -= 1
			when :HAUT
				y -= 1
			when :BAS
				y += 1
			end
		end
		#puts "[#{x},#{y}]"
		c = @grille.get_child_at(x,y)
		btn.signal_connect('button_release_event') {
			clignoterElement(c)
		}
		boxI.add(labelC)
		boxI.add(labelD)
		boxBtnE.add(btnE)
		boxE.add(boxI)
		boxE.add(btn)
		boxE.add(boxBtnE)
		@info.add(boxE)
	end

	def clignoterElement(element)
		color = element.style_context.get_background_color(:normal)
		Thread.new(){
			t = 0.5
			for i in 0..2
				element.override_background_color(:normal,VERT)
				sleep(t)
				element.override_background_color(:normal,color)
				sleep(t)
			end
		}
	end

	def affichageErreurs
		puts "Affichage Erreurs"
		remove_all_child(@info)
		@jeu.afficherErreur(tabErr: @erreurs)
		for e in @erreurs
			addMessageErreur(e)
		end
		@info.show_all
	end

	def grilleWH(w,h)
		hL = h/(@h*2+1)
		wL = w/(@l*2+1)
		coef = 0.8
		#puts "wL/hL : [#{wL},#{hL}]"
		if(hL < wL)
			#puts "hL : [#{w},#{h}] -> [#{hL+hL*coef},#{hL-hL*coef}] -> #{(hL+hL*coef)*@h + (hL-hL*coef)*(@h+1)}"
			return [hL+hL*coef,hL*coef]
		else
			#puts "wL : [#{w},#{h}] -> [#{wL+wL*coef},#{wL-wL*coef}] -> #{(wL+wL*coef)*@l + (wL-wL*coef)*(@l+1)}"
			return [wL+wL*coef,wL*coef]
		end
	end

	def remove_all_child(widget)
		widget.each { |child|
			widget.remove(child)
		}
	end

	def majQS()
		remove_all_child(@saveb)
		#puts "\t---- #{@jeu.quickSave.nbQS()}"
		@tQS = Array.new(@jeu.quickSave.nbQS())
		@tQS.each_index{ |i|
			ajouterQS(i)
		}
		@saveb.show_all
	end

	def ajouterQS(i = @jeu.quickSave.nbQS()-1)
		q = Gtk::ButtonBox.new(:horizontal)
		#q.set_width_request(30)
		border = Gtk::Frame.new()
		#q.set_border_width(10)
		textBox = Gtk::Label.new()
		textBox.set_markup("<span font_desc=\"12.0\"><b>QuickSave n°#{i+1}</b></span>");
		bouton = Gtk::Button.new()
		bouton.set_label("Charger")
		bouton.signal_connect 'button_release_event' do |_widget|
			#puts "Chargement quickSave n°#{i+1}"
			@jeu.quicksaveCharger(i)
			majGrille()
		end
		@tQS[i] = bouton
		q.add(textBox)
		q.add(bouton)
		border.add(q)
		@saveb.add(border)
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

	def affichageChrono
		while @jeu.gagne? == true
			sleep(1)
			@timer.set_label(@chrono.getTime.strftime("%M:%S"))
		end
	end

	def pauseChrono
		@chrono.stop
	end

	def playChrono
		@chrono.play
	end

	def razChrono
		@chrono.reset
	end
end
