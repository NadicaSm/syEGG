function [signal, psd, psdvr] = syEGG_VR(T, fs, state, breathing, pl, set_seed, onset, offset, noise);
% This GNU Octave code generates synthetic electrogastrogram (EGG) timeseries
% during simulator sickness experience.
% The realizaed method is in-detail presented in paper titled "Data-driven Method 
% for Generating Synthetic Electrogastrogram Time Series" authored by 
% Nadica Miljkovic, Nikola Milenic, Nenad B. Popovic, and Jaka Sodnik

% [signal, psd, psdvr] = syEGG_VR(T, fs, state, breathing, pl, set_seed, onset, offset, noise);
% produces generated EGG with the following input parameters:
% (1) duration of the generated sequence, default 1200 s (T = 1200)
% (2) sampling frequency, default 2 Hz (fs = 2)
% (3) recording state (postprandial or fasting state), deafault fasting (state = 'f')
% (4) breathing artifact contamination, by default it is included (breathing = 1)
% (5) plot production, by default syEGG function does not provide plots (pl = 0)
% (6) seed for the sake of reproducibility, default not defined (set_seed = '')
% (7) offset of simulator sickness-related EGG changes, by default it is 400 s (onset = 400)
% (8) overall noise contamination (Power Spectral Density PSD variability), turned off by deafault (noise = 0)

% output parameters of the syEGG function are:
% (1) signal - generated EGG timeseries
% (2) psd - Power Spectral Density of generated EGG timeseries without simulator sickness
% (3) psdvr - Power Spectral Density of generated EGG timeseries with simulator sickness

% The simplest way to generate EGG timeseries is to type
% [signal, psd, psdvr] = syEGG_VR() in the Command Window

% Contact: N. Milenic (nikolamilenic@gmail.com) or N. Miljkovic (nadica.miljkovic@etf.bg.ac.rs)

% This program is free software: you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later version.

% This program is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
% PARTICULAR PURPOSE. See the GNU General Public License for more details.

% You should have received a copy of the GNU General Public License along with 
% this program. If not, see <https://www.gnu.org/licenses/>. 

% syEGG_VR.m is available on https://github.com/NadicaSm/syEGG - please report any 
% bugs to the Authors listed in the Contacts.

% load GNU Octave packages
pkg load fuzzy-logic-toolkit;
pkg load communications;

% set parameter default values
if nargin < 1
   T = 1200;
end
if nargin < 2
   fs = 2;
end
if nargin < 3
   state = 'f';
end
if nargin < 4
   breathing = 1;
end
if nargin < 5
   pl = 1;
end
if nargin < 6
   set_seed = randn(1,1);
end
if nargin < 7
   onset = 100;
end
if nargin < 8
   offset = 400;
end
if nargin < 9
  noise = 0;
end

% parameters calculated on real-life data for DF (Dominant Frequency) of EGG
uDFf_s = 1.8229e-03; % standard deviation of mean value of DF in Hz / fasting
uDFf_u = 0.048893; % mean value of mean value of DF in Hz / fasting
sDFf_s = 1.2339e-03; % standard deviation of standard deviation of DF in Hz / fasting
sDFf_u = 8.0596e-03; % mean value of standard deviation of DF in Hz / fasting
uDFpp_s = 1.9307e-03; % standard deviation of mean value of DF in Hz / postprandial
uDFpp_u = 0.049572; % mean value of mean value of DF in Hz / postprandial
sDFpp_s = 1.3717e-03; % standard deviation of standard deviation of DF in Hz / postprandial
sDFpp_u = 7.9894e-03; % mean value of standard deviation of DF in Hz / postprandial

% parameters calculated on real-life data for BR (Breathing Artifact) of EGG
uBR_s = 0.017714; % standard deviation of mean value of BR in Hz
uBR_u = 0.2790; % mean value of mean value of BR in Hz
sBR_s = 8.1977e-03; % standard deviaiton of standard deviation of BR in Hz
sBR_u = 0.044425; % mean value of standard deviation of BR in Hz
aBR_s = 0.2474; % standard deviation of BR magnitude in relation to normalized DF magnitude of 1
aBR_u = 0.1907; % mean of BR magnitude in relation to normalized DF magnitude of 1

if (!isempty(set_seed))
  randn("seed", set_seed);
  rand("seed", set_seed);
end

% define position and width of Gaussian curve that represents dominant frequency
% as a random numbers
if state == 'f'
  P_DF = uDFf_s*randn(1,1)+uDFf_u;
  W_DF = sDFf_s*randn(1,1)+sDFf_u;
elseif state == 'p'
  P_DF = uDFpp_s*randn(1,1)+uDFpp_u;
  W_DF = sDFpp_s*randn(1,1)+sDFpp_u;
end


