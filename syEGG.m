function [signal, psd, df, br, wdf, wbr] = syEGG(T, fs, state, breathing, pl, set_seed, pauses, noise)
% This GNU Octave code generates synthetic electrogastrogram (EGG) timeseries.
% The realizaed method is in-detail presented in paper titled "Data-driven Method 
% for Generating Synthetic Electrogastrogram Time Series" authored by 
% Nadica Miljkovic, Nikola Milenic, Nenad B. Popovic, and Jaka Sodnik

% [signal, psd, df, br, wdf, wbr] = syEGG(T, fs, state, breathing, pl, set_seed, pauses, noise)
% produces generated EGG with the following input parameters:
% (1) duration of the generated sequence, default 1200 s (T = 1200)
% (2) sampling frequency, default 2 Hz (fs = 2)
% (3) recording state (postprandial or fasting state), deafault fasting (state = 'f')
% (4) breathing artifact contamination, by default it is included (breathing = 1)
% (5) plot production, by default syEGG function does not provide plots (pl = 0)
% (6) seed for the sake of reproducibility, default not defined (set_seed = '')
% (7) pauses in the gastric rhythm (arrhythmia occurrence), not included by default (pauses = [0, 0])
% (8) overall noise contamination (Power Spectral Density PSD variability), turned off by deafault (noise = 0)

% output parameters of the syEGG function are:
% (1) signal - generated EGG timeseries
% (2) psd - Power Spectral Density of generated EGG timeseries
% (3) df - dominant frequency in Hz
% (4) br - position of breathing artifact, frequency with maximal breathing PSD in Hz
% (5) wdf - width of the DF peak in generated EGG signal
% (6) wbr - width of the breathing artifact peak in generated EGG signal

% The simplest way to generate EGG timeseries is to type
% [signal, psd, df, br, wdf, wbr] = syEGG() in the Command Window

% Contact: N. Milenic (nikolamilenic@gmail.com) or N. Miljkovic (nadica.miljkovic@etf.bg.ac.rs)

% This program is free software: you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later version.

% This program is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
% PARTICULAR PURPOSE. See the GNU General Public License for more details.

% You should have received a copy of the GNU General Public License along with 
% this program. If not, see <https://www.gnu.org/licenses/>. 

% syEGG.m is available on https://github.com/NadicaSm/syEGG - please report any 
% bugs to the Authors listed in the Contacts.

% load GNU Octave packages
pkg load communications;
pkg load statistics;
pkg load fuzzy-logic-toolkit;

% set parameter default values
if nargin < 1
   T = 1200; % s
end
if nargin < 2
   fs = 2; % Hz
end
if nargin < 3
   state = 'f'; % f for fasting p for postprandial
end
if nargin < 4
   breathing = 1; % 1 for including BR, 0 for excluding
end
if nargin < 5
   pl = 0; % 0 for not showing plots, 1 for showing plots
end
if nargin < 6
   set_seed = ''; % integer
end
if nargin < 7
  pauses = [0, 0]; % begining and duration in samples for arrhythmia
end
if nargin < 8
  noise = 0; % 0 for excluding PSD variability and 1 for including it
end

% parameters calculated on real-life data for DF (Dominant Frequency) of EGG
uDFf_s = 1.8229e-03; % standard deviation of mean values of DF in Hz / fasting
uDFf_u = 0.048893; % mean value of mean values of DF in Hz / fasting
sDFf_s = 1.2339e-03; % standard deviation of standard deviations of DF in Hz / fasting
sDFf_u = 8.0596e-03; % mean value of standard deviations of DF in Hz / fasting
uDFpp_s = 1.9307e-03; % standard deviation of mean values of DF in Hz / postprandial
uDFpp_u = 0.049572; % mean value of mean values of DF in Hz / postprandial
sDFpp_s = 1.3717e-03; % standard deviation of standard deviations of DF in Hz / postprandial
sDFpp_u = 7.9894e-03; % mean value of standard deviations of DF in Hz / postprandial

% parameters calculated on real-life data for BR (Breathing Artifact) of EGG
uBR_s = 0.017714; % standard deviation of mean values of BR in Hz
uBR_u = 0.2790; % mean value of mean values of BR in Hz
sBR_s = 8.1977e-03; % standard deviaiton of standard deviations of BR in Hz
sBR_u = 0.044425; % mean value of standard deviations of BR in Hz
aBR_s = 0.2474; % standard deviation of BR magnitudes in relation to normalized DF magnitude of 1
aBR_u = 0.1907; % mean of BR magnitudes in relation to normalized DF magnitude of 1

% define position and width of Gaussian curve that represents dominant frequency
% as an array of random numbers
if (!isempty(set_seed))
  randn("seed", set_seed);
  rand("seed", set_seed);
end
if state == 'f'
  P_DF = uDFf_s*randn(1,1) + uDFf_u;
  W_DF = sDFf_s*randn(1,1) + sDFf_u;
elseif state == 'p'
  P_DF = uDFpp_s*randn(1,1) + uDFpp_u;
  W_DF = sDFpp_s*randn(1,1) + sDFpp_u;
end

% create PSD (Power Spectral Density) of the signal based on the defined
% Gaussian curve
N = round(fs*T); % total number of samples
f_axe = 1:N; % frequency axis

PSD_EGG1 = gaussmf(f_axe, [W_DF*T round(P_DF*T+1)]);
PSD_EGG2 = gaussmf(f_axe, [W_DF*T round((fs-P_DF)*T+1)]);

PSD_EGG = PSD_EGG1 + PSD_EGG2;

