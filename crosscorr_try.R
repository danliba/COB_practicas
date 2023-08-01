rm(list = ls())
library(dplyr)
library(readxl)

setwd('D:/Maestria/MER/Intership/baleares/practicas_Daniel/')

vort<-read_excel('datos_ambientales/vorticidad/mar_balear.xlsx','Sheet1')
vort2<-read_excel('datos_ambientales/vorticidad/mar_balear.xlsx','Sheet2') #velocidad m/s
sst<-read_excel('datos_ambientales/clorofila/satelite_GFCM_Medit.xlsx','SST')
chlor<-read_excel('datos_ambientales/clorofila/satelite_GFCM_Medit.xlsx','CHL')
hloss<-read_excel('datos_ambientales/heatloss/daily/HL.xlsx','monthly')

pesca<-read_excel('datos_capturas/originales2/datos_PUERTOS_MES.xlsx')

pesca<-pesca %>% mutate(sum_4_to_33=rowSums(select(.,4:33),na.rm=TRUE))

vorticityVector<-vort$vortabs[97:length(vort$vortabs)]
pescaVector<-pesca$sum_4_to_33[1:240]

#velocidad
velCAT<-vort$CAT[97:length(vort$vortabs)]
velMALL<-vort$MALL[97:length(vort$vortabs)]
velNCN<-vort2$NCN[97:336] #m/s
velIBI<-vort2$IBI[97:336] #m/s

## temperatura
sst<-sst %>% mutate(Mean_G1_G6=rowMeans(select(.,3,8),na.rm=TRUE))
ssti<-sst[229:468,c(3,8,9)]

## clorofila
chlor<-chlor %>% mutate(Mean_G1_G6=rowMeans(select(.,3,8),na.rm=TRUE))
chlori<-chlor[37:276,c(3,8,9)]

##heat loss
hloss<-hloss$mean_HW[1:252]
# Assuming you have two vectors: Vorticity and Captures
# Let's assume Vorticity is stored in vorticityVector and CPUE is stored in cpueVector
# Compute the cross-correlation function
ccf_result <- ccf(vorticityVector, pescaVector, lag.max = 6, plot = FALSE)
ccf2<-ccf(velCAT, pescaVector, lag.max = 6, plot = FALSE)
ccf3<-ccf(velMALL, pescaVector, lag.max = 6, plot = FALSE)
ccf4<-ccf(velNCN, pescaVector, lag.max = 6, plot = FALSE)
ccf5<-ccf(velIBI, pescaVector, lag.max = 6, plot = FALSE)

## temp
ccfSST<-ccf(ssti$sum_G1_G6, pescaVector, lag.max = 6, plot = FALSE)
ccfsstG1<-ccf(ssti$GSA1, pescaVector, lag.max = 6, plot = FALSE)
ccfsstG6<-ccf(ssti$GSA6, pescaVector, lag.max = 6, plot = FALSE)

## chlor
ccfchlor<-ccf(chlori$Mean_G1_G6, pescaVector, lag.max = 6, plot = FALSE)
ccfchlorG1<-ccf(chlori$GSA1, pescaVector, lag.max = 6, plot = FALSE)
ccfchlorG6<-ccf(chlori$GSA6, pescaVector, lag.max = 6, plot = FALSE)

#heat loss
ccfhloss<-ccf(hloss, pescaVector, lag.max = 6, plot = FALSE)

# Extract the lagged correlation coefficients
laggedCorr <- ccf_result$acf

# Compute the p-values using ACF
acf_result <- acf(vorticityVector, lag.max = 6, plot = TRUE)

##vorticidad 1, vel 1
par(mfrow = c(3, 1))
plot(ccf_result, main = 'Lagged Correlation Vorticity and Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccf2, main = 'Lagged Correlation Velocity CAT and Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccf3, main = 'Lagged Correlation Velocity MALL and Captures', ylab = 'Correlation', xlab = 'Lag')

## velocidad
par(mfrow = c(2, 1))
plot(ccf4, main = 'Lagged Correlation Velocity NCN and Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccf5, main = 'Lagged Correlation Velocity IBI and Captures', ylab = 'Correlation', xlab = 'Lag')

#temperature
par(mfrow = c(3, 1))
plot(ccfsstG1, main = 'Lagged Correlation SST GSA1 and Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccfsstG6, main = 'Lagged Correlation SST GSA6 Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccfSST, main = 'Lagged Correlation Mean SST and Captures', ylab = 'Correlation', xlab = 'Lag')

#chlorophyll
par(mfrow = c(3, 1))
plot(ccfchlorG1, main = 'Lagged Correlation Chlor GSA1 and Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccfchlorG6, main = 'Lagged Correlation Chlor GSA6 Captures', ylab = 'Correlation', xlab = 'Lag')
plot(ccfchlor, main = 'Lagged Correlation Mean Chlor and Captures', ylab = 'Correlation', xlab = 'Lag')


#heatloss
par(mfrow = c(1, 1))
plot(ccfhloss, main = 'Lagged Correlation Mean HW and Captures', ylab = 'Correlation', xlab = 'Lag')
