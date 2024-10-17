#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


# Truncate tables
echo $($PSQL "TRUNCATE games, teams")

# Read csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then

    # Insert a team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_STATUS=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_STATUS = "INSERT 0 1" ]] 
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
        echo Inserted into teams: $WINNER
      fi
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_STATUS=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_STATUS = "INSERT 0 1" ]] 
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
        echo Inserted into teams: $OPPONENT
      fi
    fi

    # Insert in games
    INSERT_STATUS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_STATUS = "INSERT 0 1" ]]
    then
      echo Inserted into games: $YEAR, $ROUND
    fi

  fi
done