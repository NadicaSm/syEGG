close all; clear all; clc;

% This code produces Figures 1-4 for paper titled "Data Augmentation
% for Generating Synthetic Electrogastrogram Time Series" authored by Nadica
% Miljković, Nikola Milenić, Nenad B. Popović, and Jaka Sodnik

% The code uses syEGG.m and syEGG_VR.m functions to generate synthetic EGG 
% signals and outputs three .jpg files with high resolution plots

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
    legend('simulated EGG','recorded EGG', 'linewidth', 1, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 0.6]);
    ylim([0 1]);
print ("-r300", "fig1.jpg");

% --------------------------------   FIG2   ------------------------------------
fig2 = figure(2);
    hax1 = axes('Parent',fig2, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.57, 0.84, 0.375]);
    hold on;
  plot((1:100)/2.0, signal1(1:100)', "k", 'LineWidth',2);
    axis('labely');
    ylabel('simulated EGG [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([-1, 1]);
  
    hax2 = axes('Parent',fig2, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.12, 0.84, 0.375]);
    hold on;
  plot((1:100)/2.0, signal2(1:100)', "k", 'LineWidth',2);
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('recorded EGG [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([-0.5, 0.5]);
print ("-r300", "fig2.jpg");

% --------------------------------   FIG3   ------------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);

fig3 = figure(3);
    axes1 = axes('Parent',fig3,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    hold on;
  plot((1:2400)/2.0, signal', "k", "LineWidth", 0.6);
    ylim([-1, 1]);
    title('Postprandial EGG with a pause in time domain', 'fontsize', 14, 'fontweight', 'bold');
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
print ("-r300", "fig3.jpg");

% -------------------------------   FIG3.1   -----------------------------------
[signal, psd, ~] = syEGG(1200, 2, "p", 1, 0, 9, [600 300], 0.0001);

fig31 = figure(31);
    axes1 = axes('Parent',fig31,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    hold on;
  plot((1:2400)/2.0, signal', "k", "LineWidth", 0.6);
    ylim([-1, 1]);
    xlim([900, 1100]);
    title('Postprandial EGG with a pause in time domain', 'fontsize', 14, 'fontweight', 'bold');
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
print ("-r300", "fig3.1.jpg");

% --------------------------------   FIG4   ------------------------------------
[signal, psd, psdvr] = syEGG_VR(1200,2,"p",1, 0, 172271, 600, 1200, 0.0001);

fig4 = figure(4);
    hax1 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.60, 0.85, 0.325]);
    hold on;
    title('Postprandial EGG with VR sickness in time domain', 'fontsize', 14, 'fontweight', 'bold');

  plot((1:2400)/2.0, signal', "k", "LineWIdth", 0.6);
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([-2.5, 2.5]);

    hax2 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.1, 0.11, 0.4, 0.325]);
    hold on;
    title('Postprandial EGG PSD', 'fontsize', 14, 'fontweight', 'bold');
      plot(2.0*(1:length(psd)/5)/length(psd), psd(1:length(psd)/5), "k", "LineWIdth", 2);
    
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('Magnitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([0, 2.5]);

    hax3 = axes('Parent',fig4, 'YGrid','on','XGrid','on');
    set(gca, "linewidth", 1, "fontsize", 12, "position", [0.55, 0.11, 0.4, 0.325]);
    axis('labelx');
    hold on;
    title('VR sickness EGG PSD');
  plot(2.0*(1:length(psdvr)/5)/length(psdvr), psdvr(1:length(psdvr)/5), "k", "LineWIdth", 2);
    
    set(gca, "linewidth", 1, "fontsize", 12);
    xlabel('Frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylim([0, 2.5]);
print ("-r300", "fig4.jpg");
