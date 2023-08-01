rm(list = ls())

library(dplyr)
library(readxl)
##LEO datos totales extraidos (capturas/dia(barco) promediado por mes)
data<-read_excel("datos_PUERTOS_MES.xlsx", sheet = "capturas")
port<-colnames(data[,4:33])
sort(port) ###PUERTOS TOTALES

# [1] "Adra"                  "Águilas"               "Alicante"              "Almería"              
# [5] "Altea"                 "Arenys de Mar"         "Barcelona"             "Blanes"               
# [9] "Burriana"              "Calpe"                 "Carboneras"            "Cartagena"            
# [13] "Cullera"               "Denia"                 "Gandía"                "Garrucha"             
# [17] "Jávea"                 "Mataró"                "Mazarrón"              "Motril"               
# [21] "Palamós"               "Roses"                 "Sagunto"               "San Pedro del Pinatar"
# [25] "Santa Pola"            "Tarragona"             "Torrevieja"            "Vélez-Málaga"         
# [29] "Vilanova y la Geltrú"  "Villajoyosa"               

##Leo un excel para ver info, veo columnas que me interesan
GSA6<- read_excel("originales/Captures comercials ARA GSA6 2020.xlsx")
GSA6.p<-unique(GSA6$PUEDES)
sort(GSA6.p)

# [1] "Alicante"                "Altea"                   "Ametlla de Mar"         
# [4] "Ampolla"                 "Arenys de Mar"           "Barcelona"              
# [7] "Blanes"                  "Calpe"                   "Cambrils"               
# [10] "Cartagena"               "Castellón"               "Cullera"                
# [13] "Deltebre"                "Denia"                   "Gandía"                 
# [16] "Jávea"                   "Llansá"                  "Palamós"                
# [19] "Peñíscola"               "Puerto de la Selva"      "Roses"                  
# [22] "San Carlos de la Rápita" "San Pedro del Pinatar"   "Santa Pola"             
# [25] "Tarragona"               "Torrevieja"              "Valencia"               
# [28] "Vilanova y la Geltrú"    "Villajoyosa" 


##Filtro GSA por puertos
GSA1.p<-data %>% select(AÑO,MES,mmy,Adra,Águilas,Almería,Carboneras,Garrucha,Mazarrón,Motril,'Vélez-Málaga')
GSA6.p<-data %>% select(AÑO,MES,mmy,Alicante,Altea,'Arenys de Mar',Barcelona,Blanes,Burriana,Calpe,Cartagena,
                        Cullera,Denia,Gandía,Jávea,Mataró,Palamós,Roses, Sagunto,'San Pedro del Pinatar',
                        'Santa Pola',Tarragona,Torrevieja,'Vilanova y la Geltrú',Villajoyosa)

##Leo datos ambientales y les pongo mismo nombre de columnas que datos GSA
SST <- read_excel("satelite_GFCM_Medit.xlsx",sheet='SST') %>% rename(AÑO=year,MES=month)

CHL<-read_excel("satelite_GFCM_Medit.xlsx",sheet='CHL')%>% rename(AÑO=year,MES=month)

##Uno por año y mes
joined_GSA1<-left_join(GSA1.p,select(SST,AÑO,MES,GSA1),by=c('AÑO','MES')) %>% 
  left_join(.,select(CHL,AÑO,MES,GSA1),by=c('AÑO','MES')) %>% rename(SST=GSA1.x,CHL=GSA1.y)

joined_GSA6<-left_join(GSA6.p,select(SST,AÑO,MES,GSA6),by=c('AÑO','MES')) %>% 
  left_join(.,select(CHL,AÑO,MES,GSA6),by=c('AÑO','MES')) %>% rename(SST=GSA6.x,CHL=GSA6.y)


