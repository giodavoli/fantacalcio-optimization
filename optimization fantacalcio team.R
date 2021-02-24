library(lpSolve)
library(RCurl)
library(stringr)
library(jsonlite)
library(dplyr)

#Load statistics of previous season https://www.fantacalcio.it/statistiche-serie-a/2019-20/fantacalcio/riepilogo
#and the mean price of player in auction (https://www.fantacalcio-online.com/it/asta-fantacalcio-stima-prezzi)
df=read.csv("stat_fanta_2019-2020.csv")

#delete player that didn't play in the last season
row_to_keep = which(!is.na(df$Mv))
df=df[row_to_keep,]
#delete player with NA value (i.e. players that are purchased less than 10 times)
row_to_keep = which(!is.na(df$X500K..10.))
df=df[row_to_keep,]
#delete player with less than 4 presence 
row_to_keep = which(df$Pg>4 | df$R == "P")
df=df[row_to_keep,]

###SELECT FIRST TEAM PLAYER
# Fitting Constraints
num_gk <- 1
num_def <- 3
num_mid <- 4
num_fwd <- 3
max_cost <- 450
min_pg_gk = 30
min_pg_def = 100
min_pg_mid = 120
min_pg_fwd = 100

# Create vectors to constrain by position
df$Goalkeeper <- ifelse(df$R == "P", 1, 0)
df$Defender <- ifelse(df$R == "D", 1, 0)
df$Midfielder <- ifelse(df$R == "C", 1, 0)
df$Forward <- ifelse(df$R == "A", 1, 0)

df$Pg=as.numeric(df$Pg)
df$Mf=as.numeric(df$Mf)

# The vector to optimize on
objective <- df$Mf

# next we need the constraint directions
const_dir <- c("=", "=", "=", "=", "<=", ">=",">=",">=",">=")

# Now put the complete matrix together
const_mat <- matrix(c(df$Goalkeeper, df$Defender, df$Midfielder, df$Forward, 
                      df$X500K..10.,df$Pg*df$Goalkeeper,df$Pg*df$Defender,df$Pg*df$Midfielder,df$Pg*df$Forward ), 
                    nrow=9, byrow=TRUE)
const_rhs <- c(num_gk, num_def, num_mid, num_fwd, max_cost, min_pg_gk,min_pg_def,min_pg_mid, min_pg_fwd)

# then solve the matrix
x <- lp ("max", objective, const_mat, const_dir, const_rhs, all.bin=TRUE, all.int=TRUE)

# And this is our team!
solution_first <- df %>% 
  mutate(solution_first = x$solution) %>% 
  filter(solution_first == 1) %>% 
  select(Nome, Squadra.x, Goalkeeper ,Defender,Midfielder,Forward, X500K..10., Mf,Pg) %>% 
  arrange( X500K..10.) 

print(solution_first)

solution_first %>% summarise(total_price = sum( X500K..10.)) %>% print
solution_first %>% summarise(total_points = sum(Mf)) %>% print

#delete obs of first team
row_to_keep=which(setdiff(df$Nome,solution_first$Nome)%in%df$Nome)
df=df[row_to_keep,]

###SELECT REPLACEMENT PLAYERS
# Fitting Constraints
num_gk <- 0
num_def <- 5
num_mid <- 4
num_fwd <- 3
max_cost <- 50
min_pg_gk = 0
min_pg_def = 100
min_pg_mid = 80
min_pg_fwd = 60

# Create vectors to constrain by position
df$Goalkeeper <- ifelse(df$R == "P", 1, 0)
df$Defender <- ifelse(df$R == "D", 1, 0)
df$Midfielder <- ifelse(df$R == "C", 1, 0)
df$Forward <- ifelse(df$R == "A", 1, 0)

# The vector to optimize on
objective <- df$Mf

# next we need the constraint directions
const_dir <- c("=", "=", "=", "=", "<=", ">=",">=",">=",">=")

# Now put the complete matrix together
const_mat <- matrix(c(df$Goalkeeper, df$Defender, df$Midfielder, df$Forward, 
                      df$X500K..10.,df$Pg*df$Goalkeeper,df$Pg*df$Defender,df$Pg*df$Midfielder,df$Pg*df$Forward), 
                    nrow=9, byrow=TRUE)
const_rhs <- c(num_gk, num_def, num_mid, num_fwd, max_cost, min_pg_gk,min_pg_def,min_pg_mid, min_pg_fwd)

# then solve the matrix
x <- lp ("max", objective, const_mat, const_dir, const_rhs, all.bin=TRUE, all.int=TRUE)

# And this is our team!
solution <- df %>% 
  mutate(solution = x$solution) %>% 
  filter(solution == 1) %>% 
  select(Nome, Squadra.x,Goalkeeper ,Defender,Midfielder,Forward, X500K..10., Mf,Pg) %>% 
  arrange( X500K..10.) 

print(solution)
