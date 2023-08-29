clc;
clear;

% Import data and sample rate
[speech, Fs] = audioread("audio&noise.m4a");

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
k1 = 0.05;

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
n_channels = 8;

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
for i=1:n_channels
    [h(i,:),f(i,:)] = freqz(a(i,:), b(i,:), n2);

end

h1 = abs(h(1,:)');
h2 = abs(h(2,:)');
h3 = abs(h(3,:)');
h4 = abs(h(4,:)');
h5 = abs(h(5,:)');
h6 = abs(h(6,:)');
h7 = abs(h(7,:)');
h8 = abs(h(8,:)');

h_list = [h1, h2, h3, h4, h5, h6, h7, h8];

f1 = f(1,:)/pi*(Fs1/2);
f2 = f(2,:)/pi*(Fs1/2);
f3 = f(3,:)/pi*(Fs1/2);
f4 = f(4,:)/pi*(Fs1/2);
f5 = f(5,:)/pi*(Fs1/2);
f6 = f(6,:)/pi*(Fs1/2);
f7 = f(7,:)/pi*(Fs1/2);
f8 = f(8,:)/pi*(Fs1/2);

f_list = [f1, f2, f3, f4, f5, f6, f7, f8];

hold on
figure(5);
for i=1:n_channels
    plot(f_list(i), h_list(i))
    grid on;
    
    xlabel("Frequency(Hz)");
    ylabel("Normalised Gain");
    title("Passband characteristics of 8-channel Cochlear Implant");
    xRange=get(gca,'XTick');
    set (gca, 'XTickLabel', 2.^xRange);
end

hold off





