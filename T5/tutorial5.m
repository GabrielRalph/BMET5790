clc;
clear;

cal = importdata("cal.dat");
Time = cal.data(:, 1);
V1 = cal.data(:,2);

plot(Time, V1)
grid on
xlabel('Time (s)')
ylabel("Differential Pressure (V)")
title("Pressure vs Time")

%%
fs = 1/(Time(2)-Time(1));
fc = 10;

Wn = fc/(fs/2);

offset = 3.785;

[b,a] = butter(3, Wn);

V1_offset = V1 - offset;

V1_fil = filter(b, a, V1_offset);

plot(Time, V1_fil)
grid on;
xlabel('Time (s)')
ylabel("Differential Pressure (V)")
title("Filtered Pressure")

% t = ginput(2);

%%
% start = t(1);
start_i = 556;
% stop = t(2);
stop_i = 1509;

range = start_i:stop_i;

%%
volume = cumsum(V1_fil(range))/fs;
plot(Time(range), V1_fil(range))
hold on
plot(Time(range), volume)
grid on
xlabel("Time (s)")
ylabel("Flow (V) and Volume (V.s)")
title("Flow and Volume of Filtered Data")
legend('Flow', 'Volume', 'Location', 'southwest')
hold off

%%
k = 1.4/min(volume);

plot(Time(range), k*V1_fil(range))
grid on;
xlabel('Time (s)')
ylabel("Differential Pressure (V)")
title("Scaled Filtered Pressure")

%% Part 2
normal = importdata("normal.dat");
Time2 = normal.data(:,1);
V2 = normal.data(:,2);

plot(Time2, V2)
grid on
xlabel("Time (s)")
ylabel("Differential Pressure (V)")
title("Normal Data")

%%

offset2 = mean(V2);

V2_offset = V2 - offset2;

fs = 1/(Time2(2)-Time2(1));
fc = 5;
Wn = fc/(fs/2);

[b,a] = butter(3, Wn);

V2_fil = filter(b,a,V2_offset);

V2_scaled = k*V2_fil;

plot(Time2, V2_scaled)
grid on
xlabel("Time (s)")
ylabel("Differential Pressure (V)")
title("Scaled and Filtered Normal Data")


% t = ginput(2);

%%
% start = t(1);
start_i = 100;
% stop = t(2);
stop_i = 13501;

range = start_i:stop_i;
%%
volume2 = cumsum(V2_scaled(range) - min(V2_scaled))/fs;


p = polyfit(Time2(range), volume2, 3);
v22 = -volume2 + polyval(p, Time2(range));

[y, x] = findpeaks(v22, Time2(range), "MinPeakHeight",0);
%
% p = polyfit(x, y, 5);
% p2 = polyval(p, Time2(range));
% 
% v22 = v22- p2;
% v22 = v22 - mean(v22);
% scatter(x, y);
hold on;
plot(Time2, V2_scaled);
hold on
plot(Time2(range), v22)
grid on
hold off
xlabel("Time (s)")
ylabel("Flow (L/s) and Volume (L)")
legend("Flow", "Volume", "Location", "northwest")
title("Flow and Volume of Normal Breathing")

%%

heavy = importdata("heavy.dat");
Time3 = heavy.data(:,1);
V3 = heavy.data(:,2);

plot(Time3, V3)
grid on
xlabel("Time (s)")
ylabel("Differential Pressure (V)")
title("Normal Data")

%%

offset3 = mean(V3);

V3_offset = V3 - offset3;

fs = 1/(Time3(2)-Time3(1));
fc = 5;
Wn = fc/(fs/2);

[b,a] = butter(3, Wn);

V3_fil = filter(b,a,V3_offset);

V3_scaled = k*V3_fil;

plot(Time3, V3_scaled)
grid on
xlabel("Time (s)")
ylabel("Differential Pressure (V)")
title("Scaled and Filtered Normal Data")


%%
clf;
V3v = cumsum(V3_scaled)/fs;
p = polyfit(Time3, V3v, 7);
py = polyval(p, Time3);
V3v = V3v - py;
% mean(V3v - py)
plot(Time3, V3v);
hold on;
plot(Time3, V3_scaled);
grid on;
xlabel("Time (s)")
ylabel("Differential Pressure (V)")
title("Scaled and Filtered Normal Data and volume")
legend(["Volume", "Flow Rate"])
%%
plot(V3v, V3_scaled)
grid on;
title("Long Volume vs Flow Rate");
xlabel("Volume");
ylabel("Flow Rate");