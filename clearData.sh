#!/bin/bash

DIR=`dirname $0`

NAME_GRID_AVENTURE_VIERGE='grilleAventure Test'
NAME_GRID_AVENTURE='grilleAventure'

NAME_GRID_APPRENTISSAGE_VIERGE='grilleApprentissage copy'
NAME_GRID_APPRENTISSAGE='grilleApprentissage'

NAME_CHALLENGE_VIERGE='challenges copy.json'
NAME_CHALLENGE='challenges.json'

NAME_JOUEUR_VIERGE='joueurVierge'
NAME_JOUEUR='joueurOfficiel'


# Grilles Aventure
rm $DIR'/Grilles/'"$NAME_GRID_AVENTURE"
cp $DIR'/Grilles/'"$NAME_GRID_AVENTURE_VIERGE" $DIR'/Grilles/'"$NAME_GRID_AVENTURE"

# Grilles Apprentissage
rm $DIR'/Grilles/'"$NAME_GRID_APPRENTISSAGE"
cp $DIR'/Grilles/'"$NAME_GRID_APPRENTISSAGE_VIERGE" $DIR'/Grilles/'"$NAME_GRID_APPRENTISSAGE"

# Challenge
rm $DIR'/Grilles/'"$NAME_CHALLENGE"
cp $DIR'/Grilles/'"$NAME_CHALLENGE_VIERGE" $DIR'/Grilles/'"$NAME_CHALLENGE"

# Joueur
rm $DIR'/Joueur/'"$NAME_JOUEUR"
cp $DIR'/Joueur/'"$NAME_JOUEUR_VIERGE" $DIR'/Joueur/'"$NAME_JOUEUR"
