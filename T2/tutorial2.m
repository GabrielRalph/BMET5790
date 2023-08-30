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

%%
im_size = size(zf);
scaled_size = im_size/8;

h = ones(scaled_size)/prod(scaled_size);

zf2 = filter2(h,zf);

imagesc(zf2)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Default Image")

%%
zf3 = zf2(11:22:165,11:22:165);
disp(zf3)

imagesc(zf3)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Default Image")

%%
min_val = min(zf3, [], 'all');
max_val = max(zf3, [], 'all');

zf4 = floor(4*(zf3 - min_val)/(max_val - min_val));

imagesc(zf4)
colormap("gray")
xlabel("X-Pixels")
ylabel("Y-Pixels")
colorbar()
title("Default Image")

%%
Fs = 8000;        % frequncy of signals
n = size(zf4, 2); % number of signals
L = 4000;         % points in signals

t = linspace(0,L/Fs,L)';
waves = sin(2*pi*10*t*(1:n));

% Multiple columns of image with the wave signals
weighted_cols = waves * zf4; % much simpler then 3 nested loops
% Normalise 
weighted_cols = weighted_cols ./ max(abs(weighted_cols));

% plot signals
for i = 1:n
    subplot(n, 1, i);
    plot(t, weighted_cols(:, i));
    if i == 4; ylabel("Normalised Amplitude"); end;
    title(sprintf("Normalised Sound Column %d", i));
end
xlabel("Time (s)");


%%
% Fast furiour transform
f = Fs*(0:ceil(L/2 - 1))/L;
y = fft(weighted_cols, [], 1);

% Select first half and normalise to 4
y1 = abs(y(1:ceil(L/2), :));
y1 = 4 * y1 ./ max(y1);

col_to_check = 4;
% Plot frquency amplitudes for frequencies up 100Hz
plot(f(f<100), y1(f<100, 4));

