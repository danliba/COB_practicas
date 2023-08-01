clear;clc
%%%Script para promediar series diarias a mensuales
%%Aprovecho para sacar otros estadísticos (anomalias mensuales, cusum, etc)

load('SST_series_daily.mat')
% tables=table;

m=table(:,2);y=table(:,1);
um=unique(m);uy=unique(y);

cont=0;

for j=1:size(uy,1)
for k=1:size(um,1)
   ind=(m==um(k)&(y==uy(j)));
   f=nanmean(table(ind,3:end),1);
   monthly_s(cont+1,:)=f;
   leg(cont+1,:)=[uy(j),um(k)];
   cont=cont+1;
end
end
           

for y=1:size(um,1)
    ind2=(leg(:,2)==um(y));
    av=nanmean(monthly_s(ind2,:),1);
    sdev=std(monthly_s(ind2,:),1,'omitnan'); %desviacion estandar
    anom(ind2,:)=(monthly_s(ind2,:)-av)./sdev; %anomalia con desviacion estandar
end
    
    csum=cumsum(anom,1);
    
    series_m=cat(2,leg,monthly_s); 
    t_series_m=array2table(series_m,'VariableNames', {'year','month',series_sst.Properties.VariableNames{3:end}});
    
    anom_m=cat(2,leg,anom);
    t_anom=array2table(anom_m,'VariableNames', {'year','month',series_sst.Properties.VariableNames{3:end}});

    csum_m=cat(2,leg,csum);
    t_csum=array2table(csum_m,'VariableNames', {'year','month',series_sst.Properties.VariableNames{3:end}});

    
    save SST_series_monthly.mat series_m t_series_m t_anom t_csum; 
