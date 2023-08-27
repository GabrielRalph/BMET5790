clc;
clear;

% Import data and sample rate
[speech, Fs] = audioread("audio&noise.mp4");

% Split data into speech and noise
y_speech = speech(:,1);
y_noise = speech(:,2);

% Number of datapoints
n = size(y_speech, 1);

% Decimating factor
k = round(Fs/(10000*2));

%%
% Decimated data
y_speech1 = decimate(y_speech, k);
y_noise1 = decimate(y_noise, k);

% Adjust sampling rate and number of datapoints
Fs1 = Fs/k;
n1 = n/k;

% Generate a time vector
t1 = linspace(0, n1 * 1/Fs1, n1);

% Plot noise and speech
grid on;
plot(t1, y_noise1);
hold on;
plot(t1, y_speech1);
xlabel("Time (s)");
ylabel("Amplitude (V)");
h = legend("Noise", "Speech");
title("Time Domain Sound Signal");

%%
rmsVector=[];
% Add to the rms vector, by standardising 250 data points at a time.
for k=250:n1
    rmsVector(k-249)=std(y_speech1(k-249:k));
end

k1 = 0.05;

gain=1./(k1+rmsVector');

y_speech2=y_speech1(250:n1).*gain;

t2=t1(250:n1);


%%
% Reduce gain to lie between -1 and 1 V
% y_speech3=y_speech2/max([max(y_speech2) abs(min(y_speech2))]);   

figure(2)
plot(t2, y_speech2) 
grid on;
xlabel("Time (s)");
ylabel("Amplitude (V)");
title(sprintf("Normalised Time Domain Sound Signal w/ %.2f offset", k1));


% hold off;
% grid on;
% plot(t2, y_speech3);


%%
figure(3)
spectrogram(y_speech2,512,256,512,(1/k)*Fs1);


axis([0,11,0,max(t2)])




