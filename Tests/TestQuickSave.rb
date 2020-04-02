require_relative "../Noyau/Jeu.rb"

=begin

j = Jeu.creer(4,3)
puts j
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_DROIT)
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_DROIT)
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_GAUCHE)
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_GAUCHE)
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_GAUCHE)
j.afficherPlateau()

puts "=================="
j.jouer(2,1,:HAUT,:CLIC_DROIT)
j.afficherPlateau()

puts j

=end

require "../Noyau/Case.rb"

j = Jeu.creer(11,7)
puts j
j.afficherPlateau()

c = 'c'

while ( c.ord() != 'e'.ord() ) do
    
    case c.ord()
        when 'u'.ord()
            j.undo()
        when 'r'.ord()
            j.redo()
        when 'q'.ord()
            j.quicksaveEnregistrer()
        when 'g'.ord()
            puts "quelle Quicksave voulez-vous charger ?"
            qc = gets

            j.quicksaveCharger( qc.to_i() )
        when 's'.ord()
            j.quicksaveChargerSafe()
        else

            puts "donner les coordonnées de la case que vous voulez jouer"
            x = gets
            y = gets

            puts "quelle ligne ? ( 0 : haut, 1 : droite, 2 : bas, 3 : gauche )"
            l = gets
            l2 = -1
            case l.to_i()
                when 0
                    l2 = :HAUT
                when 1
                    l2 = :DROITE
                when 2
                    l2 = :BAS
                when 3
                    l2 = :GAUCHE
            end

            puts "quelle clic ? ( 0 : gauche, 1 : droit )"
            s = gets

            case s.to_i()
                when 0
                    s = :CLIC_GAUCHE
                when 1
                    s = :CLIC_DROIT
            end

            j.jouer(x.to_i(),y.to_i(),l2,s)
    end

    puts "=================="
    j.afficherPlateau()

    puts "suite ? ( e : escape, c : continue, u : undo, r : redo, q : quicksave enre., g : quicksave charger, s : charger safe )"
    c = gets
end