%%%
%%%Código para extraer variable 
clear,clc;


rootdir = 'E:\CMEMS\dataset-oc-med-chl-multi-l4-chl_1km_monthly-rep-v02\';
FileList = dir(fullfile(rootdir,'*'));
FileList2 = dir(fullfile(rootdir,'*','*'));
FileList3 = dir(fullfile(rootdir, '**','*.nc'));

for i=1:size(FileList3,1)
y(i,:)=str2num( FileList3(i).name([1:4]));
m(i,:)= str2num(FileList3(i).name([5:6]));
d(i,:)= str2num(FileList3(i).name([7:8]));
end

nombres={FileList3 .name}';
aux=ncinfo(fullfile(FileList3(1).folder,FileList3(1).name)); 
variables={aux.Variables.Name}'; clear aux;
CHL=variables{4, 1};
variables([1:3,5:6])=[];

%--- limites de la zona que quiero coger
% lonmin=-0.5; lonmax=5; latmin=38; latmax=44;
lonmin=-6; lonmax=5.5; latmin=34; latmax=43;


%--- cargamos la lon i lat de uno
lon=ncread(fullfile(FileList3(1).folder,FileList3(1).name),'lon'); lat=ncread(fullfile(FileList3(1).folder,FileList3(1).name),'lat');

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


 for na=1:length(nombres)
        disp(['Voy por el dia ',num2str(na),' de ',num2str(length(nombres))]);
        %--- cargo las profundidades de este archivo
       var_or=ncread(fullfile(FileList3(na).folder,FileList3(na).name),CHL,[inlo,inla,1],[dxlo,dxla,Inf]);
%         var_or=var_or-273.15;
var_or=var_or'.*eq;

var_g(:,:, na)=var_or;
leg(na,:)=[y(na), m(na)];
   disp(na)
end


var_g(var_g==0)=NaN;
a=nanmean(var_g,3);

%%Pinto
m_proj('Mercator','longitudes',[lonmin lonmax],'latitudes',[latmin latmax]); hold on;
% m_proj('mercator','longitude',[lonmin,lonmax],'latitude',[latmin,latmax]);
m_pcolor(lon,lat,log10(a)); shading flat; caxis([-1. 0])
colorbar; 
tit=title(['CHL mg m-3']);
m_gshhs_h('patch',[0.66 0.66 0.66]); 
m_grid('linest','none','box','fancy','tickdir','in','fontsize',8,'xtick',8,'ytick',6);


save CHL_Med_1000m.mat var_g lon lat leg;


