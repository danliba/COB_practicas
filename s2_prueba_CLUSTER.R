rm(list = ls())

library(dplyr)
library(readxl)
library(astsa)
##LEO datos totales extraidos (capturas/dia(barco) promediado por mes)
data<-read_excel("datos_PUERTOS_MES.xlsx", sheet = "capturas")
port<-colnames(data[,4:33])
sort(port) ###PUERTOS TOTALES

# [1] "Adra"                  "?guilas"               "Alicante"              "Almer?a"              
# [5] "Altea"                 "Arenys de Mar"         "Barcelona"             "Blanes"               
# [9] "Burriana"              "Calpe"                 "Carboneras"            "Cartagena"            
# [13] "Cullera"               "Denia"                 "Gand?a"                "Garrucha"             
# [17] "J?vea"                 "Matar?"                "Mazarr?n"              "Motril"               
# [21] "Palam?s"               "Roses"                 "Sagunto"               "San Pedro del Pinatar"
# [25] "Santa Pola"            "Tarragona"             "Torrevieja"            "V?lez-M?laga"         
# [29] "Vilanova y la Geltr?"  "Villajoyosa"               

##Leo un excel para ver info, veo columnas que me interesan
GSA6<- read_excel("originales/Captures comercials ARA GSA6 2020.xlsx")
GSA6.p<-unique(GSA6$PUEDES)
sort(GSA6.p)

# [1] "Alicante"                "Altea"                   "Ametlla de Mar"         
# [4] "Ampolla"                 "Arenys de Mar"           "Barcelona"              
# [7] "Blanes"                  "Calpe"                   "Cambrils"               
# [10] "Cartagena"               "Castell?n"               "Cullera"                
# [13] "Deltebre"                "Denia"                   "Gand?a"                 
# [16] "J?vea"                   "Llans?"                  "Palam?s"                
# [19] "Pe??scola"               "Puerto de la Selva"      "Roses"                  
# [22] "San Carlos de la R?pita" "San Pedro del Pinatar"   "Santa Pola"             
# [25] "Tarragona"               "Torrevieja"              "Valencia"               
# [28] "Vilanova y la Geltr?"    "Villajoyosa" 


##Filtro GSA por puertos
GSA1.p<-data %>% select(A?O,MES,mmy,Adra,?guilas,Almer?a,Carboneras,Garrucha,Mazarr?n,Motril,'V?lez-M?laga')
GSA6.p<-data %>% select(A?O,MES,mmy,Alicante,Altea,'Arenys de Mar',Barcelona,Blanes,Burriana,Calpe,Cartagena,
                        Cullera,Denia,Gand?a,J?vea,Matar?,Palam?s,Roses, Sagunto,'San Pedro del Pinatar',
                        'Santa Pola',Tarragona,Torrevieja,'Vilanova y la Geltr?',Villajoyosa)



# Aqui veo el numero de meses por a?o para ver huecos en datos y a?os incompletos

 filt1<-GSA1.p %>% group_by(A?O) %>%select(Adra:`V?lez-M?laga`) %>%  # replace to your needs
   summarise_all(funs(sum(! is.na(.))))

 filt2<-GSA6.p %>% group_by(A?O) %>%select(Alicante:Villajoyosa) %>%  # replace to your needs
   summarise_all(funs(sum(! is.na(.))))
 
 
 ##Filtro GSA por puertos con series buenas y me quedo con los a?os donde hay datos de todas las series
 ##Problema: Almer?a empieza en 2008
 GSA1.p<-data %>% select(A?O,MES,mmy,?guilas,Garrucha,Mazarr?n) %>% filter(A?O>=2005)
 GSA6.p<-data %>% select(A?O,MES,mmy,'Arenys de Mar',Barcelona,Blanes,Calpe,Cartagena,
                         Denia,J?vea,Palam?s,
                         'Santa Pola',Tarragona,'Vilanova y la Geltr?',Villajoyosa) %>% filter(A?O>=2005)
 
 ##Interpolacion lineal de gaps que hay en datos (solo hay alg?n huevo mensual)
 library(pastecs) ##Siguiendo Buttay et al. 2020 This method provides a linear interpolation considering all observations located at the vicinity (i.e., within 2 time-steps) of the missing observation
# Para GSA1
 rel.reg1 <- regul(GSA1.p$mmy, GSA1.p[,4:6],deltat=1/12,units="year",rule=2,methods=c("l"))
 ym<-(rel.reg1[["x"]])
serie_GSA1<-cbind(ym,rel.reg1[["y"]]) 
 
# Para GSA6
rel.reg2 <- regul(GSA6.p$mmy, GSA6.p[,4:15],deltat=1/12,units="year",rule=2,methods=c("l"))
ym<-(rel.reg2[["x"]])

serie_GSA6<-cbind(ym,rel.reg2[["y"]]) 

series_GSA<-inner_join(serie_GSA6,serie_GSA1)


###Ya tengo series sin huecos y mismo periodo (desde 2005)

# # Compute wavelet spectra: necesito series con x(=tiempo), y(=variable)
library (biwavelet)
# Hago un primer analisis para sacar dimensiones del output 
t1<-series_GSA$ym 
t2<-series_GSA[,3]
t<-cbind(t1,t2)
wt.t1=wt(t)


##El array donde voy a guardar los outputs
w.arr<-array(NA, dim=c(15, NROW(wt.t1$wave), NCOL(wt.t1$wave)))

# Hago analisis wavelet para todas las columnas(puertos) 
# nos interesa el power o el wave
for(i in 1:15){
  # t1<-1:nrow(data) ###time steps
  t1<-series_GSA$ym ###time steps en a?os
  t2<-series_GSA[,i+1]%>% detrend(., order = 1, lowess = FALSE) ####detrend de series (quito tendencia lineal) ##col 2 de fecha+3 no hay datos
  t<-cbind(t1,t2)
  wt.t=wt(t,do.sig =TRUE,dj=1/12)
   # w.arr[i, , ]=wt.t$wave ###guardo
    w.arr[i, , ]=wt.t$power ###guardo
}

# # ## Compute dissimilarity and distance matrices
 w.arr.dis <- wclust(w.arr)
# 
 png("cluster_power.png")
 hc<-hclust(w.arr.dis$dist.mat, method = "ward.D") 
 plot(hc,sub = "", main = "", ylab = "Dissimilarity", hang = -1)
 orden<-hc$order
nam<-names(series_GSA[2:16])

nam2=list()
for (j in 1:15){
nam2[[j]]<-nam[orden[j]]
}
# 
 library(dendextend)
 dend<-as.dendrogram(hc) 
 dend %>% set("labels",as.character(nam2)) %>% plot
 dev.off()



 
#########CODIGO DE CRISTINA
#Libraries
library(pvclust)

#Read Data

data<-w.arr.dis$diss.mat        ###To complete with your data, try different variables, (download, more ports, years)
data[is.na(data)] <- 0
colnames(data)<-(nam)
dim(data)
# data<-data.frame(data)


#Ward Hierarchical Clustering with Bootstrapped p values
fit <- pvclust((data), method.hclust="ward",
               method.dist="euclidean")
jpeg("CA_power.jpeg", width = 1462, height = 1294, res = 300)
plot(fit, xlab="", col.pv=c(2,3,8)) # dendogram with p values

#add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95,pv="au",max.only=T)
dev.off()




