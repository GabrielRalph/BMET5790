La = ["Sound level meter(dB)", "Android App (dB)", "iPhone App (dB)"];

tble = [];
Po = 1.3;
data = {[
    65.4, 52.1, 53;
    74.8, 60.8, 55.9;
    84.8, 69.2, 62.9;
    94.8, 74.4, 65
],[
    63.9, 50.8,50.4;
    73.9, 55.9, 60.9;
    83.4, 64.6, 58;
]; "<b>1000Hz</b>", "<b>400Hz</b>"};

for i = 1:2
    A = data{1, i};
    % Differences
    Adif = A(2:end, :) - A(1:(end-1), :);
    % To Sound Preasure
    Adifp = 10.^(Adif/20) * Po;
    % Average of sound preasure
    Adiffpm = mean(Adifp);
    % Convert Averages back to dB
    Adiffpd = 20*log10(Adiffpm/Po);
    
    Adiffpm = arrayfun(@(x) sprintf("%.2f", x), Adiffpm);
    Adiffpd = arrayfun(@(x) sprintf("%.2f", x), Adiffpd);
    
    head = [data{2, i}, "", "", "", "", "", ""];
    if i == 1
        head = [head; " ","<b>Sound level meter(dB)</b>", "<b>Differnece (dB)</b>", "<b>Android App (dB)</b>", "<b>Difference (dB)</b>", "<b>iPhone App (dB)</b>", "<b>Difference (dB)</b>"];
    end
    tble = cat(1, tble, [head
            repmat(" ", length(A(:,1)), 1), A(:, 1), ["-";Adif(:, 1)], A(:, 2), ["-";Adif(:, 2)], A(:, 3), ["-";Adif(:, 3)];
            
            "<b>Average (dB)</b>", " " ,Adiffpd(1), " ", Adiffpd(2), " ", Adiffpd(3)]);
end
writematrix(tble,"table1.csv");

%%
Bl = ["<b>Player Type</b>", "<b>Music Genre</b>", "<b>Comfortable SPL (dB)</b>", "<b>Loudest SPL (dB)</b>"];
B = ["Apple Airpods Gen 3",                                 "EDM",          85.6, 101;
     "Xiaomi in",                                           "Baby Metal",   93,   94;
     "Sennheiser cclosed back noise cancelling headphones", "Pop",          58,   60;
     "Sony closed back headphones",                         "Pop",          70,   75;
     "Audio technica in ear buds",                          "Metal",        80,   "-"];
writematrix([Bl; B], "table3.csv");
%%

Lc = ["<b>Range(m)</b>", "<b>Test 1 SBL (dB)</b>", "<b>Test 2 SBL (dB)</b>"];
C = [0.1,     115.6,  99;
     2.1,     83.1,   83.4;
     9.1,    82.1,   81.3;
     21.1,    72.8,   75.1;
     27.1,    74.2,   71.7];



avgC = mean(C(:, 2:3), 1);
logCx = log(C(:, 1));

% Cp = 10.^(C(1, 2:end)/20);
% Ip = (C(1,1)./C(:, 1)).^2 * Cp;
% Ipd = 20*log10(Ip)
% 
% semilogx(C(:, 1), Ipd(:, 2), C(:, 1), Ipd(:, 1)); %, lx, ly);
% hold on;
semilogx(C(:, 1), C(:, 2), C(:, 1), C(:, 3)); %, lx, ly);



xlabel("Distance (m)");
ylabel("SPL (dB)");
legend(Lc(2:end));
title("Sound Pressure Level vs Range");
grid on;

saveas(gcf, "plot1", "svg");
writematrix([Lc; C],"table2.csv");
%%
audiodevreset;
fs = 44100;
x = linspace(0, 10000, fs*3);

f1 = 2.1233534;


yr = sin(x) + sin(f1*x);

sound(yr, fs);