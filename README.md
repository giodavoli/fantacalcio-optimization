# optimization-fantacalcio

### Aim
The aim of this project is to find the best possible Fantacalcio(*Serie A Fantasy Football*) team given performance of players from last year.
The idea and the core of this code is taken by the project [fantasy_football_optimiser](https://github.com/martineastwood/penalty/tree/master/fantasy_football_optimiser#optimising-fantasy-football-teams-using-linear-programming) written by Martin Astwood.

I tried to replicate this metodology in Serie A league, making the appropriate changes.
To perform the analysis I

### Fantacalcio vs Fantasy PL
The main difference between *Fantacalcio* and *Fantasy PL* is the price of player. In italy Fantacalcio is played between friends in private league, the player prices are not choosen by the system, but by an **auction**. The auction is for sure the most intense part of the Fantacalcio, and this gave me a lot of problem to think how to evaluate the players given that every private league as different prices resulting from every league auction. Finally I decided (for now) to use an [Estimation of Fantasy Football Auction Prices](https://www.fantacalcio-online.com/it/asta-fantacalcio-stima-prezzi)

Also the allocation system is different, the action in *Fantacalcio* that give points are much less than in *Fantasy PL*. The editorial board (Fantagazzetta, Fantacalcio.it,...) assign a grade to each player given their performance. The grades goeas from 1 to 10. To this grade it is added up the bonus or malus points in the following way:
  * 3 points for each goal scored 
  * 1 points for each assist
  * 3 ponts for each penalty save
  * -3 ponts for each penalty miss
  * -0.5 for each yellow card
  * -1 for each red card
  * -2 for each own goal
  
In the auction every partecipant select a fantasy football squad of 25 players, consisting of:

* 3 Goalkeepers
* 8 Defenders
* 8 Midfielders
* 6 Forwards

### Dataset
I created the dataset by merging the [Fantacalcio statistics 19/20](https://www.fantacalcio.it/statistiche-serie-a/2019-20/fantacalcio/riepilogo) with the [Estimation of Fantasy Football Auction Prices](https://www.fantacalcio-online.com/it/asta-fantacalcio-stima-prezzi). The first dataset can be easily downloaded , for the second I had to webscrape the data.

### Constraint
The constraints for this linear optimization are:
* **Budget constraint**, in every league you can select the number of credits you start with. I decided to use the most common starting amount that is 500. I split my budget in two part 450 credits to get the first choice team and 50 credits for replacement player
* **The number of players** 3Gk, 8Df, 8Md, 6Fw. I decide to costruct my first team as 1-3-4-3. The remaining players I decided to get in the second optimization problem for replacement: 5Df, 4Md and 3Fw. The goalkeeper selected are from the same team of the first choice goalkeeper, in this way we are sure to have always one goalkeep in the field.
* **Min games played**, The first team must cover the most of the games. Ideally players that have played often last year will play as fisrt choice also in the next season.

### Objective function
Our aim is to maximize the number of points the team is worth, so the sum of the mean Fantasy points that each player does by game, within the constraints we are setting.

### Results
