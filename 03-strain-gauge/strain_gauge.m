% strain_gauge.m
% ISIM Lab 3: Strain gauge scale
%
% Calibrates a strain gauge scale from three washers of known mass, checks
% how well each point fits the line, and works out how small the gauge's
% resistance change is for a 20 mV change at the amplifier output.
%
% Requires 79.2only.csv, 121.7two.csv, and 164.2three.csv in the same folder
% (oscilloscope exports with a ch1 column of output voltage).

clear;
clf;

%% Load data (one file per washer)
fname = '79.2only.csv';
sname = '121.7two.csv';
tname = '164.2three.csv';
datatable1 = readtable(fname);   % makes data table with headers
datatable2 = readtable(sname);
datatable3 = readtable(tname);

% Output voltage (V) for each washer
V1 = datatable1.ch1;
V2 = datatable2.ch1;
V3 = datatable3.ch1;

% Average each recording to get one voltage per mass
avg_V1 = mean(V1);
avg_V2 = mean(V2);
avg_V3 = mean(V3);

%% Calibration curve: voltage vs. mass
weight  = [79.2, 121.7, 164.2];            % known masses (g)
voltage = [avg_V1, avg_V2, avg_V3];        % average output voltages (V)

p = polyfit(weight, voltage, 1);           % linear fit: voltage = p(1)*mass + p(2)
x_fit = linspace(min(weight), max(weight), 100);
y_fit = polyval(p, x_fit);

figure;
hold on;
plot(weight, voltage, 'o');
plot(x_fit, y_fit);
xlabel('Mass (g)');
ylabel('Voltage (V)');
title('Voltage change of strain gauge');
legend('measured data', 'best fit line', 'Location', 'northwest');

slope      = p(1);   % V per gram
yintercept = p(2);   % V
fprintf('Calibration: V = %.5f V/g * mass + %.5f V\n', slope, yintercept);

%% Fit error at each calibration point
% Mass predicted from each measured voltage, compared with the true mass:
% percent error = (predicted - known) / known * 100
fit_error = zeros(3, 1);
for i = 1:3
    estimated = (voltage(i) - yintercept) / slope;           % predicted mass (g)
    fit_error(i) = (estimated - weight(i)) / weight(i) * 100;
end
fit_error

%% Sensitivity: what does a 20 mV change at the output mean?
G      = 2.1;               % gauge factor of the strain gauge
Gamp   = 1 + 100000/200;    % AD623 gain with a 200 ohm resistor (= 501)
Vin    = 5;                 % V, bridge supply
R      = 120;               % ohms, strain gauge resistance (unloaded)
deltaV = 0.02;              % V, change at the amplifier output

% Voltage change at the bridge, before amplification
deltaV_bridge = deltaV / Gamp

% Quarter bridge (one active gauge): deltaV = Vin * (deltaR/R) / 4
fraction = 4 * deltaV_bridge / Vin    % deltaR / R
deltaR   = fraction * R               % change in gauge resistance (ohms)
strain   = fraction / G               % from deltaR/R = G * strain

% Mass needed for a 20 mV change in output
mass = deltaV / slope                 % grams
