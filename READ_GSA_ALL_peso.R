##Replica del READ_GSA_ALL.R pero con peso en lugar de ndias
## se usará peso promedio asi como se usó dias promedio en el script anterior

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

#filtramos los barcos/puertos/ dias con capturas superiores a 50 kg 
data_peso50<-data_dia$cap>50
data_peso50 <- data_dia[data_peso50, ]

ndias_peso<-data_peso50 %>% group_by(AÑO,MES,PUEDES,BARCOD) %>% summarise(dias= n()) ###EJEMPLO: SUMA dias trabajo por mes (por barco y puerto)

## media de dias que declara gamba por a?o/barco y puerto
ydias_peso<-data_peso50 %>% group_by(AÑO,PUEDES,BARCOD) %>% summarise(dias= n()) %>% 
  group_by(PUEDES,BARCOD) %>% summarise(mdias= mean(dias)) 
orden_peso<-arrange(ydias, PUEDES, desc(mdias)) ##ordeno segun el criterio mdias




