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