clc
clear

load("ecg_gb.txt")

%% Q1
n = length(ecg_gb);

Fs = 100;

t = linspace(0, 12, n);

%% Q2

figure(1)
plot(t, ecg_gb)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Raw ECG Data @ 100Hz sampling")

%% Q3

figure(2)
plot(t(1:0.5*Fs), ecg_gb(1:0.5*Fs))
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Raw ECG Data @ 100Hz sampling (0-0.5s)")

%% Q4
Fc = 25;

[b25,a25] = butter(3, Fc/(Fs/2));

disp(b25)
disp(a25)

ecg_fil25 = filter(b25, a25, ecg_gb);

figure(3)
plot(t, ecg_fil25)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Filtered ECG Data @ 25Hz cutoff")

%% Q4e

Fc = 5;

[b5,a5] = butter(3, Fc/(Fs/2))

disp(b5)
disp(a5)

ecg_fil5 = filter(b5, a5, ecg_gb);

figure(4)
plot(t, ecg_fil5)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Filtered ECG Data @ 5Hz cutoff")

%% Q5

[h25,w25] = freqz(b25, a25, n);

gain25 = abs(h25);

f = linspace(0, Fs/2, n);

figure(5)
plot(f, gain25)
hold on
yline(0.5)
xline(27.9)
grid on;
xlabel("Frequency (Hz)")
ylabel("Normalised Gain")
title("Frequency Response Of 3rd Order Butterworth Filter, Fc = 25 Hz")

%% Q5c

[h5,w5] = freqz(b5, a5, n);

gain5 = abs(h5);

figure(6)
plot(f, gain25)
grid on;
xlabel("Frequency (Hz)")
ylabel("Normalised Gain")
title("Frequency Response Of 3rd Order Butterworth Filters")
hold on;
plot(f, gain5)
yline(0.5)
xline(27.9)
xline(6)
legend("Fc = 25 Hz", "Fc = 5 Hz")

%% Q6

f = linspace(0, Fs/2, 512);

amp = fft(ecg_fil25(1:1024,1));
ampdB = 20*log10(abs(amp));

hold off;
figure(7)
plot(f, ampdB(1:512))
grid on;
xlabel("Frequency (Hz)")
ylabel("Relative Power Level (dB)")
title("Filtered ECG Spectrum @ Fc = 25 Hz")

%% Q6d

f = linspace(0, Fs/2, 35);

amp = fft(ecg_fil25(61:130,1));
ampdB = 20*log10(abs(amp));

figure(8)
subplot(2,1,1)
plot(t(61:130), ecg_fil25(61:130))
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Filtered Single Heartbeat @ 25Hz cutoff")
subplot(2,1,2)
plot(f, ampdB(1:35))
grid on;
xlabel("Frequency (Hz)")
ylabel("Relative Power Level (dB)")
title("Filtered Single Heartbeat Spectrum @ Fc = 25 Hz")