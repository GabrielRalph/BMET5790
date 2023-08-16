function sound_gen(ampl)
if(ampl >10)
    ampl = 10;
end

ampl = ampl/10;

% generate 1khz with different amplitudes
% sound_gen.m
fs = 22000;      % sample frequency (Hz)
ts = 1/fs;
t = (0:ts:10);  % 10 seconds
freq = 1000;    % frequency (Hz)
sig = ampl*cos(2*pi*freq.*t);
sound (sig,fs);

plot(t(1:100),sig(1:100));
grid
xlabel('Time (sec)')
ylabel('Sig (V)')
