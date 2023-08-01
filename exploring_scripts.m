%% reading CHL_Med_1000
grayColor = [.7 .7 .7];
pcolor(lon,lat,var_g(:,:,1)); shading flat; colorbar;
colormap jet
hold on
borders('countries','facecolor',grayColor);
axis([min(lon) max(lon) min(lat) max(lat)])
title('CHL 1000m')
caxis([0 2])

%% reading CHL_med_1000_bati
%load('CHL_Med_1000m_bati.mat');

grayColor = [.7 .7 .7];
pcolor(lon,lat,var_g(:,:,1)); shading flat; colorbar;
colormap jet
hold on
borders('countries','facecolor',grayColor);
axis([min(lon) max(lon) min(lat) max(lat)])
title('CHL 1000m bati')
caxis([0 2])
%% reading chl med 1000m v3
%load('CHL_Med_1000m_v3.mat')

grayColor = [.7 .7 .7];
pcolor(lon,lat,var_g(:,:,1)); shading flat; colorbar;
colormap jet
hold on
borders('countries','facecolor',grayColor);
axis([min(lon) max(lon) min(lat) max(lat)])
title('CHL 1000m V3')
caxis([0 2])

%% anom
%load('CHL_series_anom.mat')
plot(table2array(t_anom(:,3:end)))
columnNames=t_anom.Properties.VariableNames;

legend(columnNames(3:end))
%%
plot(table2array(t_csum(:,3:end)))
%% 
