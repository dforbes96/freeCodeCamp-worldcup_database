#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  if [[ $YEAR != "year" ]]
  then
    #check if winning team is already in the database
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if team not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
      then
        echo Added $WINNER to worldcup DB
      fi

    fi

    #set winning_id to copy team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #check if opposing team is already in the database
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if team not found
    if [[ -z $TEAM_ID ]]
    then

      #insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

        if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
        then
          echo Added $OPPONENT to worldcup DB
        fi

    fi

    #set opponent_id to copy team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #insert data from the round into database
    INSERT_MATCH=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
      VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_MATCH == "INSERT 0 1" ]]
    then
      echo $YEAR $ROUND match has been added to worldcup DB
    fi


  fi

done
