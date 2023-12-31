rm(list = ls())

library(dplyr)
library(readxl)
##LEO datos totales extraidos (capturas/dia(barco) promediado por mes)
data<-read_excel("datos_PUERTOS_MES.xlsx", sheet = "capturas")
port<-colnames(data[,4:33])
sort(port) ###PUERTOS TOTALES

# [1] "Adra"                  "�guilas"               "Alicante"              "Almer�a"              
# [5] "Altea"                 "Arenys de Mar"         "Barcelona"             "Blanes"               
# [9] "Burriana"              "Calpe"                 "Carboneras"            "Cartagena"            
# [13] "Cullera"               "Denia"                 "Gand�a"                "Garrucha"             
# [17] "J�vea"                 "Matar�"                "Mazarr�n"              "Motril"               
# [21] "Palam�s"               "Roses"                 "Sagunto"               "San Pedro del Pinatar"
# [25] "Santa Pola"            "Tarragona"             "Torrevieja"            "V�lez-M�laga"         
# [29] "Vilanova y la Geltr�"  "Villajoyosa"               

##Leo un excel para ver info, veo columnas que me interesan
GSA6<- read_excel("originales/Captures comercials ARA GSA6 2020.xlsx")
GSA6.p<-unique(GSA6$PUEDES)
sort(GSA6.p)

# [1] "Alicante"                "Altea"                   "Ametlla de Mar"         
# [4] "Ampolla"                 "Arenys de Mar"           "Barcelona"              
# [7] "Blanes"                  "Calpe"                   "Cambrils"               
# [10] "Cartagena"               "Castell�n"               "Cullera"                
# [13] "Deltebre"                "Denia"                   "Gand�a"                 
# [16] "J�vea"                   "Llans�"                  "Palam�s"                
# [19] "Pe��scola"               "Puerto de la Selva"      "Roses"                  
# [22] "San Carlos de la R�pita" "San Pedro del Pinatar"   "Santa Pola"             
# [25] "Tarragona"               "Torrevieja"              "Valencia"               
# [28] "Vilanova y la Geltr�"    "Villajoyosa" 


##Filtro GSA por puertos
GSA1.p<-data %>% select(A�O,MES,mmy,Adra,�guilas,Almer�a,Carboneras,Garrucha,Mazarr�n,Motril,'V�lez-M�laga')
GSA6.p<-data %>% select(A�O,MES,mmy,Alicante,Altea,'Arenys de Mar',Barcelona,Blanes,Burriana,Calpe,Cartagena,
                        Cullera,Denia,Gand�a,J�vea,Matar�,Palam�s,Roses, Sagunto,'San Pedro del Pinatar',
                        'Santa Pola',Tarragona,Torrevieja,'Vilanova y la Geltr�',Villajoyosa)

##Leo datos ambientales y les pongo mismo nombre de columnas que datos GSA
SST <- read_excel("satelite_GFCM_Medit.xlsx",sheet='SST') %>% rename(A�O=year,MES=month)

CHL<-read_excel("satelite_GFCM_Medit.xlsx",sheet='CHL')%>% rename(A�O=year,MES=month)

##Uno por a�o y mes
joined_GSA1<-left_join(GSA1.p,select(SST,A�O,MES,GSA1),by=c('A�O','MES')) %>% 
  left_join(.,select(CHL,A�O,MES,GSA1),by=c('A�O','MES')) %>% rename(SST=GSA1.x,CHL=GSA1.y)

joined_GSA6<-left_join(GSA6.p,select(SST,A�O,MES,GSA6),by=c('A�O','MES')) %>% 
  left_join(.,select(CHL,A�O,MES,GSA6),by=c('A�O','MES')) %>% rename(SST=GSA6.x,CHL=GSA6.y)


