rm(list = ls())

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_capturas/originales/')
#D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_capturas\originales
dir()

library(dplyr)
library(purrr)
library(readxl)
library(gplots)

##Leo un excel para ver info, veo columnas que me interesan
ejemplo<- read_excel("Captures comercials ARA GSA1 2001.xlsx")

# View(ejemplo)
cols<-names(ejemplo)

# [1] "PAIS"         "...2"         "DIA"          "MES"          "A?O"         
# [6] "BARCOD"       "BARDES"       "PUECOD"       "PUEDES"       "ARTCOD"      
# [11] "ARTDES"       "ORICOD"       "ORIDES"       "ESPCOD"       "ESPECIE"     
# [16] "ESPCAT"       "CATEGORIA"    "PESO VIVO"    "PRECIO MEDIO" "DIAS MAR"    
# [21] "DIAS PESCA"   "MAREAS"       "POTENCIA"     "TRB"          "RGT"         
# [26] "ESLTOT" 

cols<-cols[ -c(1, 2)]  ###Quito dos primeros


all_files <- list.files(pattern = 'Captures comercials ARA GSA1', full.names = TRUE)
#all_files<-all_files[]
GSA1 <- map_df(all_files, 
               ~.x %>% readxl::read_excel() %>% select(cols)) ##\\.xlsx$


##Exploracion de datos

# df %>% group_by(a, b) %>% summarise(n = n()).   ==count()
# barcos<-GSA1 %>% count(BARDES,A?O)
# npuertos<-GSA1 %>% group_by(PUEDES, A?O) %>% summarise(n = n())
# mpuertos<-GSA1 %>% group_by(PUEDES, A?O) %>% summarise(m = sum(`PESO VIVO`))
# mbarcos<-GSA1 %>% group_by(BARDES, A?O) %>% summarise(m = sum(`PESO VIVO`))
# 
# myear<-GSA1 %>% group_by(A?O) %>% summarise(m = sum(`PESO VIVO`))

#suma de peso vivo de la pesca por mes y por puerto
mmyear1<-GSA1 %>% group_by(AÑO,MES,PUEDES) %>% summarise(cap = sum(`PESO VIVO`)) ###SUMA capturas por mes
#suma de dias de pesca por mes y por puerto
mmyear2<-GSA1 %>% group_by(AÑO,MES,PUEDES) %>% summarise(dias= sum(`DIAS PESCA`)) ###SUMA dias trabajo por mes

cap.d<-inner_join(mmyear1,mmyear2)
cap.d$cap_d<-cap.d$cap/cap.d$dias ###CAPTURA POR DIA (por mes)
cap.d$mmy=mmyear1$AÑO+(mmyear1$MES-0.5)/12 #vector de tiempo

# nbarcos<-GSA1 %>% group_by(BARDES, A?O) %>% summarise(n = sum(`PESO VIVO`))
# puertos con mayor disponibilidad de datos
#Adra, Aguilas, Almería, Carboneras, Cartagena, Garrucha, Mazarron (2001), 
#Motril (2005)

#timeseries de la pesca de gamba roja por puerto
windows()
par(mfrow=c(1,1))
ggplot(cap.d,aes(mmy, log10(cap_d+1), group = PUEDES)) +
  geom_line()+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')

#pesca por año de gamba roja
windows()
par(mfrow=c(1,1))
ggplot(cap.d,aes(AÑO, log10(cap_d+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')

#pesca por mes de gamba roja
windows()
par(mfrow=c(1,1))
ggplot(cap.d,aes(MES, log10(cap_d+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')



## seleccionamos los puertos con mayor cantidad de datos
#Adra, Aguilas, Almería, Carboneras, Cartagena, Garrucha, Mazarron (2001), 
#Motril (2005)
cap.d[cap.d$PUEDES=='Adra',1:7]->A; #adra
cap.d[cap.d$PUEDES=='Águilas',1:7]->B; #aguilas
cap.d[cap.d$PUEDES=='Almería',1:7]->C; #almeria
cap.d[cap.d$PUEDES=='Carboneras',1:7]->D; #carboneras
cap.d[cap.d$PUEDES=='Cartagena',1:7]->E; #cartagena
cap.d[cap.d$PUEDES=='Garrucha',1:7]->H; #garrucha
cap.d[cap.d$PUEDES=='Mazarrón',1:7]->I; #mazarron


################ Ahora con GSA6 ########################################
ej2<- read_excel("Captures comercials ARA GSA6 2001.xlsx")

# View(ejemplo)
cols2<-names(ej2)
cols2<-cols2[ -c(1, 2,21)]  ###Quito dos primeros

all_GSA6 <- list.files(pattern = 'Captures comercials ARA GSA6', full.names = TRUE)
#all_files<-all_files[]
GSA6 <- map_df(all_GSA6, 
               ~.x %>% readxl::read_excel() %>% select(cols2)) ##\\.xlsx$

#GSA6_1<-read_excel(all_GSA6[7])

