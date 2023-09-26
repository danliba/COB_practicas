###Prueba con paquete MHW: https://robwschlegel.github.io/heatwaveR/

rm(list = ls())

library(dplyr)
library(readxl)
library(astsa)
library(heatwaveR)


##LEO datos totales extraidos (capturas/dia(barco) promediado por mes)
data<-read_excel("prueba_daily.xlsx") ##Datos diarios

data <-data %>% mutate(date=as.Date(paste0(A?O,"-",MES,"-",DIA))) ##Transformo a fecha yy-mm-dd
data<-data %>% mutate(d=A?O+(MES-1)/12+DIA/30)
data<-data %>% rename(serie=Barcelona)                  
      

##Filling gaps with this part                   
# 
# library(pastecs) ##Siguiendo Buttay et al. 2020 This method provides a linear interpolation considering all observations located at the vicinity (i.e., within 2 time-steps) of the missing observation
# # Para GSA1
# data.m <- regul(data$d, data$Blanes,deltat=1/365,units="year",rule=30,methods=c("l"))
# ym<-(data.m[["x"]])
# 
# data<-cbind(data,data.m[["y"]]) 

###Hacer climatolog?a con serie de datos
res <- ts2clm(data,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31")) 

###Plot climatologia y scatter de datos en bruto
plot(res$doy,res$seas,ylim=c(0,150),pch="-", col='red')
points(res$doy,res$serie,pch="+") 

###Buscar MHW-PICOS de capturas en nuestras series
res_clim <- ts2clm(res,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31"),pctile = 90)
out <- detect_event(res_clim,x=date,y=serie)
data.n<-out[["climatology"]]
event.n<-out[["event"]]


###Buscar MCS-en este caso ser?an dias que no se pesca (Proxy de desaparici?n de gambas??)
res_clim <- ts2clm(res,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31"),
                   pctile = 10)
out <- detect_event(res_clim,x=date,y=serie, coldSpells = TRUE)
data.n<-out[["climatology"]]
event.n<-out[["event"]]

mhw <- out$event
library(ggplot2)

# Height of lollis represent event durations and their colours
# are mapped to the events' cumulative intensity:
ggplot(mhw, aes(x = date_peak, y = duration)) +
  geom_lolli(aes(colour = intensity_cumulative)) +
  scale_color_distiller(palette = "Spectral", name = "Cumulative \nintensity") +
  xlab("Date") + ylab("Event duration [days]")

ggplot(mhw, aes(x = date_peak, y = duration)) +
  geom_lolli(n = 3, colour_n = "red") +
  scale_color_distiller(palette = "Spectral") +
  xlab("Peak date") + ylab("Event duration [days]")
