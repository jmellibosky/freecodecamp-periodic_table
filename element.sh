#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  if [[ -z $ELEMENT_ID ]]
  then
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    if [[ -z $ELEMENT_ID ]]
    then
      ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    fi
  fi

  if [[ -z $ELEMENT_ID ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$($PSQL "SELECT CONCAT('The element with atomic number ', e.atomic_number, ' is ', e.name, ' (', e.symbol, '). It''s a ', t.type, ', with a mass of ', p.atomic_mass, ' amu. ', e.name, ' has a melting point of ', p.melting_point_celsius, ' celsius and a boiling point of ', p.boiling_point_celsius, ' celsius.') FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON t.type_id = p.type_id WHERE e.atomic_number = $ELEMENT_ID")"
  fi
fi
# comment to commit
