# ggplot plot and run_shiny plot match for default sirs model
# does not include vaccines or changing Rt values yet
library(ggplot2)
library(deSolve)
library(reshape2)
library(shinySIR)

N<- 31000000
state<- c(S=N-100, I= 100, R= 0)
parameters<- c(beta= 6.5e-9, gamma = 0.1, delta = 1/90)
time<- seq(0,900, by = 1)

sir1<- function(time, state, parameters){
  with(as.list(c(state, parameters)),{
    
    #force of infection = beta*I
    dS= -beta*I*S + delta*(0.05*R)
    dI= beta*I*S  - gamma*I 
    dR= gamma*I - delta*(0.05*R)
    return(list(c(dS,dI,dR)))
  })
}
#df of all data
output<- as.data.frame(ode(y=state,
                           times = time,
                           func = sir1,
                           parms=parameters))
#wide to long
output<- melt(output,id.vars= "time") 

ggplot(output, aes(x = time, y = value, color = variable, group = variable))+geom_line() +
  
  xlab("Time(days)")+ ylab("Number Susceptible/Infected/Recovered/Dead")+ ggtitle("SIRS Model of COVID-19 Spread in Delhi Without Vaccination") +
  geom_vline(xintercept=270, linetype= "dotted", color= "orange") +
  geom_vline(xintercept= 300, linetype = "dotted", color = "purple")+
  geom_vline(xintercept= 400, linetype= "dotted", color = "black") 



#cumulative case counts from our model
isum<- output[output$variable== "I",]
isum1<- isum[isum$time <=528,]
plot(isum1$time, cumsum(isum1$value), xlab = "days", ylab="cases", main = "Cummulative Cases from SIR")

#shinySIR
run_shiny(model = "SIRS", neweqns= sir1, ics = c(S= 30999900, I = 100, R= 0),
          parm0 = c(beta = 6.5e-9, gamma = 1/10, delta = 1/90),
          parm_names = c("Transmission rate", "Recovery rate", "Loss of immunity"),
          parm_min = c(beta = 6.5e-10, gamma = 1/21, delta = 1/365),
          parm_max = c(beta = 6.5e-9, gamma = 1 , delta = 1))



