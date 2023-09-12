clc
clear

load("ecg_gb.txt")

%% Q1
n = length(ecg_gb);

Fs = 100;

t = linspace(0, 12, n);

%% Q2

plot(t, ecg_gb)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Raw ECG Data @ 100Hz sampling")

%% Q3

plot(t(1:0.5*Fs), ecg_gb(1:0.5*Fs))
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Raw ECG Data @ 100Hz sampling (0-0.5s)")

%% Q4
Fc = 25;

[b25,a25] = butter(3, Fc/(Fs/2))

ecg_fil25 = filter(b25, a25, ecg_gb);

plot(t, ecg_fil25)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Filtered ECG Data @ 25Hz cutoff")

%% Q4e

Fc = 5;

[b5,a5] = butter(3, Fc/(Fs/2))

ecg_fil5 = filter(b5, a5, ecg_gb);

plot(t, ecg_fil5)
grid on;
xlabel("Time (s)")
ylabel("Signal (V)")
title("Filtered ECG Data @ 5Hz cutoff")

%% Q5

[h25,w25] = freqz(b25, a25, n);

gain25 = abs(h25);

f = linspace(0, Fs/2, n);

plot(f, gain25)
grid on;
xlabel("Frequency (Hz)")
ylabel("Normalised Gain")
title("Frequency Response Of 3rd Order Butterworth Filter, Fc = 25 Hz")

%% Q5c

[h5,w5] = freqz(b5, a5, n);

gain5 = abs(h5);

plot(f, gain25)
grid on;
xlabel("Frequency (Hz)")
ylabel("Normalised Gain")
title("Frequency Response Of 3rd Order Butterworth Filters")
hold on;
plot(f, gain5)
legend("Fc = 25 Hz", "Fc = 5 Hz")

%% Q6

f = linspace(0, Fs/2, 512);

amp = fft(ecg_fil25(1:1024,1));
ampdB = 20*log10(abs(amp));

plot(f, ampdB(1:512))
grid on;
xlabel("Frequency (Hz)")
ylabel("Relative Power Level (dB)")
title("Filtered ECG Spectrum @ Fc = 25 Hz")