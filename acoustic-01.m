close all; clear; clc;

% Define folder path and audio files (replace with actual paths)
folderPath = 'path_to_audio_files';
audioFiles = {'file1.wav', 'file2.wav'};
numFiles = length(audioFiles);

% Load audio signals
for i = 1:numFiles
    [audioSignals{i}, sampleRates(i)] = audioread(fullfile(folderPath, audioFiles{i}));
end

% Parameters
windowSize = 9600; overlap = 7680; nfft = windowSize;
windowDuration = 1; stepSize = 0.01; 
desiredFrequencies = 25:50:2500;
out_stft_acustic = []; out_fft_acustic = [];

% Process each audio file
for i = 1:numFiles
    audioSignal = audioSignals{i}; fs = sampleRates(i);
    numWindows = floor((length(audioSignal) - windowDuration * fs) / (stepSize * fs)) + 1;

    for j = 0:numWindows-1
        segment = get_segment(audioSignal, j, fs, windowDuration, stepSize);
        
        % STFT and FFT processing
        out_stft_acustic = [out_stft_acustic; normalize(abs(spectrogram(segment, windowSize, overlap, nfft, fs)), desiredFrequencies)];
        out_fft_acustic = [out_fft_acustic; normalize(abs(fft(segment) / length(segment)), desiredFrequencies)];
    end
end

% Save results
save('out_fft_acustic', 'out_fft_acustic');
save('out_stft_acustic', 'out_stft_acustic');

% Helper functions
function seg = get_segment(signal, idx, fs, winDuration, stepSize)
    startIdx = idx * stepSize * fs + 1;
    seg = signal(startIdx : min(startIdx + winDuration * fs - 1, length(signal)));
end

function norm_data = normalize(data, freqs)
    freqIndices = arrayfun(@(x) find_closest(x, length(data)), freqs);
    norm_data = (data(freqIndices) - min(data)) / (max(data) - min(data));
end

function idx = find_closest(target, len)
    idx = max(1, min(round(target * len / 2500), len)); % Approximation for desired freq index
end
