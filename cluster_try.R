rm(list = ls())
library(dplyr)
library(readxl)
library(vegan)
library(ade4)

#setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/')

#vort<-read_excel('datos_ambientales/vorticidad/mar_balear.xlsx','medit_yr')
#vort2<-read_excel('datos_ambientales/vorticidad/mar_balear.xlsx','vel_yr') #velocidad m/s
#sst<-read_excel('datos_ambientales/clorofila/satelite_GFCM_Medit.xlsx','SST_yr')
#chlor<-read_excel('datos_ambientales/clorofila/satelite_GFCM_Medit.xlsx','CHL_yr')
#hloss<-read_excel('datos_ambientales/heatloss/daily/HL.xlsx','anual')

pesca<-read_excel('datos_capturas/originales2/datos_PUERTOS_MES.xlsx','barcos_yr')
data1<-read_excel('datos_capturas/originales2/datos_PUERTOS_MES.xlsx','barcos_yr')

#data1<-read_excel("base_datos_fiscos.xlsx", sheet = "pesca")

data_clust<-data1[,4:length(data1)]
View(data_clust)
labs=names(data_clust)
data_clust<-t(data_clust)
row.names(data_clust)<-c(2001:2021)

datalt_clust<-log(data_clust+1)
plot(datalt_clust) 

#step 4
#Calculate the matrix of association using the coefficient
#matdist<-as.dist(datalt)

matdist<-vegdist(datalt_clust,method='euclidian',na.rm = TRUE)

LS<-hclust(matdist,method = 'single')
LC<-hclust(matdist,method='complete')
GA<-hclust(matdist,method='average')

par(mfrow=c(1,3))
plot(LS,ylab='Euclidian Method',
     xlab='stations',main='Single linkage')
#abline(b=0,a=0.15,col='red')

plot(LC,ylab='Euclidian Method',
     xlab='stations',main='Complete linkage')
#abline(b=0,a=0.15,col='red')

plot(GA,ylab='Euclidian Method',
     xlab='stations',main='Group Average linkage')
#abline(b=0,a=0.15,col='red')

groupe<-cutree(GA,4);groupe