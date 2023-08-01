%% exploracion de los datos de clorofila

fn='chlor.nc';
lat=double(ncread(fn,'lat'));
lon=double(ncread(fn,'lon'));
time=double(ncread(fn,'time'))./86400;
time=time+datenum(1981,1,1,0,0,0);

chlor=double(ncread(fn,'CHL'));

%% time
[yr,mo,da,hr,min,sec]=datevec(time);
time=datenum(yr,mo,da,hr,min,sec);
fecha=datestr(datenum(yr,mo,15));
%% a plot to check monthly 

aviobj = QTWriter('Chlorofila_mensual.mov','FrameRate',1);%aviobj.Quality = 100;

for ii=1:1:length(time)
pcolor(lon,lat,log(chlor(:,:,ii)')); shading flat; colormap jet;
caxis([0 2]); colorbar;
hc=colorbar; caxis(['auto']);
       caxis(log10([0.01 60]));
       set(hc,'ticks',log10([0.01 0.1 0.5 1 2 3 4 5 10 20 30 40 50 60]),...
    'ticklabels',[0.01 0.1 0.5 1 2 3 4 5 10 20 30 40 50 60],'TickDirection',('out'));
 hold on
 borders('france','b')
 hold on
 borders('spain','k')
 title(fecha(ii,:));
 M1=getframe(gcf);
 writeMovie(aviobj, M1);
 pause(1)
 clf
end
close(aviobj);
%% ahora la climatologia

for ik=1:1:12
    
    %calculate clim
    indxclim=find(mo==ik);
    chlclim(:,:,ik)=nanmean(chlor(:,:,indxclim),3);
end
%% la graficamos la climatologia
aviobj = QTWriter('Chlorofila_climatologia.mov','FrameRate',1);%aviobj.Quality = 100;

figure
for ic=1:1:12
    %plot
    pcolor(lon,lat,log(chlclim(:,:,ic)')); shading flat; colormap jet;
    caxis([0 2]); colorbar;
    hc=colorbar; caxis(['auto']);
           caxis(log10([0.01 60]));
           set(hc,'ticks',log10([0.01 0.1 0.5 1 2 3 4 5 10 20 30 40 50 60]),...
        'ticklabels',[0.01 0.1 0.5 1 2 3 4 5 10 20 30 40 50 60],'TickDirection',('out'));
      hold on
 borders('france','b')
 hold on
 borders('spain','k')
 title(['Month: ',num2str(ic)]);
  M1=getframe(gcf);
 writeMovie(aviobj, M1);
 pause(1)
 clf
end
close(aviobj);
%% ahora hacemos la anomalia
yrst=1998; yrend=2021;
most=1; moen=12; moen0=6;

aviobj = QTWriter('Chlorofila_anomalia.mov','FrameRate',1);%aviobj.Quality = 100;

figure
jj=0;
for iy=yrst:1:yrend
        if iy==yrend
            moen=6;
        end

    for imo=most:1:moen

        % fechas=[datenum(iy,imo,01) datenum(iy,imo,28)];
        % indxtime=find(time>=fechas(1)&time<=fechas(2));
        disp(datestr(datenum(iy,imo,15)))
        jj=jj+1;

        chlori=chlor(:,:,jj);
        disp(imo)
        chloranom(:,:,jj)=chlori-chlclim(:,:,imo);
        
        pcolor(lon,lat,chloranom(:,:,jj)'); shading flat; colormap jet;
        clim([-0.5 0.5]); colorbar;
         hold on
         borders('france','b')
         hold on
         borders('spain','k')
         title(fecha(jj,:));
         M1=getframe(gcf);
         writeMovie(aviobj, M1);
         pause(1)
         clf
    end   
end
close(aviobj);

%% 
save('chlorophyll.mat', 'chloranom','chlclim', 'time', 'chlor', 'lon', 'lat','-v7.3');