dt = 1/fs; % delta time [s]
N = round(fs*T); % total number of samples
df = fs/N; % delta frequency [Hz]
f_axe = 1:N;

% create PSD (Power Spectral Density)
aVR = 2.2;
xa=df*(1:N)/P_DF;
sigma = W_DF*2/P_DF;
tp = 1 + sigma;
xa(xa > tp) = tp+(xa(xa > tp) - tp)/4;
PSD_EGG_VR = (aVR * ones(size(xa))) .* (exp (-((xa-1).^2) / (2*sigma.^2)));
PSD_EGG_VR = PSD_EGG_VR + flip(PSD_EGG_VR);

if breathing == 1

      % define position and width of Gaussian curve that represents breathing
      % artifact as an array of random numbers
      P_BR = uBR_s*randn(1,1)+uBR_u;
      W_BR = sBR_s*randn(1,1)+sBR_u;
      br = P_BR;
      wbr = W_BR;

      disp(P_DF);
      disp(W_DF);
      disp(P_BR);
      disp(W_BR);

      % weithing factor for the breathing artifact
      BR_amp = -1;
      while BR_amp < 0
        BR_amp = aBR_s*randn(1,1)+aBR_u;
      end
      disp(BR_amp);

      % add breathing Gaussian component on the overall PSD
      PSD_EGG3 = gaussmf(f_axe, [W_BR*T round(P_BR*T+1)]);
      PSD_EGG4 = gaussmf(f_axe, [W_BR*T round((fs-P_BR)*T+1)]);

      PSD_EGG_VR = PSD_EGG_VR + BR_amp*(PSD_EGG3 + PSD_EGG4)/max(abs([PSD_EGG3, PSD_EGG4]));

end

% add rectified Gaussain white noise in order to add variability
WN = rand(round(T*fs*1.4),1);

WN = medfilt1(WN,T*fs/100);

WN_add = WN(round(0.2*T*fs):(round(0.2*T*fs)+T*fs-1));
WN_add = WN_add + flip(WN_add);
WN_add = WN_add/max(WN_add)*noise;

for ix = round(T*P_DF):(T*fs-round(T*P_DF))
    if PSD_EGG_VR(ix) < WN_add(ix)
        PSD_EGG_VR(ix) = WN_add(ix);
    end
end

Sxx = sqrt(PSD_EGG_VR');

Xm_mag = Sxx.*T; % magnitude of linear spectrum
Xm_mag /= max(Xm_mag);

% generate white noise in the frequency domain
even = true;
Nhalf = N/2-1;
if rem(N,2) ~= 0; even = false; Nhalf = (N-1)/2; end

rms_level = 1;

% random phase between 0 and 2*pi
randnums = rand(1, Nhalf).*2*pi;
randvalues = rms_level.*exp(1i*randnums); % white noise

% create linear spectrum for white noise
if even
    linspecPositiveFreq = [rms_level, randvalues, rms_level]; % + freqs
else
    linspecPositiveFreq = [rms_level, randvalues]; % + freqs
end
linspecNegativeFreq = flip(conj(randvalues)); % - freqs

% reorder for IFFT application
noiseLinSpec = [linspecPositiveFreq, linspecNegativeFreq];

% multiply noise * signal linear spectra (double-sided) in the frequency-domain
totalWaveLinSpec = Xm_mag.*noiseLinSpec';

% convert double-sided PSD to units in time domain via IFFT
timeseries_VR = real(ifft(totalWaveLinSpec)*N*df);
frequency_DoubleSided = (0:(N-1))*df; % Double-Sided Frequency vector

[signal, psd,~,~,~,~] = syEGG(T,fs,state,breathing, pl, set_seed);
signal_VR = timeseries_VR/max(timeseries_VR)*aVR;

% include VR (Virtual Reality) part
signal((onset*fs):(offset*fs-1)) = signal_VR((onset*fs):(offset*fs-1));
psdvr = PSD_EGG_VR; % (abs(totalWaveLinSpec) .^ 2) * Hm0;

% plot results (optional)
if pl == 1
  figure
    subplot(211)
      plot(frequency_DoubleSided, abs(totalWaveLinSpec'))
        title('Double-Sided Linear Spectrum * White Noise')
        xlabel('Frequency [Hz]')
        ylabel('Spectrum Magnitude [a.u.]') % mV/Hz
    subplot(212)
      plot(frequency_DoubleSided, angle(totalWaveLinSpec))
        title('Double-Sided Linear Spectrum * White Noise Phase')
        xlabel('Frequency [Hz]')
        ylabel('Phase [rad]')
  figure
    plot((1:length(signal))/fs, signal)
      title('Generated Timeseries From PSD')
      xlabel('Time [s]')
      ylabel('Amplitude [a.u.]') % mV
    else
    end
end