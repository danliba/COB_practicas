cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\GEBCO_19_May_2022_b49d488cb0b3\
%%
fn='gebco_2021_n90.0_s27.386706948280334_w-64.54687392711641_e70.31250858306883.nc';
%% 
lon=double(ncread(fn,'lon'));
lat=double(ncread(fn,'lat'));
topo=double(ncread(fn,'elevation'));

region0=[-6 5.5 34 43];
indxlon=find(lon>=region0(1) & lon<=region0(2));
indxlat=find(lat>=region0(3) & lat<=region0(4));

loni=lon(indxlon); lati=lat(indxlat);

topo2=topo(indxlon,indxlat);
%% 
grayColor = [.7 .7 .7];

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
pcolor(loni,lati,topo2'); shading flat; colormap jet;
hold on
[C,h]=contour(loni,lati,topo2',[-3000:500:0],'k:');
clabel(C,h); caxis([-3000 0]);
colorbar; 
tit=title('Topografia');
hold on
borders('countries','facecolor',grayColor);
axis square

