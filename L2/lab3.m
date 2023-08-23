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
head = ["Frequency (Hz)", "$(\cfrac{V_{out}}{V_{in}})^2$"];
tbl = [head; f(hi)', V_ratio(hi)'];
writematrix(tbl, "table3_1.csv");