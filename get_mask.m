function [Xq,Yq,eq] = get_mask(lon1,lat1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
file='D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\GEBCO_19_May_2022_b49d488cb0b3\gebco_2021_n90.0_s27.386706948280334_w-64.54687392711641_e70.31250858306883.nc';

%fns=fullfile(path01,file);
lon=double(ncread(file,'lon'));
lat=double(ncread(file,'lat'));
lonmin=-6; lonmax=5.5; latmin=34; latmax=43;

%--- buscamos lon indices que quiero
inlo=find(lon>=lonmin,1,'first'); dxlo=find(lon<=lonmax,1,'last')-inlo+1;
inla=find(lat>=latmin,1,'first'); dxla=find(lat<=latmax,1,'last')-inla+1;
lon=lon(inlo+[0:dxlo-1]); lat=lat(inla+[0:dxla-1]);

var=double(ncread(file,'elevation',[inlo,inla],[dxlo,dxla]));

[lono,lato]=meshgrid(lon,lat);
% lono=double(reshape(lono,size(lono,1)*size(lono,2),1));
% lato=double(reshape(lato,size(lono,1)*size(lono,2),1));
e=permute(var,[2 1 3]); 

[Xq,Yq,eq] = griddata(lono,lato,e,double(lon1),double(lat1));
end

