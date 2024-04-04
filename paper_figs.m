close all; clear all; clc;

% This code produces Figures 1-4 for paper titled "Data-driven Method for 
% Generating Synthetic Electrogastrogram Time Series" authored by Nadica
% Miljković, Nikola Milenić, Nenad B. Popović, and Jaka Sodnik

% Also, the code includes additional figures with Running Spectrum Analysis.

% The code uses syEGG.m and syEGG_VR.m functions to generate synthetic EGG 
% signals and outputs three .tiff files with high resolution plots

% load appropriate package
pkg load signal

% simulate EGG
[signal1 psd1 df br wdf wbr] = syEGG(1200, 2, 'p', 1, 0, 0); % 9; 26; 27; 75;
l = length(psd1);
signal = load('ID18_postprandial.txt');
signal2 = signal(:,1);

fs = 2; % sampling frequency

t = (1:length(signal2))/fs; % time axes

% bandpass filter for noise reduction
[b, a] = butter(3, [0.03 0.6] / (fs / 2), 'bandpass');
signal2 = filtfilt(b, a, signal2); % channel 2
[psd2 f] = pwelch(signal2, 300, 0.5, 1000, 2);
psd2 = resample(psd2, 1200, 501);
best = 19.193;
bestseed = 172271; %7730;%48041

for seed = 1:1
  [signal1 psd1 df br wdf wbr] = syEGG(1200,2,'p',1,0,seed);%9;26;27;75
  score = sum(abs(psd1(1:1200) - psd2(:)));
  if mod(seed, 100) == 0
    disp(seed);
    disp(bestseed);
  endif
  if score < best
    best = score;
    bestseed = seed;
  endif
end

% --------------------------------   FIG1   ------------------------------------
[signal1 psd1 df br wdf wbr] = syEGG(1200, 2, 'p', 1, 0, bestseed, [0, 0], 0.0005);
[psd2 f] = pwelch(signal2, 300, 0.5, 1000, 2);

fig = figure(1);
    axes1 = axes('Parent',fig,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    box(axes1,'on');
    hold(axes1,'on');
    xlabel('Frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Magnitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
  plot(((1:l/2)/(l/2)),psd1(1:(l/2)),...
    'Color',[0 0 0],...
    'LineWidth',2,...
    'LineStyle','-');
  plot(f,psd2/max(psd2),...
    'Color', [0.6 0.6 0.6],...
    'LineWidth',2,...
    'LineStyle','-');
    legend('simulated signal','recorded signal', 'linewidth', 1, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 0.6]);
    ylim([0 1]);
print ("-r300", "fig1.tiff");

% --------------------------------   FIG2   ------------------------------------
fig2 = figure(2);
    hax1 = axes('Parent',fig2, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.12, 0.57, 0.84, 0.375]);
    hold on;
  plot((1:100)/2.0, signal1(1:100)', "k", 'LineWidth',2);
    axis('labely');
    ylim([-1, 1]);
    legend('simulated signal', 'linewidth', 1, 'fontsize', 14, 'fontweight', 'bold');
    
    hax2 = axes('Parent',fig2, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.12, 0.12, 0.84, 0.375]);
    hold on;
  plot((1:100)/2.0, signal2(1:100)', 'Color', [0.6 0.6 0.6], 'LineWidth',2);
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([-0.5, 0.5]);
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    legend('recorded signal', 'linewidth', 1, 'fontsize', 14, 'fontweight', 'bold');
print ("-r300", "fig2.tiff");

% --------------------------------   FIG3   ------------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);

