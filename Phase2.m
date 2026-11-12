[mono, SR] = load_audio(fullfile(scriptDir, 'MTE252_Task2', 'elderly.mp3'));

% Task 4: make N a parameter
fs = 16000;
N = 10;

% Task 4: build the edges (logarithmic spacing), define the channel bandwidths
edges = logspace(log10(100), log10(8000), N + 1);

normalized = [edges(i), edges(i+1)] / (fs / 2);

% Task 5: filter each signal through every channel
for i = 1:N
    [b, a] = butter(2, normalized, 'bandpass');
    filteredSignal(:, i) = filter(b, a, mono)

    % Task 6: plot lowest and highest channels
    figure;
    plot(filteredSignal(:,1));
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
    envelopeSignal(:, i) = filter(envelopeB, envelopeA, rectifiedSignal(:, i));

    % Task 9: Plot the extracted envelope of the lowest and highest frequency channels.
    figure;
    plot(rectifiedEnvelope(:, 1));
    title('Phase 2: Task 9, Rectified Envelope');
    xlabel('Sample Number');
    ylabel('Amplitude');
    hold on

    plot(rectifiedEnvelope(:, N));
    legend('Lowest Frequency Channel', 'Highest Frequency Channel')
    hold off
end
