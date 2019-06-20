% A basic script to plot some of the data. For more help check out the
% function documentation. 
filename = 'feeds.csv';
data = weather_reader(filename)
station = 3 % choose a station number between [1-8]
% The data is then plotted here:
subplot(4,2,1)
Temp = data(station).temperature.temperature;
Time = data(station).temperature.time;
plot(Time,Temp);
title('Temperature (?c)');
subplot(4,2,2)
Humid = data(station).humidity.humidity;
Time = data(station).temperature.time;
plot(Time,Humid);
title('Humidity (%)');
subplot(4,2,3)
Pressure = data(station).pressure.pressure;
Time = data(station).temperature.time;
plot(Time,Pressure);
title('Pressure (%)');
subplot(4,2,4)
CO2 = data(station).co2.co2;
Time = data(station).temperature.time;
plot(Time,CO2);
title('CO2 (ppm/m^3)');
subplot(4,2,5)
VOC = data(station).voc.voc;
Time = data(station).temperature.time;
plot(Time,VOC);
title('CO2 (ppb/m^3)');
subplot(4,2,6)
Dust = data(station).dust.dust;
Time = data(station).temperature.time;
plot(Time,Dust);
title('Dust (mg/m^3)');
subplot(4,2,7)
Dust = data(station).uva.uva;
Time = data(station).temperature.time;
plot(Time,Dust);
title('UVa (W/m^2)');
subplot(4,2,8)
Dust = data(station).uvb.uvb;
Time = data(station).uvb.time;
plot(Time,Dust);
title('UVb (W/m^2)');


