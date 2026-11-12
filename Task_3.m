% Create a program to read these files (or some of these files) into Matlab and find their sampling rate.
inputFiles = dir(fullfile('/Users/kianah/Downloads/MTE252_Task2', '*.mp3'));
n = length(inputFiles);
mkdir('Output_Files');
for i = 1:n
    currentFile = inputFiles(i).name;
    % read the file
    [audioData, SR] = audioread(fullfile(inputFiles(i).folder, currentFile));
    fprintf('%s: sampling rate = %d Hz\n', inputFiles(i).name, SR);

    % check stereo/mono
    [numSamples, numChannels] = size(audioData);
    if numChannels == 2
        mono = sum(audioData,2);
    else
        mono = audioData;
    end

    if SR > 16000
        mono = resample(mono, 16000, SR);
        SR = 16000;
    elseif SR < 16000
        fprintf("File is below 16kHz, must be reprocessed by step 3.1.- Skipping...\n")
        continue
    end

    % play the sound
    pause;
    sound(mono, SR);
    pause(length(mono)/SR);

    % write sound to file
    [~, base] = fileparts(currentFile);
    audiowrite(fullfile('Output_Files', [base '_out.wav']), mono, SR);

    % create time vector
    time_vector = (0:length(mono)-1) / SR;
    tone = cos(2*pi*1000*time_vector);
    sound(tone, SR);
    nTwoCycles = 2*SR/1000;

    % waveform plot
    figure;
    plot(mono);
    xlabel('Sample number');
    ylabel('Amplitude');
    title(['Waveform: ' currentFile]);
    grid on;
 
    % plot two cycles of cosine wave
    figure; 
    plot(time_vector(1:nTwoCycles+1), tone(1:nTwoCycles+1));
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    TitleStr = '1 kHz Cosine for Two Cycles';
    title(TitleStr); 
    grid on;
end