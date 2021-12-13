### SIR Model with/without vaccination 
# Assume closed, mixed population, no reinfection
# vaccinated individuals will be considered recovered


library(deSolve)
library(ggplot2)
library(reshape2)
library(shinySIR)

# data from https://www.kaggle.com/yashvi/india-covid19-analysis/data?select=covid_19_india.csv
all_india<- read.csv("~/Desktop/R/capstone/covid_19_india.csv")
names(all_india)[names(all_india) == 'State.UnionTerritory'] <- 'State'

#subset to only include Delhi
state<- all_india[all_india$State == 'Delhi',]
#change date formatting 
delhiA<- as.Date(state$Date, "%Y-%m-%d")
dates<- format(delhiA, "%d/%m/%Y")

#df of daily incidences 
delhiIncid<- data.frame(dates, c(1, diff(state$Confirmed)))
colnames(delhiIncid)[2] <- "I"
delhiIncid[367,2] <-0

plot(c(1:528), delhiIncid$I, xlab = "Days", ylab = "Incidences", main = "Daily Reported Cases of COVID in Delhi")
plot(c(1:528), deaths$deaths, xlab = "Days", ylab = "Deaths", main = "Deaths Per Day")
abline(h=13920, col = "red")

#daily deaths 
deaths<- data.frame(dates, c(1, diff(state$Deaths)))
colnames(deaths)[2]<- "deaths"
mean(deaths$deaths) #93 per day

#plot of real world cumulative cases
rlc<- data.frame(dates, state$Confirmed)
plot(1:528, rlc$state.Confirmed, xlab = "Time in Days", ylab = "Cases", main = "Real World Cummulative Cases")

#cumulative deaths
cdeath<- data.frame(dates, state$Deaths)
mean(state$Deaths) #9363 deaths

#csv of daily incidences 
incidences1<- write.csv(delhiIncid, file = "~/Desktop/R/capstone/incid2.csv", row.names = FALSE)
# getting rt values for 1st 127 days (before cases hit 100k)
rtdata<- read.csv("~/Desktop/R/capstone/EstimatedR.csv", header = TRUE)
first127<- rtdata[1:120,]
mean(first127$Mean.R) #1.32







