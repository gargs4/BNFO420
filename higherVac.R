library(ggplot2)
library(deSolve)
library(reshape2)
library(shinySIR)

N<- 31000000
state<- c(S=N-100, I= 100, R= 0)
parameters<- c(beta= 5.6e-9, gamma = 0.1, delta = 1/90)

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
      vac = 3.33
    }
    else if(time>=301 && time <=400){
      b= .3
      vac = 3.33
    }
    else if(time>=401 && time<=450){
      b=1.8
      vac = 3.33
    }
    else if(time>=451 && time <=528){
      b=0.2
      vac = 3.33
    }
    else {
      vac = 3.33
      b= 1}
    #force of infection = beta*I
    dS= -beta*I*S*b+ delta*R-52271*(S/N)*vac 
    dI= beta*I*S*b  - gamma*I 
    dR= gamma*I - delta*R +52271*(S/N)*vac 
    
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

ggp<-ggplot(output, aes(x = time, y = value, color = variable, group = variable))+geom_line() +
  xlab("Time(days)")+ ylab("Number Susceptible/Infected/Recovered")+ ggtitle("SIRS Model of COVID-19 Spread in Delhi With A 3.33x Vaccination Rate")+
  geom_vline(xintercept=270, linetype= "dotted", color= "orange") +
  geom_vline(xintercept= 300, linetype = "dotted", color = "purple")+
  geom_vline(xintercept= 400, linetype= "dotted", color = "black")


#zoom in 
ggp + ylim(0,10000000)
ggp + ylim(1,1200000)
ggp + ylim(1,50000) + geom_hline(yintercept= 16436, linetype = "dotted", color = "magenta")
