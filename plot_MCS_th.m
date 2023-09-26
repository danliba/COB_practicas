clear,clc

pruebaMCS=importfile("prueba_MCS_th.xlsx");


a=table2array(pruebaMCS(:,1:28));
a(a==0)=NaN;

fecha=pruebaMCS.year+(pruebaMCS.month-1+pruebaMCS.day./31)./12;
pcolor(fecha,(1:28),a'); shading flat, colormap('jet'),caxis([0,1])

nam=pruebaMCS.Properties.VariableNames;
nam=nam(1,1:28);
set(gca,'YTick',(1:28));
set(gca,'YTicklabels',nam);

