close all; clear all; clc;
% This GNU Octave code provides extensive analysis of applied Butterworth filter.
% The realizaed method is in-detail presented in paper titled "Data Augmentation 
% for Generating Synthetic Electrogastrogram Time Series" authored by 
% Nadica Miljkovic, Nikola Milenic, Nenad B. Popovic, and Jaka Sodnik

% Contact: N. Milenic (nikolamilenic@gmail.com) or N. Miljkovic (nadica.miljkovic@etf.bg.ac.rs)

% This program is free software: you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later version.

% This program is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
% PARTICULAR PURPOSE. See the GNU General Public License for more details.

% You should have received a copy of the GNU General Public License along with 
% this program. If not, see <https://www.gnu.org/licenses/>. 

% stepAnalysis.m is available on https://github.com/NadicaSm/syEGG - please report any 
% bugs to the Authors listed in the Contacts.

% Load packages
pkg load signal;
pkg load symbolic;

% Define filter
fs = 2;
[b, a] = butter(3, [0.03/fs, 0.6/fs], 'bandpass');
[h, f] = freqz(b, a, 2^10, Fs = fs);

# Frequency response (Fig. 1)
fig = figure(1);
    axes1 = axes('Parent',fig,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    box(axes1,'on');
    hold(axes1,'on');
    xlabel('frequency [Hz]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('magnitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    title('Frequency response of the third order Butterworth filter')
  plot(f, abs(h),...
    'Color',[0 0 0],...
    'LineWidth',2,...
    'LineStyle','-'); hold on;
print ("-r300", "fig1.jpg");

% Step response for Heaviside function with default 0.5 at n = 0 (Fig. 2)
n = 0:((20*60/fs)-1);
   
fig = figure(2);
    axes1 = axes('Parent',fig,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    box(axes1,'on');
    hold(axes1,'on');
    xlabel('n [samples]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    title('Step responses for Butterworth filter')
  plot(filter(b, a, heaviside(n)),...
    'LineWidth',2,...
    'LineStyle','-','b'); hold on;
  plot(filtfilt(b, a, heaviside(n)),...
    'LineWidth',2,...
    'LineStyle','-','r');
     legend('filter function', 'filtfilt function')
     %xlim([0 200]);
print ("-r300", "fig2.jpg");

% Step response for Heaviside function with 1 at n = 0 (Fig. 3)
fig = figure(3);
    axes1 = axes('Parent',fig,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    box(axes1,'on');
    hold(axes1,'on');
    xlabel('n [samples]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
    title('Step responses for Butterworth filter')
  plot(filter(b, a, ones(1, length(n))),...
    'LineWidth',2,...
    'LineStyle','-','b'); hold on;
  plot(filtfilt(b, a, ones(1, length(n))),...
    'LineWidth',2,...
    'LineStyle','-','r');
     legend('filter function', 'filtfilt function')
     %xlim([0 200]);
print ("-r300", "fig3.jpg");

% Test signal sine wave (Fig. 4)
t = 0:1/fs:(20*60/fs - 1/fs);
f = 0.05; % normogastria is within (2 to 4 cpm or 0.033 to 0.066 Hz)
x = sin(2*f*pi*t);
y  = filter(b, a, x);
y1 = filtfilt(b, a, x);

fig = figure(4);
    axes1 = axes('Parent',fig,'YGrid','on','XGrid','on','FontSize',12,'linewidth',1, 'fontweight', 'bold');
    set(gca, "linewidth", 1, "fontsize", 12);
    box(axes1,'on');
    hold(axes1,'on');
    xlabel('time [s]', 'fontsize', 14, 'fontweight', 'bold');
    ylabel('amplitude [a.u.]', 'fontsize', 14, 'fontweight', 'bold');
  plot(t, x,...
    'Color',[0 0 0],...
    'LineWidth',2,...
    'LineStyle','-'); hold on;
  plot(t, y,...
    'LineWidth',2,...
    'LineStyle','-','b');
  plot(t, y1,...
    'LineWidth',2,...
    'LineStyle','-','r');
     legend('input signal', 'filter function', 'filtfilt function')
     hold off;
     xlim([0 100]);
print ("-r300", "fig4.jpg");

% Quantitative comparison for test sine wave
% For filter() function
cf = abs(y - x);
mean(cf)*100 % in percents of amplitude of 1
std(cf)*100 % in percents of amplitude of 1
% For filtfilt() function
cff = abs(y1 - x);
mean(cff)*100
std(cff)*100
