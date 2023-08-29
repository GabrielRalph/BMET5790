clear;
[y, Fs_0] = audioread("audio&noise.mp4");

k = 2;
y_speech = decimate(y(:, 1), k);
Fs = Fs_0/2;

t = (0:(length(y_speech) - 1))/Fs;


% Make Bandpass filters
n_channels = 8;
F_min=100;
F_max=10000;
BP_scaledWidth=1.02;

fc = {}; % Filter Coefficients
k=(F_min/F_max)^(1/(1-n_channels));
F_centre = (F_max * k .^ ((1:n_channels)-n_channels))';
F_range =  F_centre * [1/BP_scaledWidth BP_scaledWidth];
fscale = 1/(Fs/2);
for i = 1:n_channels
    [fc{i}.b, fc{i}.a] = butter(2, fscale * F_range(i, :), "bandpass");
end

% Filter the speech using the filters
ychan = cellfun(@(c) filter(c.b, c.a, y_speech), fc, 'UniformOutput',false);

%% Plot Frequency Response of Bandpass Filters
clf;
for i = 1:n_channels 
    [h, w] = freqz(fc{i}.b, fc{i}.a, 10000, Fs);
    h = abs(h);
    plot(log2(w), h);
    hold on;
end
set (gca, 'XTickLabel', 2.^xticks);


%% Plot Spectographs
for i = 1:n_channels
    subplot(4, 2, i);
    spectrogram(ychan{i}, 512, 256, 512, Fs);
    title(sprintf("%.0fHz Bandpass Filter", F_centre(i)));
end
colormap(turbo);

%% Plot Time Domain Signals
for i = 1:n_channels
    subplot(8, 1, i);
    plot(t, ychan{i});
    ylim([-0.1, 0.1]);
end


