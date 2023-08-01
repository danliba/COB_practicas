cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\vorticidad;
%% exportamos la vorticidad
load('marbalear.mat');

my_file=['mar_balear.xlsx'];
writetable(marbalear,my_file,'Sheet',1);

load('vorticity_NCN_IBI.mat');
writetable(Tvel,my_file,'Sheet',2);
