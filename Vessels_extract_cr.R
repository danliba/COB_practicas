#working directory
rm(list = ls())

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_capturas/originales2/originales')


# librerías:
library(PerformanceAnalytics) # Para chart.Correlation
library(readxl)
library(plyr) # para revalue
library(carData)# para effect
library(lattice)
#lattice::trellis.par.set(effectsTheme()) # para effect
library(effects) # para effect
library(ggplot2)
library(Hmisc)
library(MASS) # PARA fitdistr
library(carData)
library(car) # para qqp
library(fitdistrplus) # PARA fitdistr
library(emmeans)
library(scales) #para scales del ggplot
library(ggpubr) # para ggarrange
###

#GSA1_DATA1 <- read.csv(file = "GSA1.csv",header = TRUE,sep = ";",dec =",")
#GSA1_DATA1<-read.csv("C:/Users/cristina.gonzalez/Desktop/CPUEs_standarizacion/datos_pesca_comercial/Captura
#comerciales _Gamb_2001_2021_puertos_elegidos.csv",header=T, sep = ";")
GSA1_DATA1<-read_excel("GSA1_all.xlsx")

selected_columns <-
c("AÑO","BARDES","BARCOD","PUECOD","PUEDES","ESPECIE","PESO VIVO","MAREAS","POTENCIA","TRB","RGT","ESLTOT")

#AÑO, BARDES, BARCOD, PUECOD, PUEDES, ESPECIE, PESO VIVO, MAREAS, POTENCIA, TRB,ESLTOT  
GSA1_DATA2 <- GSA1_DATA1[, which(names(GSA1_DATA1) %in% selected_columns)]
## now we rename the column names 
colnames <-c("year","vessel","vessel_name","port_cod","port","especie","total_catch","trips","hp","trb","grt","size_tot")

names(GSA1_DATA2)<-colnames
## 
GSA1_DATA2$year<-as.numeric(GSA1_DATA2$year)
GSA1_DATA2$vessel<-as.numeric(GSA1_DATA2$vessel)
GSA1_DATA2$vessel_name<-as.factor(GSA1_DATA2$vessel_name)
GSA1_DATA2$port_cod<-as.numeric(GSA1_DATA2$port_cod)
GSA1_DATA2$port<-as.factor(GSA1_DATA2$port)
GSA1_DATA2$total_catch<-as.numeric(GSA1_DATA2$total_catch)
GSA1_DATA2$trips<-as.numeric(GSA1_DATA2$trips)
GSA1_DATA2$hp<-as.numeric(GSA1_DATA2$hp)
GSA1_DATA2$trb<-as.numeric(GSA1_DATA2$trb)
GSA1_DATA2$grt<-as.numeric(GSA1_DATA2$grt)
GSA1_DATA2$size_tot<-as.numeric(GSA1_DATA2$size_tot)

#==========================================================================================
####vessel_cat######
# CREATE vessel_catfrom script GSA1_2_fleet_groups.R     tamaño de los
#barcos puesto en 4 grupos

GSA1_DATA2$vessel_cat <- cut(GSA1_DATA2$size_tot,
                  breaks = quantile(GSA1_DATA2$size_tot, c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE),
                  labels = c("1", "2", "3", "4"),
                  right = FALSE,
                  include.lowest = TRUE)

GSA1_DATA2$capture_cat<-cut(GSA1_DATA2$size_tot,
                        breaks = quantile(GSA1_DATA2$total_catch, c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE),
                        labels = c("1", "2", "3", "4"),
                        right = FALSE,
                        include.lowest = TRUE)

head(GSA1_DATA2) #str(GSA1_DATA3)# los  nuevas columnas son fractores
summary(GSA1_DATA2)

#==========================================================================================
#split data frames of Parapenaeus plot de especie con barcos y capturas
##########GSA1_gamba###################

plot(GSA1_DATA2$capture_cat, main='Captura Total por cuartil', ylab='Capturas')#captura total en todos los puertos de la GSA1
plot(GSA1_DATA2$vessel_cat,GSA1_DATA2$total_catch,
     ylim = c(min(GSA1_DATA2$total_catch), 300),xlab='Vessel_cat',ylab='Total_Catch')#, xaxt="n")
# Cambiar los ticks del eje x
#axis(1, at = c(1, 2, 3, 4), labels = c("0.25", "0.5", "0.75", "1"))

GSA1_gam <- GSA1_DATA2[which(GSA1_DATA2$especie=="Aristeus antennatus"),]

portnames<-unique(GSA1_DATA2$port)
wd=700; ht=900;

