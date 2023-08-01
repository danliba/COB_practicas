%% exploring heatloss
load('series_HW.mat');

%%
timeis=datenum(series_HW_monthly(:,1),series_HW_monthly(:,2),15);
plot(timeis,series_HW_monthly(:,3)); 
datetick('x'); grid on; title('Monthly HeatLoss');