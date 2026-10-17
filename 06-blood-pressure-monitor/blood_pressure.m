% blood_pressure.m
% ISIM Lab 6: Blood pressure
%
% Converts the pressure sensor voltage to cuff pressure (mmHg), plots it
% above the output of my band-pass filter circuit, and estimates mean
% arterial pressure: the cuff pressure at the moment the pulse is largest.
%
% Requires lab6.csv (columns t1, ch1, t2, ch2) in the same folder:
%   ch1 = MPX5050DP pressure sensor output (V)
%   ch2 = output of the filter circuit (V)
% This is a recorded dataset, not a live measurement.

clear;
clf;

%% Load data
fname = 'lab6.csv';
datatable = readtable(fname);   % makes data table with headers

time1 = datatable.t1;   % time (s)
V1    = datatable.ch1;  % sensor voltage (V)
time2 = datatable.t2;   % time (s)
V2    = datatable.ch2;  % filtered circuit output (V)

%% Convert sensor voltage to pressure
% MPX5050DP transfer function: Vout = Vs*(0.018*P + 0.04), P in kPa, Vs = 5 V
% Solving for P:
Vs = 5;
P_kPa = (V1/Vs - 0.04) / 0.018;
P = P_kPa * 760/101.325;   % kPa -> mmHg (1 atm = 101.325 kPa = 760 mmHg)

%% Keep only the real run
% The start of the file has leftover data from a previous run. The real run
% begins at the last big jump in pressure, around -15 s.
tStart = -15;   % s, adjust by looking at the plot
keep = time1 >= tStart;

%% Estimate mean arterial pressure
% The pulse amplitude grows, peaks, then fades as the cuff deflates. The
% cuff pressure at the peak is taken as the mean arterial pressure.
tMask = time2(keep) >= tStart + 3;                  % skip the jump at the start
V2k = V2(keep);
amp = movmax(V2k, 40) - movmin(V2k, 40);            % pulse size in a ~2 s window (20 S/s)
amp = movmean(amp, 100);                            % smooth over ~5 s
amp(~tMask) = 0;
[~, iPeak] = max(amp);

tk = time1(keep);
Pk = P(keep);
tPeak = tk(iPeak);
MAP = Pk(iPeak);

fprintf('Pulse amplitude peaks at %.0f s, cuff pressure about %.0f mmHg\n', tPeak, MAP);

%% Plot raw pressure and filtered signal (like Figure 2 in the handout)
figure();

subplot(2, 1, 1);
plot(time1(keep), P(keep));
hold on
plot(tPeak, MAP, 'ro');
xlabel('Time (s)');
ylabel('Cuff pressure (mmHg)');
title('Raw cuff pressure');
legend('cuff pressure', 'mean arterial pressure');

subplot(2, 1, 2);
plot(time2(keep), V2(keep) - median(V2(keep)));
xlabel('Time (s)');
ylabel('Filtered signal (V)');
title('Pulse after filtering');

% Optional: save the figure as an image
% exportgraphics(gcf, 'pressure_plot.png', 'Resolution', 300);
