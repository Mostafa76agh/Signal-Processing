clc; clear all; close all;

% Define file names and parameters
fileNames = {'file1.csv', 'file2.csv'}; % Replace with actual paths
fs = 300; % Sampling rate
frequencies = 10:10:120;
windowSize = 60; overlap = 48; stepSize = 0.01 * fs;

% Initialize result matrices
fft_results = []; stft_results = [];

% Process files
for i = 1:length(fileNames)
    data = readtable(fileNames{i});
    [time, ax, ay, az] = deal(data{:,1}, data{:,2}, data{:,3}, data{:,4});
    
    % Interpolate and apply sliding window
    for segment = sliding_window(ax, ay, az, fs, windowSize, stepSize)
        % FFT and STFT
        fft_results = [fft_results; process_fft(segment, fs, frequencies)];
        stft_results = [stft_results; process_stft(segment, fs, windowSize, overlap, frequencies)];
    end
end

% Save results
save('fft_results.mat', 'fft_results');
save('stft_results.mat', 'stft_results');

% Helper functions
function fft_data = process_fft(segment, fs, freqs)
    N = length(segment);
    fft_vals = abs(fft(segment) / N);
    fft_data = fft_vals(1:N/2+1);
    fft_data = normalize(fft_data(freqs));
end

function stft_data = process_stft(segment, fs, winSize, overlap, freqs)
    S = abs(spectrogram(segment, winSize, overlap, [], fs));
    stft_data = normalize(mean(S(freqs, :), 2));
end

function normalized = normalize(data)
    normalized = (data - min(data)) / (max(data) - min(data));
end
