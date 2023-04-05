#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # get winner team names
  if [[ $WINNER != "winner" ]] # exclude column headings
  then
    TEAM_WINNER=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    # if team not found
    if [[ -z $TEAM_WINNER ]]
    then
      # insert team name from winner column
      INSERT_TEAM_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #echo inserted winner team names
      if [[ $INSERT_TEAM_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team names: Winner $WINNER
      fi
    fi
  fi
  # get opponent team names
  if [[ $OPPONENT != "opponent" ]] # exclude column headings
  then
    TEAM_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    # if team not found
    if [[ -z $TEAM_OPPONENT ]]
    then
      # insert team names from opponent column
      INSERT_TEAM_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # echo inserted opponent team names
      if [[ $INSERT_TEAM_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team names: Opponent $OPPONENT
      fi
    fi
  fi
  # insert games info into games table
  if [[ $YEAR != "year" ]] # exclude column headings
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # insert games data
    INSERT_GAMES_DATA_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    # echo inserted games info
    if [[ $INSERT_GAMES_DATA_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted games info into games table: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done