% create breathing artifact on PSD (if choosen by the user)
br = 0;
wbr = 0;
if breathing == 1

      % define position and width of Gaussian curve that represents breathing 
      % artifact as a random number
      P_BR = uBR_s*randn(1,1) + uBR_u;
      W_BR = sBR_s*randn(1,1) + sBR_u;
      br = P_BR;
      wbr = W_BR;

      disp(P_DF);
      disp(W_DF);
      disp(P_BR);
      disp(W_BR);
      
      % weighting factor for the breathing artifact
      BR_amp = -1;
      while BR_amp < 0
        BR_amp = aBR_s*randn(1,1)+aBR_u;
      end
      disp(BR_amp);
      
      % add breathing Gaussian component on the overall PSD
      PSD_EGG3 = gaussmf(f_axe, [W_BR*T round(P_BR*T+1)]);
      PSD_EGG4 = gaussmf(f_axe, [W_BR*T round((fs-P_BR)*T+1)]);

      PSD_EGG = PSD_EGG + BR_amp*(PSD_EGG3 + PSD_EGG4)/max(abs([PSD_EGG3, PSD_EGG4]));

end

PSD_EGG = PSD_EGG'./max(abs(PSD_EGG'));

% add rectified Gaussain white noise in order to resemble PSD variability
WN = rand(round(T*fs*1.4),1);

WN = medfilt1(WN,T*fs/100);

WN_add = WN(round(0.2*T*fs):(round(0.2*T*fs)+T*fs-1));
WN_add = WN_add + flip(WN_add);
WN_add = WN_add/max(WN_add)*noise;

for ix = round(T*P_DF):(T*fs-round(T*P_DF))
    if PSD_EGG(ix) < WN_add(ix)
        PSD_EGG(ix) = WN_add(ix);
    end
end

% create timeseries from the PSD
dt = 1/fs; % delta time [s]
df = 1/T; % delta frequency [Hz]

frequency_DoubleSided = (0:(N-1))*df; % double-sided frequency vector
time = (0:N-1)*dt; % time vector

% generate white noise in the frequency domain
even = true;
Nhalf = N/2-1;
if rem(N,2) ~= 0; even = false; Nhalf = (N-1)/2; end

% random phase between 0 and 2*pi
randnums = rand(Nhalf, 1).*2*pi;

randvalues = exp(1i*randnums); % white noise

% create linear spectrum for white noise
if even
    linspecPositiveFreq = [1; randvalues; 1]; % + freqs
else
    linspecPositiveFreq = [1; randvalues]; % + freqs
end
linspecNegativeFreq = flip(conj(randvalues)); % - freqs

% reorder for IFFT application
noiseLinSpec = [linspecPositiveFreq; linspecNegativeFreq];

% multiply noise * signal linear spectra (double-sided) in the frequency-domain
totalWaveLinSpec = sqrt(PSD_EGG).*noiseLinSpec;

% convert double-sided PSD to units in time domain via IFFT
timeseries = real(ifft(totalWaveLinSpec)*N*df);

% insert pauses
if pauses(1)>0
  Np = pauses(1)*fs;

  PSD_EGG3 = gaussmf(1:Np, [W_BR*pauses(1) round(P_BR*pauses(1)+1)]);
  PSD_EGG4 = gaussmf(1:Np, [W_BR*pauses(1) round((fs-P_BR)*pauses(1)+1)]);
  PSD_EGG = zeros(1, Np);
  for ix = round(pauses(1)*P_DF*2+1):round(pauses(1)*P_BR*2)
    PSD_EGG(ix) = PSD_EGG3(ix)*BR_amp;
  end
  for ix = round(pauses(1)*P_BR*2+1):round(pauses(1)*fs-(pauses(1)*P_DF*2))
    PSD_EGG(ix) = PSD_EGG4(ix)*BR_amp;
  end
  even = true;
  Nhalf = Np/2-1;
  if rem(Np,2) ~= 0; even = false; Nhalf = (Np-1)/2; end
  randnums = rand(1, Nhalf).*2*pi;
  randvalues = exp(1i*randnums); % white noise
  if even
      linspecPositiveFreq = [1, randvalues, 1]; % + freqs
  else
      linspecPositiveFreq = [1, randvalues]; % + freqs
  end
  linspecNegativeFreq = flip(conj(randvalues)); % - freqs
  noiseLinSpec = [linspecPositiveFreq, linspecNegativeFreq];
  pause_totalWaveLinSpec = sqrt(PSD_EGG).*noiseLinSpec;
  pause_timeseries = real(ifft(pause_totalWaveLinSpec)*Np*df)';
  timeseries(round(pauses(2)*fs):round(pauses(2)*fs)+Np-1)=pause_timeseries(1:Np);
end

timeseries = timeseries/max(abs(timeseries));

% create (if defined) part of the EGG timeseries with arrhythmia
trans_fn = ones(length(timeseries),1);

% final deffinition of the EGG signal timeseries
signal = timeseries;
psd = PSD_EGG;
df = P_DF;
wdf = W_DF;

% plot results (optional)
if pl == 1
  figure
    subplot(211)
      plot(frequency_DoubleSided, abs(totalWaveLinSpec));
        title('Double-Sided Linear Spectrum * White Noise');
        xlabel('Frequency [Hz]');
        ylabel('Spectrum Magnitude [a.u.] - normalized to 1');
    subplot(212)
      plot(frequency_DoubleSided, angle(totalWaveLinSpec));
        title('Double-Sided Linear Spectrum * White Noise Phase');
        xlabel('Frequency [Hz]');
        ylabel('Phase [rad]');
  figure
    plot(time, signal);
      title('Generated Timeseries From PSD');
      xlabel('Time [s]');
      ylabel('Amplitude [a.u.]');
    else
    end
end