png(file = portnames[1], width = wd, height = ht)
par(mfrow = c(1, 1),cex.main = 2,cex.axis = 1.8,cex.lab = 1.8)
GSA1_al <- GSA1_DATA2[which(GSA1_DATA2$port==portnames[1]),]
plot(GSA1_al$capture_cat, main=portnames[1], ylab='Capturas')#captura total en todos los puertos de la GSA1
dev.off()

## separamos por puerto para sacar las 

plot(GSA1_gam$vessel_cat)

ggplot(GSA1_DATA2, aes(capture_cat,total_catch)) +
  geom_point() +
  facet_wrap(~port)

ggplot(GSA1_DATA2, aes(vessel_cat,total_catch)) +
  geom_point() +
  facet_wrap(~port)

summary(GSA1_gam)
#save data. Repeat each time you create a new data set
#save(GSA1_DATA1,GSA1_DATA3,file = "SCRIPT1.RData")


#  How to clasify vessels by size regarding the quantiles. Create vessel_cat
#  1. OBSERVE CORRELATIONS BETWEEN VESSEL CHARACTERISTICS.
#  2. SELECT THE "BEST" VARIABLE TO REPRESENT FISHING POWER (THE BEST
#USUALLY CAN BE THE MOST RELIABLE AND AVAILABLE)
#  3. CREATE CATEGORIES BASED IN THE SELECTED VARIABLE
#  4. ALSO PCA CAN BE USED WHEN MANY VARIABLES ARE AVAILABLE

# final selected variable:  hp, grt, size_tot=vessel_cat
# CREATE CATEGORIES

GSA1_gam$hp_cat <- cut(GSA1_gam$hp,
                            breaks = quantile(GSA1_gam$hp, c(0,
0.25, 0.5, 0.75, 1),na.rm = TRUE),
                            labels = c("1", "2", "3", "4"),
                            right  = FALSE,
                            include.lowest = TRUE)

GSA1_gam$grt_cat <- cut(GSA1_gam$grt,
                             breaks = quantile(GSA1_gam$grt, c(0,
0.25, 0.5, 0.75, 1),na.rm = TRUE),
                             labels = c("1", "2", "3", "4"),
                             right  = FALSE,
                             include.lowest = TRUE)




# Number of vessels per year.
# TO AVOID OPPORTUNISTIC VESSELS INTRODUCING NOISE IN THE STANDARIZATION
# THE CATCHES OF THE GROUP OF SELECTED VESSELS MUST BE REPRESENTATIVE OF
#TOTAL CATCHES
GSA1_an_sar <- GSA1_gam # select only sardine and anchovy from the fleet
summary(GSA1_an_sar)
table(GSA1_an_sar$vessel,GSA1_an_sar$year) # number of observation of
#each vessel each year


# vessels per year.
vessel_year_names <- c("year","vessel") # select columns vessel and year
v_y  <- GSA1_an_sar[,which(names(GSA1_an_sar)%in%vessel_year_names)] #
#select only vessels fishing gamba
v_y$vessel  <-  as.numeric(as.character(v_y$vessel)) ####
v_y$year  <-  as.numeric(as.character(v_y$year))
#summary(v_y)
a  <-  v_y[!duplicated(v_y), ] # eliminate duplicated vessel
#observations each year
class(a)
names(a)
a
summary(a)
table(a)
# table(a)  0,1 table of no/yes presence data
# margin.table, margin = 2: sum by rows the 1´s of year of presence

GSA1_n_v_y <- data.frame(margin.table(table(a),margin = 2)) # frecuency
#of vessel each year
names(GSA1_n_v_y)  <- c("vessel","nyear")  #nyear is the frecuency
summary(GSA1_n_v_y)

#==========================================================================================
# SECTION: select vessel more than 4 years in the gamba fishery
# select a threshold of 4 years in the fishery to avoid opportunistic
#behaviour

GSA1_select_vessels <- GSA1_n_v_y[which(GSA1_n_v_y$nyear>4),1] # select
#vessel more than 4 year
GSA1_an_sar_sel_ves <-
GSA1_an_sar[which(GSA1_an_sar$vessel%in%GSA1_select_vessels),] # data
#corresponding to the selected vessels

summary(GSA1_an_sar_sel_ves)
#==========================================================================================
# SECTION: proportion of catches of selected vessels
# VALIDATE THAT THE SELECTED VESSELS HAVE THE MAIN PROPORTION OF TOTAL
#CATCHES

sum(GSA1_an_sar_sel_ves$total_catch)/sum(GSA1_an_sar$total_catch)
#0.9098955
#my run 0.9196316
