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
The results for the first team that the linear solver selected, using the estimated price in a private league with 10 players and 500 Credits.

Name | Team | Goalkeeper | Defender | Midfielder | Forward | 500K(10) | Mf | Pg
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
MUSSO |  Udinese | 1 | 0 | 0 | 0 | 21.38 | 5.08 | 38
GAGLIOLO | Parma | 0 | 1 | 0 | 0 | 14.08 | 6.27 | 32
DE VRIJ | Inter |         0   |     1     |     0   |    0   |   29.25 | 6.60 | 34
GOSENS | Atalanta |         0   |     1     |     0   |    0   |   39.50 | 7.38 | 34
NAINGGOLAN | Cagliari |         0   |     0     |     1   |    0   |   24.73 | 7.19 | 26
MKHITARYAN | Roma |         0   |     0     |     1   |    0   |   41.74 | 7.59 | 22
KULUSEVSKI | Juventus |         0   |     0     |     1   |    0   |   47.23 | 7.43 | 36
LUIS ALBERTO | Lazio |         0   |     0     |     1   |    0   |   50.87 | 7.31 | 36
BERARDI | Sassuolo |         0   |     0     |     0   |    1   |   48.22 | 7.85 | 31
MURIEL  | Atalanta |         0   |     0     |     0   |    1   |   57.78 | 7.98 | 34
CAPUTO  | Sassuolo |         0   |     0     |     0   |    1   |   74.96 | 8.31 | 36

The reserve Goalkeeper will be

Name | Team | Goalkeeper | Defender | Midfielder | Forward | 500K(10) | Mf | Pg
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
SCUFFET    |  Udinese | 1 | 0 | 0 | 0 | 0 | 6.08 | 0

The remaining team is:


Name | Team | Goalkeeper | Defender | Midfielder | Forward | 500K(10) | Mf | Pg
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
GOLDANIGA   |  Genoa      |    0     |   1       |   0    |   0   |    0.49 |5.68 |13
BALDURSSON   |  Bologna      |    0     |   0       |   1    |   0   |    0.44| 5.83  |7
LAURINI  |  Parma      |    0     |   1       |   0    |   0   |    0.53  |5.73 | 15
CEPPITELLI  | Cagliari      |    0     |   1       |   0    |   0   |    1.72 |6.13 |16
DEPAOLI  |   Benevento      |    0     |   1       |   0    |   0   |    3.00 |5.78 |29
BANI  |    Parma      |    0     |   1       |   0    |   0   |    5.04 |6.19 |27
IONITA | Benevento      |    0     |   0       |   1    |   0   |    2.13 |5.66 |34
CATALDI    |  Lazio      |    0     |   0       |   1    |   0   |    1.06 |6.22 |21
BORJA VALERO  | Fiorentina     |     0    |    0      |    1   |    0  |     5.60 |6.40 |19
HARASLIN   | Sassuolo     |     0    |    0      |    0   |    1  |     0.53| 6.44 |11
PINAMONTI   |   Inter       |   0      |  0        |  0     |  1    |   5.74 |6.12 |32
CORNELIUS   |   Parma       |   0      |  0        |  0     |  1    |  17.46 |7.83 |26

### Limitations and future work
The first limitatioin of this method is that we cannot consider players from promoting team, players that are buyed in the market from different leagues and players that change team and will not perform as the previous year (i.e Naingollan and Pinamonti in 19/20 season were in loan at Cagliari and Genoa, in 20/21 season they went back to Inter where they will find less space)
Another thing that a good player would never done is having two Forward from the same team, Caputo and Berardi are probably two great (undervalued) forward but it is better to diversify our team.
It was a very funny project and I have learned a lot of things, for example the optimum solution select a balanced team and not a mediocre team with a great striker (as Ronaldo, Lukaku,...)
This work can be a guideline for your next league to see if some players are undervalued, to limitate our impatiatience during the auction. 

In the future works I intend to change the Objective function, I am trying to create a prediction of the score of each player for the next season (probably trough deep learning model as LSTM), in this way I will not relay only on the last season performance. Moreover it would be interesting try to do a reinforcement learning problem to teach an algorithm the best approach to fantasy auction.

Your team is better or worst than the one selected from the computer?
