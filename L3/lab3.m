addpath("../");
clc; 

mu_r = 1.05;
mu_o = 4e-7 * pi;
N = 550;
Acoil = pi * (13e-3/2)^2; 
Lcoil = 5e-3; %mm

L = mu_r * mu_o * N^2 * Acoil / Lcoil;

uprint(L, "H");

rho_cu = 1.72e-8;
lwire = 550*pi*13e-3;
Acu = pi * (0.0281e-3/2)^2;

R = rho_cu * lwire / Acu;

uprint(R, "ohm");

omega = 1000 * 2 * pi;

z = R + 1i * omega * L;
Z = abs(z);
theta = atan(imag(z) / real(z));
theta_deg = theta * 180 / pi;
fprintf("%s /_ %s\n", funit(Z,"ohm"), funit(theta_deg, "deg"));

clf
Rload = 600;
f = (0:1:20) * 1000;
V_ratio = abs((Rload ./ (R + 1i*2*pi*f*L + Rload)).^2);
plot(f/1000, V_ratio);
hold on;


p1k = V_ratio(2);
[~, mfi] = min(abs(V_ratio - p1k/2));
fhalf = f(mfi) + 1;
uprint(fhalf, "Hz");
yline(V_ratio(mfi));
hold on;
xline(f(mfi)/1000);
nticks = sort([max(V_ratio), yticks, V_ratio(mfi)]);
yticks(nticks);
xlabel("Frequency kHz");
ylabel("(V_{out} / V_{in})^2");
title("Frequency Gain Response");

saveas(gcf, "plot3_1", "svg");
hi = 1:2:length(f);
head = ["Frequency (kHz)", "$(\cfrac{V_{out}}{V_{in}})^2$"];
freq = arrayfun(@(x) sprintf("%.f", x), (f(hi)/1000)');
gain = arrayfun(@(x) sprintf("%.3f", x), V_ratio(hi)');
tbl = [head; freq, gain];
writematrix(tbl, "table3_1.csv");

po = 20e-6;

spl = 60 - 20 * log10(50/30);

Zair = 1.23 * 340;
prms = po * 10 ^(spl/20);
Pm = sqrt(2) * prms;
uprint(Pm, "Pa");

vmax = Pm / Zair;% m/s
uprint(vmax, "m/s");

beta = 0.1;

Vout1 = beta * lwire * vmax;
uprint(Vout1, "V");

Vout2 = Vout1 * sqrt(V_ratio(1));
uprint(Vout2, "V");

Vout2_rms = Vout2 /sqrt(2);
uprint(Vout2_rms, "V");

s = [-70, -76];
s2 = 10.^(s/20);
10^(-73/20)
mean(s2)
% spl2 = 20 * log10(101.325e3/20);
% prms2 = po * 10 ^(spl2/20);
% Pm2 = sqrt(2) * prms2;
% vmax2 = Pm2 / Zair;% m/s
% Vout12 = beta * lwire * vmax2;
% uprint(Vout12, "V");

%%
