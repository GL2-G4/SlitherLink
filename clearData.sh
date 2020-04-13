#!/bin/bash

DIR=`dirname $0`

NAME_GRID_AVENTURE_VIERGE='grilleAventure Test'
NAME_GRID_AVENTURE='grilleAventure'

NAME_JOUEUR_VIERGE='joueurVierge'
NAME_JOUEUR='joueurOfficiel'


# Grilles Aventure
rm $DIR'/Grilles/'"$NAME_GRID_AVENTURE"
cp $DIR'/Grilles/'"$NAME_GRID_AVENTURE_VIERGE" $DIR'/Grilles/'"$NAME_GRID_AVENTURE"

# Joueur
rm $DIR'/Joueur/'"$NAME_JOUEUR"
cp $DIR'/Joueur/'"$NAME_JOUEUR_VIERGE" $DIR'/Joueur/'"$NAME_JOUEUR"
