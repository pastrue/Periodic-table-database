#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ $1 ]]
  then
   if [[ ! $1 =~ ^[0-9]+$ ]]
      then
        QUERY=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties inner join elements using(atomic_number) inner join types using(type_id) where elements.name like '$1%' order by atomic_number limit 1")
      else
      QUERY=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type FROM properties inner join elements using(atomic_number) inner join types using(type_id) where elements.atomic_number=$1")
   fi
    if [[ -z $QUERY ]]
        then
          echo "I could not find that element in the database."
        else
         echo $QUERY | while IFS=' | ' read AN AM MP BP SY NAME TYPE
            do
             echo "The element with atomic number $AN is $NAME ($SY). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
            done
    fi 
   else
   echo "Please provide an element as an argument."
fi   