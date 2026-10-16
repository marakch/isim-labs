% simple_pendulum.m
% ISIM Lab 1: Simple Pendulum
% Calibrates a potentiometer angle sensor (voltage vs. angle), then uses
% the calibration to convert recorded pendulum data to angle vs. time.
% Requires actualpendulumrun.csv in the same folder.

clear; 
clf;

%% Calibration: voltage vs. angle
Angle   = [-100; -80; -60; -40; -20; 0; 20; 40; 60; 80; 100]; % degrees
Voltage = [221.5; 290.0; 367.6; 420.1; 456.1; 501.7; 546.3; 596.6; 672.7; 769.3; 787.4]; % mV

p = polyfit(Angle, Voltage, 1);   % linear fit: V = p(1)*theta + p(2)
VoltageFit = polyval(p, Angle);

plot(Angle, Voltage, '*');
hold on;
plot(Angle, VoltageFit, 'r');
ylim([150, 850]);
xlabel('Angle (degrees)');
ylabel('Voltage (mV)');
title('Calibration graph');
legend('measured data', 'best fit line', 'Location', 'northwest');

fprintf('Transfer function: V = %.4f * theta + %.4f (mV)\n', p(1), p(2));

%% Pendulum data: angle vs. time
datatable = readtable('actualpendulumrun.csv');
time1 = datatable.t1;   % time (s)
V1    = datatable.ch1;  % voltage (V)

% Convert voltage to angle using the calibration (fit is in mV)
theta = (V1*1000 - p(2)) / p(1);   % degrees

% Keep only the real swing (cuts off leftover buffer from the previous run)
tStart = -80;   % adjust by looking at the plot
tEnd   = 15;
keep = time1 >= tStart & time1 <= tEnd;

figure();
plot(time1(keep), theta(keep));
xlabel('Time (s)');
ylabel('Angle (degrees)');
title('Pendulum angle vs. time');
