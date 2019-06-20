% WEATHER_READER how to read in the data from Liv Met Stations
% [data] = weather_reader(file); is the way in which you can read the raw
% data files from one of the lefg.co.uk weather stations. This reading in
% data in a .csv format which can be downloaded from the attached link.
% Please note this may take a while to format the data, as there is a large
% collection of data. 
%
% Example:
% filename = data.csv;
% data = weather_reader(filename);
%
% Inside of data there is a strucutre relating to temperature [?c], humidity [%],
% pressure [mb], co2 [ppm/m^3], voc [ppb/m^3], dust [mg/m^3], uva [W/m^2], uvb[W/m^2]
% and the time of each measurment. 
%
% Example (acessing and plotting data from station 3):
% filename = data.csv;
% data = weather_reader(filename);
% station = 3; 
% subplot(4,2,1)
% Temp = data(station).temperature.temperature;
% Time = data(station).temperature.time;
% title('Temperature');
% plot(Time,Temp);
% subplot(4,2,2)
% Humid = data(station).humidity;
% Time = data(station).temperature.time;
% title('Temperature');
% plot(Time,Temp);


function [data] = weather_reader(file);

    for i = 1:8
        data(i).temperature=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','temperature'}]);
        data(i).humidity=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','humidity'}]);
        data(i).pressure=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','pressure'}]);
        data(i).co2=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','co2'}]);
        data(i).voc=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','voc'}]);
        data(i).dust=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','dust'}]);
        data(i).uva=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','uva'}]);
        data(i).uvb=table('Size',[1,2],'VariableTypes',[{'datetime','single'}],'VariableName',[{'time','uvb'}]);
    end

    tempcor(1)=0.9893; 
    tempcor(2)=0.9403; 
    tempcor(3)=0.9403; 
    tempcor(4)=0.9943; 
    tempcor(5)=1.0578; 
    tempcor(6)=1.0257; 
    tempcor(7)=1.0674; 
    tempcor(8)=0.9450; 

    humidcor(1)=1.0204;
    humidcor(2)=1.0491; 
    humidcor(3)=1.0446; 
    humidcor(4)=1.0247;
    humidcor(5)=0.9498;
    humidcor(6)=0.9528;
    humidcor(7)=0.9112; 
    humidcor(8)=1.0699; 

    presscor(1)=1.0006;
    presscor(2)=0.9996; 
    presscor(3)=0.9998; 
    presscor(4)=1.0006;
    presscor(5)=0.9997;
    presscor(6)=0.9999;
    presscor(7)=0.9998;
    presscor(8)=1.0001;

    presscor(1)=1.0006;
    presscor(2)=0.9996; 
    presscor(3)=0.9998; 
    presscor(4)=1.0006;
    presscor(5)=0.9997;
    presscor(6)=0.9999;
    presscor(7)=0.9998;
    presscor(8)=1.0001;

    uvcor(1)=1.0005;
    uvcor(2)=0.9996;
    uvcor(3)=0.9998;
    uvcor(4)=1.0005;
    uvcor(5)=1.1998;
    uvcor(6)=1.0000;
    uvcor(7)=0.9998;
    uvcor(8)=0.7500;

    voccor(1)=1.1034;
    voccor(2)=0.4998;
    voccor(3)=0.7865;
    voccor(4)=0.7730;
    voccor(5)=0.7730;
    voccor(6)=1.2529;
    voccor(7)=1.3915;
    voccor(8)=1.0000;



    filename = file;
    delimiter = ',';
    startRow = 2;
    formatSpec = '%q%f%f%f%f%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    warning off
    lod = 1;
    for i = 1:size(dataArray{1},1)
        tmp = dataArray{3}(i);
        tmp = num2str(tmp);
        station = str2num(tmp(1));
        func = str2num(tmp(2));
        if func == 1;

            tmp2 = dataArray{1}(i);
            tmp2 = datetime(tmp2{1}(1:16),'InputFormat','yyyy-MM-dd HH:mm');
            data(station).temperature.time(end+1)=tmp2(:); 
            data(station).co2.time(end+1)=tmp2; 
            data(station).voc.time(end+1)=tmp2; 
            data(station).dust.time(end+1)=tmp2; 

            data(station).temperature.temperature(end)=((dataArray{4}(i)/100).*tempcor(station))-5;
            data(station).co2.co2(end)=(dataArray{5}(i)/10).*voccor(station);
            data(station).voc.voc(end)=(dataArray{6}(i)/10).*voccor(station);
            data(station).dust.dust(end)=(dataArray{7}(i)/10);

        end
        if func == 2

            tmp2 = dataArray{1}(i);
            tmp2 = datetime(tmp2{1}(1:16),'InputFormat','yyyy-MM-dd HH:mm');

            data(station).pressure.time(end+1)=tmp2; 
            data(station).humidity.time(end+1)=tmp2;  
            data(station).uva.time(end+1)=tmp2; 
            data(station).uvb.time(end+1)=tmp2; 

            data(station).pressure.pressure(end)=(dataArray{4}(i)/10).*presscor(station);
            data(station).humidity.humidity(end)=(dataArray{5}(i)/100).*humidcor(station);
            data(station).uva.uva(end)=(dataArray{6}(i)/100).*uvcor(station);
            data(station).uvb.uvb(end)=(dataArray{7}(i)/100).*uvcor(station);

        end

       lod2 = ceil(i./size(dataArray{1},1)*100);
       if lod ~= lod2
           clc
           fprintf('Processing %0.2f%% \n',i./size(dataArray{1},1)*100)
           tmp3 = '[';
           for loop = 1:5:lod;
               tmp3=[tmp3,'='];
           end
           tmp3 = [tmp3,'>'];
           for loop = lod:5:100;
             tmp3 = [tmp3,'-']; 
           end
           tmp3 = [tmp3,']'];
           disp(tmp3);
       end
       lod = ceil(i./size(dataArray{1},1)*100);
       if ceil(i./size(dataArray{1},1)*100) == 100;
           clc
       end
    end

