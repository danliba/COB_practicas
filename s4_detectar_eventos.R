###Prueba con paquete MHW: https://robwschlegel.github.io/heatwaveR/
###En este script usamos algoritmo "normal" con climatologia y percentiles

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
# data<-data %>% rename(serie=Barcelona)    

# Creo funcion para extraer eventos extremos (picos max o minimos)
find.events <- function(x,y) {
 
  
  
    ###Buscar MHW-PICOS de capturas en nuestras series
    res_clim1 <- ts2clm(data,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31"),pctile = 90)
    out1 <- detect_event(res_clim1,x=date,y=serie)
    data.n1<-out1[["climatology"]]
    event.n1<-out1[["event"]]
    
    
    ###Buscar MCS-en este caso ser?an dias que no se pesca (Proxy de desaparici?n de gambas??)
    res_clim2 <- ts2clm(data,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31"),
                       pctile = 5)
    out2 <- detect_event(res_clim2,x=date,y=serie, coldSpells = TRUE)
    data.n2<-out2[["climatology"]]
    event.n2<-out2[["event"]]
    
    # mhw <- out1$event
    return(data.n2) #####SACO EVENTOS DE DESCENSO DE PESCA MCS
    #return(event.n2)
  }

names<-colnames(data[,4:31])
output<-list()
all.series<-matrix(data=NA,nrow=5476,ncol=28)
# loop para las series diarias
for (i in 1:28) {
  date<-data$date
  serie<-data %>% select(.,names[[i]]) %>% unlist(.)
  # res <- ts2clm(data,x=date,y=serie, climatologyPeriod = c("2005-01-03", "2019-12-31")) 
  output[[i]]<-find.events(date,serie)
  # a[i]<-print(mhw)
   all.series[,i]<-output[[i]]$event
}
####Aqui transformo en 0-1 
date2<-output[[i]]$date
doy2<-output[[i]]$doy
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
write.xlsx(b, file = "D_prueba_MCS.xlsx") ####Exporto en excel para luego plotear con MATLAB

