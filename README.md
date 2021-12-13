# BNFO420
Extended SIRS Model of Delhi with Vaccination 
The following R Files are avilable in this repository:
The final paper discusing the SIRS Model of Delhi

capstone1.R: R File that cleans and subsets data taken from Kaggle (link in comments). Includes plot of daily incidences and cumulative case counts. Also includes writing out data for daily incidences.

sirOnly.R: R File that contains the first attempt at an SIR Model, a function sir1 to hold all of the parameters, time and states, which adds data to a wide file called output. output is converted to a long file and plotted using ggplot2

sirsOnly.R: R File that contains first extension to SIR model. Has reinfection parameter and uses shinySIR by Sinnead Morris to confirm the equations used. Also has hypothetical cumulative case counts. Shows model without vaccination.

sirs.R: R File of Extended SIRS Model to include vaccination at the rate seen in real life in Delhi. Extended from sirsOnly.R to include vaccine and reinfection. Uses ggplot2 to plot Model. Has limiting y-axis statements to see initial parts of the model clearly, and also has a plot with a log scale for better viewing.

higherVac.R: R File extension of sirs.R to include higher vaccination rate.

Citations:
Soetaert K, Petzoldt T, Setzer RW (2010). “Solving Differential Equations in R: Package deSolve.” Journal of Statistical Software, 33(9), 1–25. doi: 10.18637/jss.v033.i09
Wickham H (2007). “Reshaping Data with the reshape Package.” Journal of Statistical Software, 21(12), 1–20. http://www.jstatsoft.org/v21/i12/.
Wickham H (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN 978-3-319-24277-4, https://ggplot2.tidyverse.org
Morris SE (2020). shinySIR: Interactive Plotting for Mathematical Models of Infectious Disease Spread. R package version 0.1.2, https://github.com/SineadMorris/shinySIR.
