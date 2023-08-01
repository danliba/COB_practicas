rm(list = ls())

library(dplyr)
library(purrr)
library(readxl)
library(ggplot2)
#install.packages("writexl")
library(writexl)

##Leo un excel para ver info, veo columnas que me interesan
setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/datos_capturas/originales2/originales')
ejemplo<- read_excel("Captures comercials ARA GSA1 2001.xlsx")

# View(ejemplo)
cols<-names(ejemplo)

# [1] "PAIS"         "...2"         "DIA"          "MES"          "A?O"         
# [6] "BARCOD"       "BARDES"       "PUECOD"       "PUEDES"       "ARTCOD"      
# [11] "ARTDES"       "ORICOD"       "ORIDES"       "ESPCOD"       "ESPECIE"     
# [16] "ESPCAT"       "CATEGORIA"    "PESO VIVO"    "PRECIO MEDIO" "DIAS MAR"    
# [21] "DIAS PESCA"   "MAREAS"       "POTENCIA"     "TRB"          "RGT"         
# [26] "ESLTOT" 

cols<-cols[ -c(1, 2)]  ###Quito dos primeros, DIAS PESCA no est? en todos y da problema

##Leo todos los archivos  del pattern y selecciono columnas
all_files <- list.files(pattern = 'Captures comercials ARA GSA1', full.names = TRUE)
GSA1 <- map_df(all_files, 
               ~.x %>% readxl::read_excel() %>% select(cols)) ##\\.xlsx$

## exportamos para el script de cristina
write_xlsx(GSA1,"GSA1_all.xlsx")
##Exploracion de datos

# df %>% group_by(a, b) %>% summarise(n = n()).   ==count()
# barcos<-GSA1 %>% count(BARDES,A?O)
# npuertos<-GSA1 %>% group_by(PUEDES, A?O) %>% summarise(n = n())
# mpuertos<-GSA1 %>% group_by(PUEDES, A?O) %>% summarise(m = sum(`PESO VIVO`))
# mbarcos<-GSA1 %>% group_by(BARDES, A?O) %>% summarise(m = sum(`PESO VIVO`))
# 
# myear<-GSA1 %>% group_by(A?O) %>% summarise(m = sum(`PESO VIVO`))

mmyear1<-GSA1 %>% group_by(A?O,MES,PUEDES) %>% summarise(cap = sum(`PESO VIVO`)) ###SUMA capturas por mes
mmyear2<-GSA1 %>% group_by(A?O,MES,PUEDES) %>% summarise(dias= sum(`DIAS PESCA`)) ###SUMA dias trabajo por mes

cap.d<-inner_join(mmyear1,mmyear2)
cap.d$cap_d<-cap.d$cap/cap.d$dias ###CAPTURA POR DIA (por mes)
cap.d$mmy=mmyear1$A?O+(mmyear1$MES-0.5)/12

# nbarcos<-GSA1 %>% group_by(BARDES, A?O) %>% summarise(n = sum(`PESO VIVO`))


ggplot(cap.d,aes(mmy, log10(cap_d+1), group = PUEDES)) +
  geom_line()+
    geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')


ggplot(cap.d,aes(A?O, log10(cap_d+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')

ggplot(cap.d,aes(MES, log10(cap_d+1), group = PUEDES))+
  geom_point()+
  facet_wrap(.~PUEDES) +
  labs(x = 'year', y = 'Catches/day')

# ggplot(data=AG, aes(x=mmy, y=(m),group=PUEDES)) +
#   geom_line()+
#   geom_point()
# ggplot(mbarcos, aes(x = A?O, y = BARDES, fill = (m))) + geom_tile()
