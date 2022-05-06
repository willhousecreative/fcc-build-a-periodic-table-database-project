PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
ELEM=$1
if [[ $1 ]]
then
# get element based on the input
# echo "get element based on $1"
    #if input is not an int
    if [[ ! $1 =~ ^[0-9]+$ ]]
        then
        ELEMENT_RESULT=$($PSQL "SELECT atomic_number, 
        symbol,
        name,
        atomic_mass,
        melting_point_celsius,
        boiling_point_celsius,
        type
        FROM elements
        INNER JOIN properties USING(atomic_number)
        INNER JOIN types USING(type_id)
        WHERE symbol = '$1' OR name LIKE '%$1%' ORDER BY symbol LIMIT 1;")
        else
        # input is an int
        ELEMENT_RESULT=$($PSQL "SELECT atomic_number, 
        symbol,
        name,
        atomic_mass,
        melting_point_celsius,
        boiling_point_celsius,
        type
        FROM elements
        INNER JOIN properties USING(atomic_number)
        INNER JOIN types USING(type_id)
        WHERE atomic_number = $1 ORDER BY symbol LIMIT 1;")
    fi
  # if no element
    if [[ -z $ELEMENT_RESULT  ]]
        then
        echo "I could not find that element in the database."
        else
        # return result
        # echo $ELEMENT_RESULT
        echo "$ELEMENT_RESULT"  | while IFS="|" read AUTOMIC_NUM SYMBOL NAME ATOMIC_MASS MPC BPC TYPE
        do
        echo "The element with atomic number $AUTOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
        done
    fi
else
# no input given
echo "Please provide an element as an argument." 
fi
