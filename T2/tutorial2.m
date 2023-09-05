%% Q1: Plotting the raw image
clc;
clear;

[z]=imread('face2','bmp');
zf=double(z);		% convert the image data to floating point

imagesc(zf)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Default Image")

%% Q2.1: Spatial filtering (reduce to 8x8)
im_size = size(zf);
scaled_size = im_size/8;

h = ones(scaled_size)/prod(scaled_size);

zf2 = filter2(h,zf);

imagesc(zf2)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Spatially Filtered Image")

%% Q3.1
zf3 = zf2(11:22:165,11:22:165);
disp(zf3)

imagesc(zf3)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Sub Sampled Image")

%% Q3.2: Sub sampling (reduce the scale to 0-4)
min_val = min(zf3, [], 'all'); % finds the absolute minimum
max_val = max(zf3, [], 'all'); % finds the absolute maximum

zf4 = floor(4*(zf3 - min_val)/(max_val - min_val));
% subtract the min to make zero the minimum
% divide by the range to normalise
% multiply by 4 to get four quantised values

imagesc(zf4)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Quantised 8x8 Image")

%% Q4: Sensory substitution (image to audio)
Fs = 8000;        % frequncy of signals
n = size(zf4, 2); % number of signals
L = 4000;         % points in signals
fl = 10*(1:n);    % frequency levels

t = linspace(0,L/Fs,L)';
waves = sin(2*pi*t*fl);

% Multiple columns of image with the wave signals
weighted_cols = waves * zf4; % much simpler then 3 nested loops
weighted_cols = weighted_cols ./ max(abs(weighted_cols));

% plot signals
for i = 1:n
    subplot(n/2, 2, i);
    plot(t, weighted_cols(:, i));
    if i == 4; ylabel("Normalised Amplitude"); end;
    title(sprintf("Normalised Sound Column %d", i));
end
xlabel("Time (s)");


%% Q4.2: FFT

% Fast furiour transform
f = Fs*(0:ceil(L/2 - 1))/L;
y = fft(weighted_cols);

% Select first half and normalise to max value in image column
y1 = abs(y(1:ceil(L/2), :));
y1 = max(zf4) .* y1 ./ max(y1);

col_to_check = 4;
ex_a = zf4(:, col_to_check); % expected amplitudes 

% Plot frquency response for frequencies up 100Hz
clf;
plot(f(f<100), y1(f<100, col_to_check));
hold on;
% Plot expected frequency responses
scatter(fl, ex_a); 
ylim([0, 4.5]);
ylabel("Amplitude");
xlabel("Frequency (Hz)");
title(sprintf("Frequency response of Column %d Signal", col_to_check))
legend(["FFT results", "Expected peaks"]);

%%
f1 = 293.66;
f_ratios = [0 4 7 12 16 19 24 28] / 12;

fl = f1 * 2 .^ f_ratios;

waves = sin(2*pi*t*fl);

% Multiple columns of image with the wave signals
weighted_cols = waves * zf4;
weighted_cols = weighted_cols ./ max(abs(weighted_cols));

stereo_weights = [1:4, 4:7];
right = reshape(weighted_cols .* stereo_weights, [], 1);
left = reshape(weighted_cols .* flip(stereo_weights), [], 1);
V_norm = sqrt(max(left)^2 + max(right)^2);
stereo = [left, right] ./ [max(left), max(right)];

sound(stereo, Fs);
audiowrite('image2audio.wav', stereo, Fs);

%%
clear
clc

[y,Fs] = audioread("image2audio.wav");
sound(y, Fs)


