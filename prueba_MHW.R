###Prueba con paquete MHW: https://robwschlegel.github.io/heatwaveR/

rm(list = ls())

library(dplyr)
library(readxl)
library(astsa)
library(heatwaveR)

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_capturas/originales2')

##LEO datos totales extraidos (capturas/dia(barco) promediado por mes)
#data<-read_excel("prueba_daily.xlsx") ##Datos diarios
data<-read_excel("datos_PUERTOS_DIA_ALL.xlsx",sheet='capturas',guess_max = 100000) ##Datos diarios

data <-data %>% mutate(date=as.Date(paste0(AÑO,"-",MES,"-",DIA))) ##Transformo a fecha yy-mm-dd
data<-data %>% mutate(d=AÑO+(MES-1)/12+DIA/30)
                    
      

##Filling gaps with this part                   
# 
# library(pastecs) ##Siguiendo Buttay et al. 2020 This method provides a linear interpolation considering all observations located at the vicinity (i.e., within 2 time-steps) of the missing observation
# # Para GSA1
# data.m <- regul(data$d, data$Blanes,deltat=1/365,units="year",rule=30,methods=c("l"))
# ym<-(data.m[["x"]])
# 
# data<-cbind(data,data.m[["y"]]) ç
names<-colnames(data[-c(1,2,3,51,52)])
ports<-data[-c(1,2,3)]

mhw <- vector("list", length = 47)
mcs<-vector("list", length = 47)

for(i in 1:47){
###Hacer climatolog?a con serie de datos #climatología diaria
res <- ts2clm(ports,x=date,y=ports[[i]], climatologyPeriod = c("2005-01-03", "2019-12-31")) 
#print(names[i])
###Plot climatologia y scatter de datos en bruto
plot(res$doy,res$seas,ylim=c(0,150),pch="-", col='red')
points(res$doy,res$`[[`,pch="+") 

###Buscar MHW
res_climMHW <- ts2clm(res,x=date,y=res$`[[`, climatologyPeriod = c("2005-01-03", "2019-12-31"),pctile = 90) 
print(names[i])
out_MHW <- detect_event(res_climMHW,x=date,y=res_climMHW$`$`)
data.n<-out_MHW[["climatology"]]
event.n<-out_MHW[["event"]]
mhw[[i]]<- out_MHW$event



###Buscar MCS
res_climMCS <- ts2clm(res,x=date,y=res$`[[`, climatologyPeriod = c("2005-01-03", "2019-12-31"),
                   pctile = 10)
out_MCS <- detect_event(res_climMCS,x=date,y=res_climMHW$`$`, coldSpells = TRUE)
data.nMCS<-out_MCS[["climatology"]]
event.n<-out_MCS[["event"]]

mcs[[i]] <- out_MCS$event

}


library(ggplot2)

# Height of lollis represent event durations and their colours
# are mapped to the events' cumulative intensity:
ggplot(mhw[[3]], aes(x = date_peak, y = duration)) +
  geom_lolli(aes(colour = intensity_cumulative)) +
  scale_color_distiller(palette = "Spectral", name = "Cumulative \nintensity") +
  xlab("Date") + ylab("Event duration [days]")

ggplot(mhw[[3]], aes(x = date_peak, y = duration)) +
  geom_lolli(n = 3, colour_n = "red") +
  scale_color_distiller(palette = "Spectral") +
  xlab("Peak date") + ylab("Event duration [days]")

## mcs
ggplot(mcs[[3]], aes(x = date_peak, y = duration)) +
  geom_lolli(aes(colour = intensity_cumulative)) +
  scale_color_distiller(palette = "Spectral", name = "Cumulative \nintensity") +
  xlab("Date") + ylab("Event duration [days]")

ggplot(mcs[[3]], aes(x = date_peak, y = duration)) +
  geom_lolli(n = 3, colour_n = "red") +
  scale_color_distiller(palette = "Spectral") +
  xlab("Peak date") + ylab("Event duration [days]")








