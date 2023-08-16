La = ["Sound level meter(dB)", "Android App (dB)", "iPhone App (dB)"];
A = [
    63.9, 52.1,53;
    73.9, 60.8, 55.9;
    83.4, 69.2, 62.9;
    94.8, 75.4, 65;
];

Po = 1.3;
A2 = [65.4, 52.1, 53;
      74.8, 60.8, 55.9;
      84.8, 69.2, 62.9;
      94.8, 74.4, 65];
A2d = A2(2:end, :) - A2(1:(end-1), :);
A2p = 10.^(A2d/20) * Po;
A2pm = mean(A2p);
A2dm = 20*log10(A2pm/Po);



Lab2 = ["Sound level meter(dB)", "Differnece (dB)", "Android App (dB)", "Difference (dB)", "iPhone App (dB)", "Difference (dB)";
        A2(:, 1), ["-";A2d(:, 1)], A2(:, 2), ["-";A2d(:, 2)], A2(:, 3), ["-";A2d(:, 3)];
        "Mean",A2dm(1), "Mean", A2dm(2), "Mean", A2dm(3)];
writematrix(Lab2,"table1.csv");

%%

B = ["Apple Airpods Gen 3",                                 "EDM",          85.6, 101;
     "Xiaomi in",                                           "Baby Metal",   93,   94;
     "Sennheiser cclosed back noise cancelling headphones", "Pop",          58,   60;
     "Sony closed back headphones",                         "Pop",          70,   75;
     "Audio technica in ear buds",                          "Metal",        80,   0];

Lc = ["Range(m)", "R1", "R2"];
C = [0.1,     115.6,  99;
     2.1,     83.1,   83.4;
     9.1,    82.1,   81.3;
     21.1,    72.8,   75.1;
     27.1,    74.2,   71.7]



avgC = mean(C(:, 2:3), 1);
logCx = log(C(:, 1));
% p = polyfit(logCx, avgC, 2);

% lx = linspace(0.1, 27.1, 5);
% ly = polyval(p, log(lx));
% str2num(B(:, 3))

semilogx(C(:, 1), C(:, 2), C(:, 1), C(:, 3)); %, lx, ly);
xlabel("Distance (m)");
ylabel("SPL (dB)");
legend(["Repeat 1", "Repeat 2"]);
grid on;


%%
audiodevreset;
fs = 44100;
x = linspace(0, 10000, fs*3);

f1 = 2.1233534;


yr = sin(x) + sin(f1*x);

sound(yr, fs);