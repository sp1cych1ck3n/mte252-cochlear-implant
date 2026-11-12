scriptDir = fileparts(mfilename('fullpath'));
% SR = sampling rate
[mono, SR] = load_audio(fullfile(scriptDir, 'MTE252_Task2', 'elderly.mp3'));

% Task 4: make N a parameter
fs = SR;
N = 10;

% Task 4: build the edges (logarithmic spacing), define the channel bandwidths
% top edge is kept just under fs/2 = 8000 Hz because butter needs edges below the Nyquist frequency
edges = logspace(log10(100), log10(7990), N + 1);

% Task 5: filter each signal through every channel
filteredSignal = zeros(length(mono), N);
for i = 1:N
    normalized = [edges(i), edges(i+1)] / (fs / 2);
    [b, a] = butter(2, normalized, 'bandpass');
    filteredSignal(:, i) = filter(b, a, mono);
end

% Task 6: plot lowest and highest channels
figure;
plot(filteredSignal(:, 1));
title('Phase 2: Task 6, Lowest and Highest Frequency Channels');
xlabel('Sample Number');
ylabel('Amplitude');
hold on

plot(filteredSignal(:, N));
legend('Lowest', 'Highest');
hold off

% Task 7: rectify
rectifiedSignal = abs(filteredSignal);

% Task 8: detect the envelopes of all rectified signals using a lowpass filter with 400 Hz cutoff
[envelopeB, envelopeA] = butter(2, 400 / (fs / 2), 'low');
envelopeSignal = filter(envelopeB, envelopeA, rectifiedSignal);

% Task 9: Plot the extracted envelope of the lowest and highest frequency channels.
figure;
plot(envelopeSignal(:, 1));
title('Phase 2: Task 9, Extracted Envelope');
xlabel('Sample Number');
ylabel('Amplitude');
hold on

plot(envelopeSignal(:, N));
legend('Lowest Frequency Channel', 'Highest Frequency Channel')
hold off
