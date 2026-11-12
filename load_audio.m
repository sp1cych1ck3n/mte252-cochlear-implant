function [mono, SR] = load_audio(filePath)
    [audioData, SR] = audioread(filePath);
    mono = sum(audioData, 2);
    if SR > 16000
        mono = resample(mono, 16000, SR);
        SR = 16000;
    end
end