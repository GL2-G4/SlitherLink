class Sauv

    private_class_method :new

    def Sauv.recupPlateau( plateau )

        @@plateau = plateau
    end

    def Sauv.recupPartieUI( partieUI)

        @@partieUI = partieUI
    end

    def Sauv.recupInfo( mode, indexGrille)

        @@mode = mode
        @@indexGrille = indexGrille
    end

    def Sauv.enregistrer()

        path = File.expand_path(File.dirname(__FILE__))
        f = File.open(path + "/../Grilles/grilleSauv", "w")

        if ( $apprOrAdventure == 1 ) then

            f.print("V\n")
            f.print(sprintf("%d\n%d\n", @@mode, @@indexGrille))

            tailleX = @@plateau.size()
            tailleY = @@plateau[0].size()
    
            0.upto( tailleY - 1 ) { |j|
                0.upto( tailleX - 1 ) { |i|

                    if ( @@plateau[i][j].getLigne(:HAUT).etat() == :VIDE ) then

                        f.print("v")
                    elsif ( @@plateau[i][j].getLigne(:HAUT).etat() == :BLOQUE ) then

                        f.print("b")
                    else

                        f.print("p")
                    end

                    if ( @@plateau[i][j].getLigne(:DROITE).etat() == :VIDE ) then

                        f.print("v")
                    elsif ( @@plateau[i][j].getLigne(:DROITE).etat() == :BLOQUE ) then

                        f.print("b")
                    else

                        f.print("p")
                    end

                    if ( @@plateau[i][j].getLigne(:BAS).etat() == :VIDE ) then

                        f.print("v")
                    elsif ( @@plateau[i][j].getLigne(:BAS).etat() == :BLOQUE ) then

                        f.print("b")
                    else

                        f.print("p")
                    end

                    if ( @@plateau[i][j].getLigne(:GAUCHE).etat() == :VIDE ) then

                        f.print("v")
                    elsif ( @@plateau[i][j].getLigne(:GAUCHE).etat() == :BLOQUE ) then

                        f.print("b")
                    else

                        f.print("p")
                    end
                }
            }

            ptAide = @@partieUI.grilleS.pointsAide()
            temps = @@partieUI.chrono.getSec()

            f.print( sprintf("\n%d\n%d", temps, ptAide))
        else
            
            f.print("F\n")
        end

        f.close()
    end

    def Sauv.recup( gmenu)

        path = File.expand_path(File.dirname(__FILE__))
        f = File.open(path + "/../Grilles/grilleSauv", "r")

        tabFile = f.read()
        tabFile = tabFile.split("\n")
        f.close()

        if ( tabFile[0] == "V" ) then
            
            pop = Popup.new( titre:"Une partie a été sauvegardé. Voulez-vous la charger ?")
            pop.addBouton( titre:"non") {
    
                f = File.open(path + "/../Grilles/grilleSauv", "w")
                f.print("F\n")
                f.close()
                pop.destroy()
            }
            pop.addBouton( titre:"oui") {
    
                Sauv.charge( tabFile, gmenu)
                pop.destroy()
            }
            pop.run()
        end
    end

    private

    def Sauv.charge( tabFile, gmenu)

        if ( tabFile[1].to_i() == 0 ) then #aventure

            menuAvent = MenuAventure.creer( gmenu, gmenu.menu )
            grille = menuAvent.chargeurGrille.getGrilleIndex( tabFile[2][0].to_i())
            jeu = Jeu.charger(grille)

            tailleX = @@plateau.size()
            tailleY = @@plateau[0].size()
    
            0.upto( tailleY - 1 ) { |j|
                0.upto( tailleX - 1 ) { |i|

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 0] == "v" ) then

                        jeu.modifierLigne( i, j, :HAUT, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 0] == "b" ) then

                        jeu.modifierLigne( i, j, :HAUT, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :HAUT, :PLEINE)
                    end
                    
                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 1] == "v" ) then

                        jeu.modifierLigne( i, j, :DROITE, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 1] == "b" ) then

                        jeu.modifierLigne( i, j, :DROITE, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :DROITE, :PLEINE)
                    end

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 2] == "v" ) then

                        jeu.modifierLigne( i, j, :BAS, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 2] == "b" ) then

                        jeu.modifierLigne( i, j, :BAS, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :BAS, :PLEINE)
                    end

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 3] == "v" ) then

                        jeu.modifierLigne( i, j, :GAUCHE, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 3] == "b" ) then

                        jeu.modifierLigne( i, j, :GAUCHE, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :GAUCHE, :PLEINE)
                    end
                }
            }

            uiP = PartieUI.creer(gmenu, menuAvent,jeu,grille,screenG:ScreenGagne2)

            @@partieUI.chrono.addTime(  tabFile[4].to_i())
            @@partieUI.grilleS.pointsAide = tabFile[5].to_i()

            gmenu.changerMenu(uiP)

        else #apprentissage

            menuAppr = MenuApprentissage.creer( gmenu, gmenu.menu )
            grille = menuAppr.chargeurGrille.getGrilleIndex( tabFile[2][0].to_i())
            jeu = Jeu.charger(grille)

            tailleX = @@plateau.size()
            tailleY = @@plateau[0].size()
    
            0.upto( tailleY - 1 ) { |j|
                0.upto( tailleX - 1 ) { |i|

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 0] == "v" ) then

                        jeu.modifierLigne( i, j, :HAUT, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 0] == "b" ) then

                        jeu.modifierLigne( i, j, :HAUT, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :HAUT, :PLEINE)
                    end
                    
                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 1] == "v" ) then

                        jeu.modifierLigne( i, j, :DROITE, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 1] == "b" ) then

                        jeu.modifierLigne( i, j, :DROITE, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :DROITE, :PLEINE)
                    end

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 2] == "v" ) then

                        jeu.modifierLigne( i, j, :BAS, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 2] == "b" ) then

                        jeu.modifierLigne( i, j, :BAS, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :BAS, :PLEINE)
                    end

                    if ( tabFile[3][i * 4 + j * tailleX * 4 + 3] == "v" ) then

                        jeu.modifierLigne( i, j, :GAUCHE, :VIDE)
                    elsif ( tabFile[3][i * 4 + j * tailleX * 4 + 3] == "b" ) then

                        jeu.modifierLigne( i, j, :GAUCHE, :BLOQUE)
                    else

                        jeu.modifierLigne( i, j, :GAUCHE, :PLEINE)
                    end
                }
            }

            uiP = PartieUI.creer(gmenu, menuAppr,jeu,grille,screenG:ScreenGagne2)

            @@partieUI.chrono.addTime(  tabFile[4].to_i())
            @@partieUI.grilleS.pointsAide = tabFile[5].to_i()

            gmenu.changerMenu(uiP)
        end
    end
end