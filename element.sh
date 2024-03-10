#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# function to print message when element is found
PRINT_ELEMENT_INFO () {
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1;")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1;")
  ELEMENT_TYPE=$($PSQL "SELECT t.type FROM properties p LEFT JOIN types t USING(type_id) WHERE atomic_number=$1;")
  ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1;")
  ELEMENT_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1;")
  ELEMENT_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1;")
  echo "The element with atomic number $1 is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
}

# check to see variable provided
if [[ -z $1 ]]
then
  # message if not variable provided
  echo "Please provide an element as an argument."

# check if input is number
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database"
  else
    PRINT_ELEMENT_INFO $ATOMIC_NUMBER
  fi

# else, check if input equal to any symbol or name
else
  # test to see if input is equal to known element (symbol or name)
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1';")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    PRINT_ELEMENT_INFO $ATOMIC_NUMBER
  fi
fi