fig3 = figure(3);
    axes1 = axes('Parent',fig3,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    hold on;
  plot((1:2400)/2.0, signal', "k", "LineWidth", 0.6);
    ylim([-1, 1]);
    title('Postprandial state: EGG signal with arrhythmia', 'fontsize', 14, 'fontweight', 'bold');
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
print ("-r300", "fig3.tiff");

% -------------------------------   FIG3.1   -----------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);

fig31 = figure(31);
    axes1 = axes('Parent',fig31,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    hold on;
  plot((1:2400)/2.0, signal', "k", "LineWidth", 0.6);
    ylim([-1, 1]);
    xlim([900, 1100]);
    title('Postprandial state: EGG signal with arrhythmia', 'fontsize', 14, 'fontweight', 'bold');
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
print ("-r300", "fig3.1.tiff");

% --------------------------------   FIG4   ------------------------------------
[signal, psd, psdvr] = syEGG_VR(1200,2,"p",1, 0, 172271, 600, 1200, 0.0001);

fig4 = figure(4);
    hax1 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.60, 0.85, 0.3]);
    hold on;
    title('EGG signal with VR sickness occurence', 'fontsize', 14, 'fontweight', 'bold');

  plot((1:2400)/2.0, signal', "k", "LineWIdth", 0.6);
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([-2.5, 2.5]);

    hax2 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.12, 0.4, 0.26]);
    hold on;
    title('PSD ~ postprandial state', 'fontsize', 14, 'fontweight', 'bold');
      plot(2.0*(1:length(psd)/5)/length(psd), psd(1:length(psd)/5), "k", "LineWIdth", 2);
    
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Magnitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([0, 2.5]);

    hax3 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.55, 0.12, 0.4, 0.26]);
    axis('labelx');
    hold on;
    title('PSD ~ sickness state');
  plot(2.0*(1:length(psdvr)/5)/length(psdvr), psdvr(1:length(psdvr)/5), "k", "LineWIdth", 2);
    
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([0, 2.5]);
print ("-r300", "Fig4New.tiff");

% Running Spectrum Analysis (RSA)
% -------------------------------   FIG3.2   -----------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);
signal1 = signal(601:1800)';

[psd31 f31] = pwelch(signal1(1:300), 50, 0.5, 1000, 2);
[psd32 f32] = pwelch(signal1(301:600), 50, 0.5, 1000, 2);
[psd33 f33] = pwelch(signal1(601:900), 50, 0.5, 1000, 2);
[psd34 f34] = pwelch(signal1(901:1200), 50, 0.5, 1000, 2);

fig32 = figure(32)
    axes1 = axes('Parent',fig32,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 10);
    for ix = 1:300:901
      [psdW fW] = pwelch(signal1(ix:(ix+299)), 50, 0.5, 1000, 2);
      plot3(((ix-1)/2)*ones(1,501), fW, psdW,...
        'Color', [0 0 0],...
        'LineWidth', 2);
    hold on;
end
    hold off
    title('RSA for the arrhythmic part: Welch window of 150 s', 'fontsize', 12, 'fontweight', 'bold');
  xlabel('Time [s]', 'fontsize', 10, 'fontweight', 'bold');
  ylabel('Frequency [Hz]', 'fontsize', 10, 'fontweight', 'bold');
  zlabel('Magnitude [a.u.]', 'fontsize', 10, 'fontweight', 'bold');
print ("-r200", "fig3.2-r.tiff");

% Running Spectrum Analysis (RSA)
% -------------------------------   FIG3.3   -----------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);
signal1 = signal(601:1800)';

fig33 = figure(33)
    axes1 = axes('Parent',fig33,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 10);
    for ix = 1:120:1081
      [psdY fY] = pyulear(signal1(ix:(ix+119)),10,0:(1/500):1,2);
      plot3(((ix-1)/2)*ones(1, 501), fY, psdY,...
        'Color', [0 0 0],...
        'LineWidth',2);
  hold on
end
hold off
  title('RSA for the arrhythmic part: Yule-Walker window of 60 s', 'fontsize', 12, 'fontweight', 'bold');
  xlabel('Time [s]', 'fontsize', 10, 'fontweight', 'bold');
  ylabel('Frequency [Hz]', 'fontsize', 10, 'fontweight', 'bold');
  zlabel('Magnitude [a.u.]', 'fontsize', 10, 'fontweight', 'bold');
print ("-r200", "fig3.3-r.tiff");
