# sirs model with vaccination

library(ggplot2)
library(deSolve)
library(reshape2)
library(shinySIR)

N<- 31000000
state<- c(S=N-100, I= 100, R= 0)
parameters<- c(beta= 5.6e-9, gamma = 0.1, delta = 1/90)

#13,920 cases max
time<- seq(0,900, by = 1)
vac <-0
b<-0
d<-0
sirs1<- function(time, state, parameters){
  with(as.list(c(state, parameters)),{
    if(time>=0 && time <=50){
      b=.7
    }
    else if (time>=51 && time<=119){
      b=.85
    }
    else if (time>=120 && time<=200){
      b=.7 }
    else if(time >=201 && time<=269){
      b=.65 }
    else if(time>=270 && time<=300){
      b=.3
      vac = 1 }
    else if(time>=301 && time <=400){
      b= .3
      vac = 1 }
    else if(time>=401 && time<=450){
       b=1.8
       vac = 1}
    else if(time>=451 && time <=528){
      b=0.2
    }
    else {
      vac = 1
      b= 1}
    #force of infection = beta*I
    dS= -beta*I*S*b+ delta*((R/N)*.05)-52271*(S/N)*vac 
    dI= beta*I*S*b  - gamma*I 
    dR= gamma*I - delta*((R/N)*0.05) +52271*(S/N)*vac 
          
  return(list(c(dS,dI,dR)))
  })
}


#df of all data- deSolve
output<- as.data.frame(ode(y=state,
                           times = time,
                           func = sirs1,
                           parms=parameters))
#wide to long- reshape2
output<- melt(output,id.vars= "time") 

ggp<-ggplot(output, aes(x = time, y = value, color = variable, group = variable))+geom_line(size = 1.3) +
  xlab("Time(days)")+ ylab("Number Susceptible/Infected/Recovered")+ ggtitle("SIRS Model of COVID-19 Spread in Delhi With Vaccination (52,271 per day)") +
  theme(plot.title = element_text(size=22))+ 
  geom_vline(xintercept=270, linetype= "dotted", color= "orange") +
  geom_vline(xintercept= 300, linetype = "dotted", color = "purple")+
  geom_vline(xintercept= 400, linetype= "dotted", color = "black")+
  theme(legend.position = c(0.88, 0.8))+
  scale_color_discrete(name = "State", labels = c("Susceptible", "Infected", "Recovered"))
  


#zoom in 
ggp + ylim(0,10000000)
ggp + ylim(1,1200000)
ggp + ylim(1,100000)+ geom_hline(yintercept = 13920, color = "red", linetype = "dotted")+
  geom_line(data = filter(output, variable == "I"), size = 3)+
  geom_line(data = filter(output, variable == "R"), size = .001)

#log scale 
ggp1<-ggplot(output, aes(x = time, y = value, color = variable, group = variable))+geom_line() +
  scale_y_continuous(trans='log2') +
  xlab("Time(days)")+ ylab("Number Susceptible/Infected/Recovered")+ ggtitle("SIRS Model of COVID-19 Spread in Delhi on a Logarithmic Scale")

#bar plot of implied rt values
Times<- c(0, 51, 120, 201, 270, 301, 401, 451)
Rt<- c(1.2152, 1.4756,1.2152,1.1284,0.5208,0.5208, 3.1248, 0.3472)
rts<- cbind.data.frame(Times, Rt)
rtplot<- ggplot(rts, aes(x = Times, y = Rt)) + geom_bar(stat= "identity") + 
  ggtitle("Implied Rt Values of COVID19 in Delhi by Time") 


library(RColorBrewer)
coul <- brewer.pal(5, "Set2") 

rtplot<-barplot(rts$Rt, names = rts$Times, ylim= c(0,4),  col = coul, main = "Implied Rt Values of COVID19 in Delhi by Time",
        xlab = "Time (days)", ylab = "Rt Value")
text(x = rtplot, y = rts$Rt, label = rts$Rt, pos = 3, cex = 0.8, col = "red")

      
       
       

#shinySIR- ggplot matches
run_shiny(model = "SIRS", neweqns= sirs1, ics = c(S= 30999900, I = 100, R= 0),
          parm0 = c(beta = 6.5e-9, gamma = 1/10, delta = 1/90),
          parm_names = c("Transmission rate", "Recovery rate", "Loss of immunity"),
          parm_min = c(beta = 6.5e-9, gamma = 1/21, delta = 1/365),
          parm_max = c(beta = 6.5e-7, gamma = 1 , delta = 1))
#plot cumulative case counts from our model- based on default sirs
#use wide file version
output1<- as.data.frame(ode(y=state,
                           times = time,
                           func = sirs1,
                           parms=parameters))

plot(output1$time, output1$x)

output1<- output1[output1$time<= 528,]
plot(output1$time, output1$x)


