
clf;
T1 = table2array(readtable("EMG"));

t = T1(:, 1);
emg = T1(:, 2);

t2 = t(2:end);
demgdt = (emg(2:end) - emg(1:end-1)) ./ (t(2:end) - t(1:end-1));
demgdt = abs(demgdt);

ewa = demgdt;
% lambda = 0.999;
% for i = 2:length(ewa)
%     ewa(i) = ewa(i-1) * lambda + demgdt(i) * (1 - lambda);
% end


ths = [0.7, 5, 16, 1000];
thi = (ewa > ths(1:end-1)) & (ewa < ths(2:end));
slow = [t2(thi(:, 1)), ewa(thi(:, 1))];
medium = [t2(thi(:, 2)), ewa(thi(:, 2))];
fast = [t2(thi(:, 3)), ewa(thi(:, 3))];
s = {slow, medium, fast};


subplot(2, 1, 1);
plot(t, emg);
ylabel("Amplitude");
xlabel("Time (s)");
title("Filtered EMG Signal");
if ~exist("p3", "var")
    p3 = ginput(3);
end
grid on;

lbls = ["slow", "medium", "fast"];
for i = 1:3
    text(p3(i, 1), p3(i, 2), lbls(i), "HorizontalAlignment","center");
end

cls = [1, 0, 0; 0, 1, 0; 0, 0, 1];
subplot(2,1,2);
plot(t2, demgdt);
hold on;
for i = 1:3
    ps = s{i};
    scatter(ps(:, 1), ps(:, 2), 3, cls(i, :), 'filled');
    hold on;
end
plot(t2, ewa);
ylabel("|dAmplitude/dt|");
xlabel("Time (s)");
title("Rectified Derivitive of Filtered EMG Signal");
legend(["", lbls])
grid on;