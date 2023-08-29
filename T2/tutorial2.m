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
t = linspace(0,0.5,4000);
signals = zeros([8, length(t)]);
for i=1:8
    signals(i,:) = sin(2*pi*i*10*t);
end

summed_signal = zeros(1,length(t));
norm_list = zeros(8,length(t));

for k=1:8
    for i=1:length(t)
        value = 0;
        for j=1:8
            dp = signals(j,i);
            weighted_dp = dp*zf4(j,k);
            value = value + weighted_dp;
        end
        summed_signal(i) = value;
    end
    norm_signal = summed_signal/abs(max(summed_signal));
    norm_list(k,:) = norm_signal;
    figure(k)
    plot(t, norm_signal)
    xlabel("Time (s)")
    ylabel("Normalised Amplitude")
    title(sprintf("Normalised Sound Column %d", k))
end

