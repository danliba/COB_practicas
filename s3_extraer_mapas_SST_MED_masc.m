%%%
%%%Código para extraer variable SST (con ventana), promedio por mes
%%%Hago mascara en funcion de lon/lat de variables
clear,clc;

%%%En esta parte extraigo de mi disco 
rootdir = 'med-cmcc-tem-rean-m_1689601621692.nc';
% FileList = dir(fullfile(rootdir,'*'));
% FileList2 = dir(fullfile(rootdir,'*','*'));
% FileList3 = dir(fullfile(rootdir, '**','*.nc'));
% 
% for i=1:size(FileList3,1)
% y(i,:)=str2num( FileList3(i).name([1:4]));
% m(i,:)= str2num(FileList3(i).name([5:6]));
% d(i,:)= str2num(FileList3(i).name([7:8]));
% end
% 
% nombres={FileList3 .name}';
% aux=ncinfo(fullfile(FileList3(1).folder,FileList3(1).name)); 
% variables={aux.Variables.Name}'; clear aux;
% sst=variables{4, 1};
% variables([1:3,5:7])=[]; %%%Selecciono SST

%--- limites de la zona que quiero coger
% lonmin=-0.5; lonmax=5; latmin=38; latmax=44;
fn='med-cmcc-tem-rean-m_1689601621692.nc';
time=double(ncread(fn,'time'));
time=datenum(1900,1,1)+time./1440;
ttime=datevec(time); 

lonmin=-6; lonmax=5.5; latmin=34; latmax=43;


%--- cargamos la lon y lat de uno
lon=ncread(fn,'lon'); lat=ncread(fn,'lat');

%--- buscamos lon indices que quiero
inlo=find(lon>=lonmin,1,'first'); dxlo=find(lon<=lonmax,1,'last')-inlo+1;
inla=find(lat>=latmin,1,'first'); dxla=find(lat<=latmax,1,'last')-inla+1;
lon=lon(inlo+[0:dxlo-1]); lat=lat(inla+[0:dxla-1]);


[LON,LAT]=meshgrid(lon,lat);
lon1=double(reshape(LON,size(LON,1)*size(LON,2),1));
lat1=double(reshape(LAT,size(LON,1)*size(LON,2),1));

%%%Hago mascara con funcion
[Xq,Yq,eq] = get_mask(LON,LAT);
ind=find((eq<=0)&(-1000<=eq)); %%%Aplico profundidades

 eq((ind))=1;eq(not(eq==1))=0;



%    m2=NaN*zeros(length(y),numel(S));
   uy=unique(ttime(:,1));um=unique(ttime(:,2));  
   
    %--- cargamos uno
    cont=1;
%     key=(1:length(nombres));

%%%Promedio por mes
for j=1:size(uy,1)
for k=1:size(um,1)
   ind=(ttime(:,2)==um(k)&(ttime(:,1)==uy(j)));
%    f=nanmean(table(ind,3:end),1);
%    monthly_s(cont+1,:)=f;
ind2=find(ind==1);
for l=1:sum(ind)
       var_or=ncread(fn,'thetao',[inlo,inla,1,1],[dxlo,dxla,1,Inf]);
        var_or1=permute(var_or,[1 2 4 3]);
        var_or2=var_or1.*eq; %%Multiplico por mascara %arreglar aqui
  
end
var_g(:,:, cont)=nanmean(var_or,3);
   leg(cont,:)=[uy(j),um(k)];
    cont=cont+1;
    disp(cont)
end
end
var_g(var_g==0)=NaN;

a=nanmean(var_g,3);

%%Pinto
m_proj('Mercator','longitudes',[lonmin lonmax],'latitudes',[latmin latmax]); hold on;
% m_proj('mercator','longitude',[lonmin,lonmax],'latitude',[latmin,latmax]);
m_pcolor(lon,lat,(a)); shading flat; colormap('jet'); %caxis([16 20])
colorbar; 
tit=title(['SST ºC']);
m_gshhs_h('patch',[0.66 0.66 0.66]); 
m_grid('linest','none','box','fancy','tickdir','in','fontsize',8,'xtick',8,'ytick',6);


save SST_Med_1000m.mat var_g lon lat leg;


