% notching out the vuvuzela noise
% vuv_notch.m
% import the data file vuvuzela - with voice
% it generates two variables, a data array (data) and a sample rate (t)
% to listen to the sound we use sound
% sound(data,fs)
% we identified the fundamental to be at 220Hz and the various harmonics
% extending up to about 1.3kHz
% these are the centre frequencies relative to half the sampling frequency
audiodevreset;
[data, fs] = audioread("vuv.mp4");
isFiltered = 1;
fs2 = fs/2;
w1 = 220/fs2;
w2 = 440/fs2;
w3 = 660/fs2;
w4 = 880/fs2;
w5 = 1100/fs2;
w6 = 1320/fs2;
% generate the vectors
W1 = [0.9*w1 1.1*w1];
W2 = [0.9*w2 1.1*w2];
W3 = [0.9*w3 1.1*w3];
W4 = [0.9*w4 1.1*w4];
W5 = [0.9*w5 1.1*w5];
W6 = [0.9*w6 1.1*w6];
% generate the filter coefficients
[b1,a1] = butter(3,W1,'stop');
[b2,a2] = butter(3,W2,'stop');
[b3,a3] = butter(3,W3,'stop');
[b4,a4] = butter(3,W4,'stop');
[b5,a5] = butter(3,W5,'stop');
[b6,a6] = butter(3,W6,'stop');

%pause
if isFiltered
    data1 = filter(b1,a1,data);
    data2 = filter(b2,a2,data1);
    data3 = filter(b3,a3,data2);
    data4 = filter(b4,a4,data3);
    data5 = filter(b5,a5,data4);
    data6 = filter(b6,a6,data5);
    data = data1;
end

% deviceWriter = audioDeviceWriter(fs)
% devices = getAudioDevices()
% % I wish to change the audio device here between built-in and my sound card.
% deviceWriter.Device(3
% info = audiodevinfo
sound(data1,fs)