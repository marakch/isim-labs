% humidity.m
% ISIM Lab 4: Using capacitors to measure humidity
%
% Calibrates an RC sensing circuit with capacitors of known value, then uses
% the HS1101LF datasheet (capacitance vs. %RH) to build a curve of expected
% output voltage vs. relative humidity. A measured voltage from the real
% sensor is then converted to %RH.
%
% Circuit: square wave -> 50 kOhm resistor -> capacitor (or sensor).
% Voltages are RMS values read from the oscilloscope.

clear;
clf;

%% Calibration: RMS voltage vs. capacitance for known capacitors
Cap     = [100, 120, 180, 200, 220];   % capacitance (pF)
Voltage = [66, 72, 84, 92, 102];       % measured RMS voltage (mV)

p = polyfit(Cap, Voltage, 1);          % linear fit: Voltage = p(1)*Cap + p(2)
x_fit = linspace(min(Cap), max(Cap), 100);
y_fit = polyval(p, x_fit);

figure();
hold on
plot(Cap, Voltage, 'o')
plot(x_fit, y_fit)
xlabel('Capacitance (pF)');
ylabel('RMS voltage (mV)');
title('Calibration fit');
legend('measured data', 'best fit line', 'Location', 'northwest')
hold off

fprintf('Calibration: V = %.3f mV/pF * C + %.2f mV\n', p(1), p(2));

%% Datasheet: HS1101LF capacitance at each relative humidity
RH = [0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100];   % %RH
Capchart = [161.6, 163.6, 165.4, 167.2, 169, 170.7, 172.3, 173.9, 175.5, 177, 178.5, 180, 181.4, 182.9, 184.3, 185.7, 187.2, 188.6, 190.1, 191.6, 193.1];   % pF

%% Measurement curve: expected voltage vs. %RH
% Use the calibration line to turn each datasheet capacitance into the
% voltage this circuit should produce.
z = polyval(p, Capchart);              % expected RMS voltage (mV)

% Linear fit of voltage vs. %RH, so a measured voltage can be turned into %RH
newp = polyfit(RH, z, 1);

% Voltage measured with the real sensor in the room
measured_V = 86;                       % mV (RMS)
pointrh = (measured_V - newp(2)) / newp(1);   % relative humidity (%)

figure();
hold on
plot(RH, z, '-o');
plot(pointrh, measured_V, 'ro')
xlabel('Relative humidity (%RH)');
ylabel('RMS voltage (mV)');
title('Expected voltage vs. relative humidity');
legend('expected from datasheet and calibration', 'measured in room', 'Location', 'northwest')
hold off

fprintf('Measured %.0f mV -> about %.0f %%RH\n', measured_V, pointrh);
fprintf('Circuit sensitivity: about %.3f mV per %%RH\n', newp(1));
