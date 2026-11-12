clear; 
clc;

scriptDir = fileparts(mfilename('fullpath'));
% SR = sampling rate

[mono, SR] = load_audio('/Users/diya/Documents/MATLAB/cochlear/audio files/baby_crying.mp3');

% Task 4: make N a parameter
fs = SR;
N = 10;

% Task 4: build the edges (logarithmic spacing), define the channel bandwidths
% top edge is kept just under fs/2 = 8000 Hz because butter needs edges below the Nyquist frequency
edges = logspace(log10(100), log10(7900), N + 1);

% Task 5: filter each signal through every channel
filteredSignal = zeros(length(mono), N);
for i = 1:N
    normalized = [edges(i), edges(i+1)] / (fs / 2);
    [b, a] = butter(2, normalized, 'bandpass');
    filteredSignal(:, i) = filter(b, a, mono);
end

% Task 6: Plot lowest and highest frequency channels separately
figure;

% Lowest Frequency Channel
subplot(2, 1, 1);
plot(filteredSignal(:, 1));
title('Phase 2: Task 6, Lowest Frequency Channel');
xlabel('Sample Number');
ylabel('Amplitude');

% Highest Frequency Channel
subplot(2, 1, 2);
plot(filteredSignal(:, N));
title('Phase 2: Task 6, Highest Frequency Channel');
xlabel('Sample Number');
ylabel('Amplitude');

% Task 7: rectify
rectifiedSignal = abs(filteredSignal);

% Task 8: detect the envelopes of all rectified signals using a lowpass filter with 400 Hz cutoff
[envelopeB, envelopeA] = butter(2, 400 / (fs / 2), 'low');
envelopeSignal = filter(envelopeB, envelopeA, rectifiedSignal);


% Task 9: Plot extracted envelopes separately
figure;

% Lowest Frequency Channel
subplot(2, 1, 1);
plot(envelopeSignal(:, 1));
title('Phase 2: Task 9, Lowest Frequency Channel');
xlabel('Sample Number');
ylabel('Amplitude');

% Highest Frequency Channel
subplot(2, 1, 2);
plot(envelopeSignal(:, N));
title('Phase 2: Task 9, Highest Frequency Channel');
xlabel('Sample Number');
ylabel('Amplitude');


function [mono, SR] = load_audio(filePath)
[audioData, SR] = audioread(filePath);
mono = sum(audioData, 2);
if SR > 16000
    mono = resample(mono, 16000, SR);
    SR = 16000;
end
end