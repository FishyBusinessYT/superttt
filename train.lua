--- Instantiate a generation of bots, all with variations in their eval funcs
--- Store them in a table with their score (+1 for won games, -1 for lost games)
--- Pit them against each other a couple of times:
---     Sort the table by score (maybe try to shuffle players with the same score)
---     Player 1 plays against player 2, player 3 against player 4, and so on
--- Pick the top 20-30% and use them to create the next generation
--- Repeat

--- Use coroutines to play all the matches for a little extra speed
