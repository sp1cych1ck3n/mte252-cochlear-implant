% Phase 2: Filter design (Tasks 4-9)
% Tasks 3.1, 3.2 and 3.6 (read, mono, resample to 16 kHz) are done by load_audio.m.
% The 1 kHz cosine of Task 3.7 is left out for now; it comes back in Phase 3.
clear; close all;

scriptDir = fileparts(mfilename('fullpath'));
audioFile = fullfile(scriptDir, 'MTE252_Task2', 'elderly.mp3');
[mono, fs] = load_audio(audioFile);

% design parameters
N = 8;                % number of channels
lowEdge = 100;        % Hz
highEdge = 7900;      % Hz, kept just under fs/2 = 8000 Hz because butter needs edges below Nyquist
bpOrder = 3;          % butter order for each bandpass (the bandpass filter has order 2*bpOrder)
lpCutoff = 400;       % Hz, envelope lowpass cutoff
lpOrder = 2;

% Task 4: log-spaced bandpass filter bank
edges = logspace(log10(lowEdge), log10(highEdge), N + 1);
centreFreq = sqrt(edges(1:end-1) .* edges(2:end));   % geometric mean, used in Phase 3

% Task 5: filter the sound with every bandpass
filteredSignal = zeros(length(mono), N);
for k = 1:N
    [b, a] = butter(bpOrder, [edges(k) edges(k+1)] / (fs / 2), 'bandpass');
    filteredSignal(:, k) = filter(b, a, mono);
end
if any(~isfinite(filteredSignal(:)))
    error('Filter output is not finite. Lower bpOrder or switch to second-order sections.');
end

t = (0:length(mono)-1)' / fs;

% Task 6: output of the lowest and highest frequency channels
figure;
subplot(2, 1, 1);
plot(t, filteredSignal(:, 1));
title(sprintf('Channel 1 output (%.0f-%.0f Hz)', edges(1), edges(2)));
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(2, 1, 2);
plot(t, filteredSignal(:, N));
title(sprintf('Channel %d output (%.0f-%.0f Hz)', N, edges(N), edges(N+1)));
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% Task 7: rectify
rectifiedSignal = abs(filteredSignal);

% Task 8: envelope = lowpass (400 Hz) of the rectified signal, designed once
[envelopeB, envelopeA] = butter(lpOrder, lpCutoff / (fs / 2), 'low');
envelopeSignal = filter(envelopeB, envelopeA, rectifiedSignal);

% Task 9: envelope of the lowest and highest frequency channels
figure;
subplot(2, 1, 1);
plot(t, envelopeSignal(:, 1));
title(sprintf('Channel 1 envelope (%.0f-%.0f Hz)', edges(1), edges(2)));
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(2, 1, 2);
plot(t, envelopeSignal(:, N));
title(sprintf('Channel %d envelope (%.0f-%.0f Hz)', N, edges(N), edges(N+1)));
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
