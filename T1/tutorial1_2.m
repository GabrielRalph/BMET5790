clc;
clear;

% Import data and sample rate
[speech, Fs] = audioread("test.m4a");

% Split data into speech and noise
y_speech = speech(:,1);
% y_noise = speech(:,2);

% Number of datapoints
n = size(y_speech, 1);

% Decimating factor
k = round(Fs/(10000*2));


%%
% Decimated data
y_speech1 = decimate(y_speech, k);
% y_noise1 = decimate(y_noise, k);

% Adjust sampling rate and number of datapoints
Fs1 = Fs/k;
n1 = n/k;

% Generate a time vector
t1 = linspace(0, n1 * 1/Fs1, n1);
%%
% Plot noise and speech
grid on;
plot(t1, y_noise1);
hold on;
plot(t1, y_speech1);
xlabel("Time (s)");
ylabel("Amplitude (V)");
j = legend("Noise", "Speech");
title("Time Domain Sound Signal");

%%
rmsVector=[];
% Add to the rms vector, by standardising 250 data points at a time.
for k=250:n1
    rmsVector(k-249)=std(y_speech1(k-249:k));
end

gain=1./(rmsVector');

y_speech_gain = y_speech1(250:n1).*gain;

t_gain = t1(250:n1);

n_gain = length(y_speech_gain);

figure(2)
grid on;
plot(t_gain, y_speech_gain);
hold on;
xlabel("Time (s)");
ylabel("Amplitude (V)");
title("Time Domain Normalised Sound Signal");



%%
k1 = 0.1;

gain=1./(k1+rmsVector');

y_speech2=y_speech1(250:n1).*gain;

t2=t1(250:n1);
n2=length(y_speech2);

% Reduce gain to lie between -1 and 1 V
y_speech3=y_speech2/max([max(y_speech2) abs(min(y_speech2))]);

figure(3)
grid on;
plot(t2, y_speech3);
hold on;
xlabel("Time (s)");
ylabel("Amplitude (V)");
title(sprintf("Time Domain Normalised Sound Signal w/ %.2f offset", k1));

%%
figure(4)
spectrogram(y_speech3,1024,512,2048,Fs1);
title("Spectrogram Speech 1024 512 2048")
colormap("jet")
axis([0,11,0,max(t2)])

%%
n_channels = 5;

% Determine frequency range for each channel
F_min=100;
F_max=10000;
F_centre=zeros(n_channels,1);
F_range=zeros(n_channels,2);
k=(F_min/F_max)^(1/(1-n_channels));
BP_scaledWidth=1.02;
for i=1:n_channels
    F_centre(i)=F_max*k^(i-n_channels);
    F_range(i,:)=F_centre(i)*[1/BP_scaledWidth BP_scaledWidth];

    [b(i,:), a(i,:)]=butter(2, [F_range(i,1) F_range(i,2)]/(Fs1/2), 'bandpass');
end


disp(b(8,:))
disp(a(8,:))

%%
hold on;
for i=1:n_channels
    [h(i,:),f(i,:)] = freqz(b(i,:), a(i,:), n2);

    h(i,:) = abs(h(i,:)');
    f(i,:) = f(i,:)/(2*pi)*Fs1;
    plot(log2(f(i,:)), h(i,:))
end

yline(2^(-1/2));
xlabel("Frequency (Hz)");
ylabel("Normalised Gain");
title("Passband Characteristics of 8-Channel Cochlear Implant")
leg = legend("Channel 1", "Channel 2", "Channel 3", "Channel 4 (Gain = 0.707 at 706 and 734 Hz)", "Channel 5", "Channel 6", "Channel 7", "Channel 8", "Location","southwest");
ylim([0 1]);
xRange=get(gca,'XTick');
set (gca, 'XTickLabel', 2.^xRange);

%%
for i=1:n_channels
    subplot(4,2,i);
    y = filter(b(i,:), a(i,:), y_speech3);
    spectrogram(y,1024,512,2048,Fs1)
    title(sprintf("%.0fHz Bandpass Filter", F_centre(i)));
end
colormap('jet');

%%
title("Time Domain Signals Out of Filter Bank")


for i=1:n_channels
%     subplot(8,1,i);
    y = filter(b(i,:), a(i,:), y_speech3);
%     plot(t2, y);
    ylim([-0.2, 0.2]);
     ylabel(sprintf("C%d (V)", i));
    ch(:, i) = y;
end

%%
ch = zeros(n2, n_channels);
for i=1:n_channels
    ch(:, i) = filter(b(i,:), a(i,:), y_speech3);
end
merge = sum(ch, 2);
merge = merge / max(abs(merge));
plot(t2, merge);
ylabel("Amplitude (V)");
xlabel("Time (s)");
title(sprintf("%.f Channel Compression", n_channels));
sound(merge, Fs1);

