%% Ackermann.m
% MATLAB-kod f�r best�mning av geometri hos styramen f�r att uppfylla
% kriterier f�r Ackermann.
%
% Anders S�derberg, KTH Maskinkonstruktion, 20-08-13

%% St�dar
clc
clear all
close all
%% S�tter v�rden p� givna parametrar
L1 =  100;      % L�ngd p� styrarm [mm]
L3 =  668;      % Avst�nd mellan styraxlarna [mm]
L4 = 1258;      % Axelavst�nd [mm]
%% Ber�knar s�ka dimensioner f�r att uppn� Ackermann
alpha = atan(L3/(2*L4));        % Vinkel p� styraxel [mm]
L2 = L3 -2*L1*sin(alpha);       % L�ngd p� parallellstag [mm]
%% Presenterar resultatet
disp(['alpha = ' num2str(round(alpha*180/pi)) ' grader'])
disp(['L2    = ' num2str(round(L2)) ' mm'])
%% EOF



