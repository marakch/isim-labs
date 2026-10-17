% thermometer.m
% ISIM Lab 2: Monitoring temperature
% Converts thermistor voltage divider data to temperature and plots it.
% Requires tempISIMlab2.csv in the same folder.

clear;
clf;

%take in data from csv file
tname='tempISIMlab2.csv';
datatable = readtable(tname);%makes data table with headers

%interpret data as times and voltages
time1 = datatable.t1; % stores the t1 column of data in a variable called time1
V1    = datatable.ch1; % stores the ch1 column of data in a variable called V1
time2 = datatable.t2; %stores the t2 column of data in a variable called time2
V2 = datatable.ch2; %stores the ch2 column of data in a variable called V2

figure;
plot(time1,V1) %plots first channel
xlim([-370,50]);
xlabel('Time (seconds)');
ylabel('Voltage (V)');
title('Voltage Change with Respect to Time');

%circuit values: 5 V input, 10 kOhm fixed resistor, thermistor on the ground side
Vin = 5;
R = 10000;

%voltage -> thermistor resistance (from the voltage divider)
Rt = R.*V1./(Vin-V1);

%thermistor resistance -> temperature (inverse of R = 10000*exp(3528*(1/T-1/298)))
T = (3528*298)./(3528+298*log(Rt/10000)); % Kelvin
T = T - 273.15; % Celsius

figure;
plot(time1+350,T); % +350 so the experiment starts at 0 s
xlim([0,375]);
xlabel('Time (seconds)');
ylabel('Temperature (Celsius)');
title('Temperature Change With Respect to Time');

%temperature drop in the first 3 minutes, averaged within 2 s to reduce noise
t = time1+350;
tIce = 190; % time the ice water was added (read off the plot)
dT_alone = mean(T(abs(t-0)<=2)) - mean(T(abs(t-180)<=2));
dT_ice = mean(T(abs(t-tIce)<=2)) - mean(T(abs(t-(tIce+180))<=2));
fprintf('Drop in first 3 min, water alone: %.1f C\n', dT_alone);
fprintf('Drop in first 3 min, after ice water: %.1f C\n', dT_ice);
