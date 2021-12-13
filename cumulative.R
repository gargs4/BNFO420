library(ggplot2)
library(deSolve)
library(reshape2)
library(shinySIR)

N<- 31000000
state<- c(S=N-100, I= 100, R= 0, x=100)
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
      vac = 0 }
    #force of infection = beta*I
    dS= -beta*I*S*b+ delta*R-52271*(S/N)*vac 
    dI= beta*I*S*b  - gamma*I 
    dR= gamma*I - delta*R +52271*(S/N)*vac 
    dx= beta*I*S*b        #cumulative case tracker- no gamma
    list(dS,dI,dR,dx)
  })
}
#plot cumulative case counts from our model- based on default sirs
#use wide file version
output1<- as.data.frame(ode(y=state,
                            times = time,
                            func = sirs1,
                            parms=parameters))
output1<- output1[output1$time<= 528,]
plot(output1$time, output1$x, xlab="Time(days)", ylab="Cummulative Cases from SIRS Model")
