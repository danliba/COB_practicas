%%% encontrar las fechas de que se cruzan entre datos ambientales y de
%%% pesca

clear,clc
%% 
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\MHW

fn0='D_prueba_MCS.xlsx';
fn1='D_MHW_ambiental.xlsx';
[status,sheets] = xlsfinfo(fn1);
[status0,sheets0] = xlsfinfo(fn0);

[numData1, textData1, raw1] = xlsread(fn1, char(sheets(1))); %ambientales
[numData0, textData0, raw0] = xlsread(fn0, char(sheets(1))); %pesca


time1=datenum(numData1(:,26),numData1(:,27),numData1(:,28));
time0=datenum(numData0(:,30),numData0(:,31),numData0(:,32));

columnNames=textData0(1,1:28);
colAmb=textData1(1,1:24);
%% encontramos las fechas 
%% pesca
for ii=1:1:size(numData0,2)-4
    indx0{:,ii}=find(numData0(:,ii)==1);
end

for ii=1:1:size(numData0,2)-4
    time_0{:,ii}=time0(cell2mat(indx0(ii)));
end

%timeT = NaN(100, 32);
%timeT=cell2mat(time_0);

myMatrix = cellArrayToMatrixWithNaN(time_0);

timeT=permute(myMatrix,[1 3 2]);

%% variables ambientales
for ii=1:1:size(numData1,2)-4
    indx1{:,ii}=find(numData1(:,ii)==1);
end

for ii=1:1:size(numData1,2)-4
    time_1{:,ii}=time1(cell2mat(indx1(ii)));
end

%timeAmb = NaN(100, 32);
%timeT=cell2mat(time_0);

myMatrix = cellArrayToMatrixWithNaN(time_1);

timeAmb=permute(myMatrix,[1 3 2]);

%% buscamos coincidencias con intersect por cada variable fisica en la pesca
for ij=1:1:size(timeAmb,2)
    disp(colAmb(ij))
    for ii=1:1:size(timeT,2)
     C{:,ii} = intersect(timeT(:,ii),timeAmb(:,ij));
    
    end
    
   myMatrix = cellArrayToMatrixWithNaN(C);
   time_intersect=permute(myMatrix,[1 3 2]);
   time_intersect_cum{ij}=time_intersect;

end

%%
% Loop through the cell array and assign each cell array to a table in the structure
GambaMHW = struct();

for i = 1:numel(time_intersect_cum)
    % Check if the cell array is not empty
    if ~isempty(time_intersect_cum{i})
        % Create a field in the structure with the corresponding name from variableNames
        fieldName = colAmb{i};
        % Convert the cell array to a table
        T_intersect = array2table(time_intersect_cum{1,i});
        T_intersect.Properties.VariableNames=columnNames;
        % Assign the table to the structure
        GambaMHW.(fieldName) = T_intersect;
    end
end

save('MHW_intersect.mat','GambaMHW');

%% read the dates of GambaMHW and GambaMCS
% Initialize a cell array to store date strings
date_strings = datenumToDateString(table2array(GambaMHW.vorticity_NCN_GSA6));

Tdate=cell2table(date_strings);
Tdate.Properties.VariableNames=columnNames;
disp(Tdate)