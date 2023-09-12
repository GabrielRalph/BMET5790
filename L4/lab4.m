addpath("../")
%% Question 1
R4 = 10^4;
R5 = 10^6;
C1 = 4.7e-6;
C3 = 12e-12;



Z1 = @(f) 1./(1i * C1 * (2 * pi * f)) + R4;
Z2 = @(f) 1./(1i * C3 * (2 * pi * f) + 1/R5);
Z3 = @(f) 1./(1/R5);
G = @(f) Z2(f)./Z1(f);

clc;
% As f -> 0 
fprintf("Q1.a:\t The gain as frequency aproaches 0Hz is %.0f\n", abs(G(1e-12)));

% As f = 500Hz
G_500Hz = abs(G(500));
fprintf("Q1.b:\t The gain at a frequency of 500Hz is predicted to be %.0f\n", G_500Hz)

G_20kHz = abs(G(20e3));
fprintf("Q3:\t The gain at a frequency of 20kHz is predicted to be %.0f\n", G_20kHz)

f_range = 1.2.^linspace(-30, 100, 10000);
G_mag = abs(G(f_range));
semilogx(f_range, G_mag);
xline(500);
xline(20e3);
%% Looking at the effects of C3
f_range = 1.2.^linspace(-30, 100, 1000);
c1 = 4.7e-6;
Z1 = @(f, c1) 1./(1i * c1 * (2 * pi * f)) + R4;
Z2 = @(f, c3) 1./(1/R5);
G = @(f, c1, c3) Z2(f, c3)./Z1(f, c1);

C3 = [12e-12; 12e-13; 12e-14; 12e-15];
G_1 = abs(G(f_range, C1, C3));


plot(G_1')
legend("C3 = " + C3)
fprintf("Q2:\t C3 acts as a low pass filter\n");

