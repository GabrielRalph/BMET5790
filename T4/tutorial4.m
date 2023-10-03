clc
clear

filename = "Sphygmo1.txt";
data = readtable(filename);
t = data{:,1};
v = data{:,2};

plot(t,v)
grid on
xlabel("Time (s)")
ylabel("Signal (V)")
title("Raw Sphygmomanometer Data")

%%
by = 0.28;
m = 191/(0.796-by);
P = m*(v - by);

plot(t,P)
xlabel("Time (s)")
ylabel("Pressure (mmHg)")
title("Scaled Sphygmomanometer Data")

%%
Fs = 1/0.002;
t0 = 15;
tf = 37;
ti = t0*Fs:tf*Fs;
plot(t(ti),P(ti))
xlabel("Time (s)")
ylabel("Pressure (mmHg)")
title("Scaled Sphygmomanometer Data (15-37s)")

%%
Fc = 0.5;
[b,a] = butter(3,Fc/(Fs/2), "low");
disp(a)

P_filt = filter(b,a,P);
plot(t(ti),P_filt(ti))
xlabel("Time (s)")
ylabel("Pressure (mmHg)")
title("Low Pass Filtered Sphygmomanometer Data (15-37s)")

%%
[b1,a1] = butter(3,Fc/(Fs/2), "high");
P_filt1 = filter(b1,a1,P_filt);

plot(t(ti),P_filt1(ti))
xlabel("Time (s)")
ylabel("Pressure (mmHg)")
title("Low and High Pass Filtered Sphygmomanometer Data (15-37s)")

[x,y] = ginput(21);
[x1,y1] = ginput(20);

%%
y_peak = spline(x,y,t(ti));
y_trough = spline(x1,y1,t(ti));

plot(t(ti),P_filt1(ti))
hold on
plot(t(ti), y_peak)
plot(t(ti), y_trough)
xlabel("Time (s)")
ylabel("Pressure (mmHg)")
title("Low and High Pass Filtered Sphygmomanometer Data (15-37s)")