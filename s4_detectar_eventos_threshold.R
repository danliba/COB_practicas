###Prueba con paquete MHW: https://robwschlegel.github.io/heatwaveR/
###En este script se detectan eventos fijando un umbral (threshold) de kg pescados al d?a
#a?adiendo un segundo criterio de dias seguidos donde se cumple estre criterio

rm(list = ls())

library(dplyr)
library(readxl)
library(astsa)
library(heatwaveR)

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_ambientales/MHW/datos_capturas')


##LEO datos totales extraidos (capturas/dia(barco) promediado por dia)
data<-read_excel("datos_PUERTOS_DIA_ALL.xlsx") ##Datos diarios


data <-data %>% mutate(date=as.Date(paste0(AÑO,"-",MES,"-",DIA))) ##Transformo a fecha yy-mm-dd
data<-data %>% mutate(d=AÑO+(MES-1+DIA/31)/12)

names<-colnames(data[,4:31])
output<-list()
all.series<-matrix(data=NA,nrow=5476,ncol=28)
for (i in 1:28) {
  date<-data$date
  serie<-data %>% select(.,names[[i]]) %>% unlist(.)
  # res <- ts2clm(data,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31")) 
  output[[i]]<-exceedance(data,x=date,y=serie,below=T,threshold = 10,minDuration=5)
  # a[i]<-print(mhw)
   all.series[,i]<-output[[i]][["threshold"]][["durationCriterion"]]
}
date2<-output[[i]][["threshold"]][["date"]]
# doy2<-output[[i]]$doy
a<-as.data.frame(all.series) 
colnames(a) <- (names)
b<- a %>% mutate_if(is.logical, as.numeric) 
b$fecha<-date2
b$year=as.numeric (format(date2,"%Y"))
b$month=as.numeric (format(date2,"%m"))
b$day=as.numeric (format(date2,"%d"))

data2<-b %>% select(Águilas:Sóller) %>% as.matrix()
heatmap(data2, col = terrain.colors(256))

library(openxlsx)
write.xlsx(b, file = "D_prueba_MCS_th.xlsx")

