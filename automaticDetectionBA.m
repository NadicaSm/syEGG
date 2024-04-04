close all; clear all; clc;

% This code examines breathing artifact for the paper titled "Data-driven 
% Method for Generating Synthetic Electrogastrogram Time Series" authored 
% by Nadica Miljković, Nikola Milenić, Nenad B. Popović, and Jaka Sodnik

% For running this code, please use electrogastrograms (EGG signals) from:
% 1) Popović, N.B., Miljković, N. and Popović, M.B., 2019. Simple gastric 
% motility assessment method with a single-channel electrogastrogram. 
% Biomedical Engineering/Biomedizinische Technik, 64(2), pp.177-185
% 2) Popović, N.B., Miljković, N. and Popović, M.B., 2020. Three-channel 
% surface electrogastrogram (EGG) dataset recorded during fasting and 
% post-prandial states in 20 healthy individuals [Data set]. Zenodo

% Direct link to download EGG signals is:
% https://zenodo.org/records/3878435/files/EGG-database.zip?download=1

% load appropriate package
pkg load signal

% specify parameters
fs = 2; % Hz, sampling frequency

% bandpass filter for noise reduction
[b, a] = butter(3, [0.03 0.6] / (fs / 2), 'bandpass');

BR = [];

for ind = 1 : 20
    % FASTING -------------------------------------------------------------
    % signal loading
    file_name = ['ID' num2str(ind) '_fasting.txt'];
    sample = load(file_name);
    sample = filtfilt(b, a, sample); % channel 2
    for ch = 1 : 3
      [psd f] = pwelch(sample(1:2400, ch),300,0.5,2000,2);
      psd = psd/max(psd);
      BR = [BR, sum(psd((f > 0.2) & (f < 0.4)))/sum(psd((f > 0.0333) & (f < 0.0667))) ];
    end

    % POSTPRANDIAL --------------------------------------------------------
    % signal loading
    file_name = ['ID' num2str(ind) '_postprandial.txt'];
    sample = load(file_name);
    sample = filtfilt(b, a, sample);
    for ch = 1 : 3
      [psd f] = pwelch(sample(1:2400, ch),300,0.5,2000,2);
      psd = psd/max(psd);
      BR = [BR, sum(psd((f > 0.2) & (f < 0.4)))/sum(psd((f > 0.0333) & (f < 0.0667))) ];
    end
end

[out, indices] = sort(BR, "descend");
for ii = 1 : 120
  id = fix((indices(ii)-1)/6.0) + 1;
  md = mod(indices(ii)-1, 6);
  type = "fasting";
  if md >= 3
    type = "postprandial";
  endif
  ch = mod(indices(ii)-1, 3)+1;
  fprintf("%d_%s-ch%d:%f\n", id, type, ch, out(ii));
end
