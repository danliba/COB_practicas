rm(list = ls())

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_capturas/originales2')

##Script para leer todos los excel, extraigo dias de pesca por a?o para barco de cada puerto,
# me quedo con barcos que superen un umbral de dias y posteriormente filtro y me quedo solo los barcos
# que nos interesen

library(dplyr)
library(purrr)
library(readxl)
library(ggplot2)

##Leo un excel para ver info, veo columnas que me interesan
ejemplo<- read_excel("originales/Captures comercials ARA GSA1 2001.xlsx")

# View(ejemplo)
cols<-names(ejemplo)

# [1] "PAIS"         "...2"         "DIA"          "MES"          "A?O"         
# [6] "BARCOD"       "BARDES"       "PUECOD"       "PUEDES"       "ARTCOD"      
# [11] "ARTDES"       "ORICOD"       "ORIDES"       "ESPCOD"       "ESPECIE"     
# [16] "ESPCAT"       "CATEGORIA"    "PESO VIVO"    "PRECIO MEDIO" "DIAS MAR"    
# [21] "DIAS PESCA"   "MAREAS"       "POTENCIA"     "TRB"          "RGT"         
# [26] "ESLTOT" 

cols<-cols[ -c(1, 2)]  ###Quito dos primeros

##Leo todos los archivos  del pattern y selecciono columnas, filtro por c?digo de arte de pesca de arrastre=100
all_files <- list.files('originales/', pattern = 'Captures comercials ARA GSA', full.names = TRUE)
GSA <- map_df(all_files, 
               ~.x %>% readxl::read_excel() %>% select(cols) %>% filter(ARTCOD=="'100")) ##\\.xlsx$
###SUMA capturas por dia (en excel nuevos hay varios reports por dia-diferentes categorias)
data_dia<-GSA %>% group_by(AÑO,MES,DIA,PUEDES,BARCOD) %>% summarise(cap = sum(`PESO VIVO`)) 

ndias<-data_dia %>% group_by(AÑO,MES,PUEDES,BARCOD) %>% summarise(dias= n()) ###EJEMPLO: SUMA dias trabajo por mes (por barco y puerto)

## media de dias que declara gamba por a?o/barco y puerto
ydias<-data_dia %>% group_by(AÑO,PUEDES,BARCOD) %>% summarise(dias= n()) %>% 
  group_by(PUEDES,BARCOD) %>% summarise(mdias= mean(dias)) 
orden<-arrange(ydias, PUEDES, desc(mdias)) ##ordeno segun el criterio mdias

##Me quedo con los barcos (por puerto) que trabajen (que declaren) gambas a partir de cierto n? de d?as
filt<-orden%>%group_by(PUEDES) %>% filter(.,mdias>120) #%>% Puede ser 90,120,150...

barcos<-unique(filt$BARCOD) ##Extraigo c?digos de los barcos que cumplen el requisito
#123 barcos seleccionados

##Filtro ahora TODOS los datos y me quedo s?lo con barcos que interesan
filt2<-data_dia %>% filter(BARCOD %in% (barcos)) 

## ahora con Barcos filtro en data_dia, los que tienen >120 dias y >50kg
data_peso_barco <- data_dia %>% 
  filter(BARCOD %in% (barcos), cap > 50) ## barcos >120 días y >50kg 


dmyear1<-filt2 %>% group_by(AÑO,MES,DIA,PUEDES) %>% summarise(cap = sum(cap)) ###SUMA capturas por dia
dmyear2<-filt2  %>% group_by(AÑO,MES,DIA,PUEDES) %>% summarise(n= n()) ###SUMA barcos trabajo por dia
cap.d<-inner_join(dmyear1,dmyear2)
cap.d$cap_d<-cap.d$cap/cap.d$n ###CAPTURA POR DIA/n? barcos


cmyear<-cap.d %>% group_by(AÑO,MES,PUEDES) %>% summarise(cap = mean(cap_d)) ### capturas por dia
nmyear<-cap.d %>% group_by(AÑO,MES,PUEDES) %>% summarise(nbarcos = mean(n)) ###barcos  por dia


# nbarcos<-filt2  %>% group_by(A?O,MES,DIA,PUEDES) %>% summarise(n = unique(BARCOD)) %>% summarise(n = n()) ###Numero de barcos
cmyear$mmy=cmyear$AÑO+(cmyear$MES-0.5)/12 ##A?os con decimal para el plot
nmyear$mmy=cmyear$mmy


##Series en bruto

ggplot(cmyear,aes(mmy, log10(cap+1), group = PUEDES)) +
  geom_line()+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day barco')


###Series agrupadas por a?o
windows()
par(mfrow=c(1,1))
ggplot(cmyear,aes(AÑO, log10(cap+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day barco')

##Serie estacional capturas
ggplot(cmyear,aes(MES, log10(cap+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'mes', y = 'Catches/day barco')

#N? barcos 
ggplot(nmyear,aes(mmy, nbarcos, group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'n? barcos')

##N? Barcos estacional
ggplot(nmyear,aes(MES, nbarcos, group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'n? barcos')

library(tidyverse)
# wide<-cap.d %>%group_by(PUEDES,A?O, MES,cap,dias,mmy,n) %>%  pivot_wider(names_from = PUEDES, values_from = cap_d)
#
wide.c<-cmyear %>%  pivot_wider(id_cols=c('AÑO','MES','mmy'),names_from = PUEDES, values_from = cap)
wide.n<-nmyear %>%  pivot_wider(id_cols=c('AÑO','MES','mmy'),names_from = PUEDES, values_from = nbarcos)


library(openxlsx)
##Guardo datos por mes
dataset_names <- list('capturas' = wide.c, 'barcos' = wide.n)
write.xlsx(dataset_names, file = "datos_PUERTOS_MES.xlsx")

###Para guardar datos por d?as
wided.c<-cap.d %>%  pivot_wider(id_cols=c('AÑO','MES','DIA'),names_from = PUEDES, values_from = cap_d)
wided.n<-cap.d %>%  pivot_wider(id_cols=c('AÑO','MES','DIA'),names_from = PUEDES, values_from = n)

##Guardo datos por mes
dataset_names <- list('capturas' = wided.c, 'barcos' = wided.n)
write.xlsx(dataset_names, file = "datos_PUERTOS_DIA.xlsx")

