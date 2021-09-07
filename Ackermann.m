%% Ackermann.m
% MATLAB-kod för bestämning av geometri hos styramen för att uppfylla
% kriterier för Ackermann.
%
% Anders Söderberg, KTH Maskinkonstruktion, 20-08-13

%% Städar
clc
clear all
close all
%% Sätter värden på givna parametrar
L1 =  100;      % Längd på styrarm [mm]
L3 =  668;      % Avstånd mellan styraxlarna [mm]
L4 = 1258;      % Axelavstånd [mm]
%% Beräknar söka dimensioner får att uppnå Ackermann
alpha = atan(L3/(2*L4));        % Vinkel på styraxel [mm]
L2 = L3 -2*L1*sin(alpha);       % Längd på parallellstag [mm]
%% Presenterar resultatet
disp(['alpha = ' num2str(round(alpha*180/pi)) ' grader'])
disp(['L2    = ' num2str(round(L2)) ' mm'])
%% EOF



