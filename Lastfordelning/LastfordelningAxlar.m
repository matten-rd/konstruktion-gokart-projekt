%% LastfordelningAxlar
% Program för bestämning av lastfördelning mellan fram och bakaxel på
% gokarten under olika körfall
%
% Anders Söderberg, KTH-Maskinkonstruktion, 2019-08-13
%

%% Städar
clear all
close all
clc

%% Givna in data
% Massa och masscentrum för gokart inkl. förare
L1   = 0.628;
L2   = 0.628;
H1   = 0.400;
m    = 120;     % Massa inkl. förare [kg]
r    = 0.135;   % Hjulradie [mm]
% Data för drivlinan
u    = 2;       % Utväxling [-]
eta  = 0.95;    % Verkningsgrad [-]
Mmax = 10;      % Maximalt motormoment enligt datablad [Nm]
% Fysikaliska parametrar
mu  = 0.8;      % Friktionstal mellan däck och vägbana [ - ]
g   = 9.81;     % Tyngdacceleration [m/s^2]

%% Beräkning av lastfördelning mellan fram och bakaxel för olika körfall
% Acceleration med maximalt motormoment
F(1) = u*eta*Mmax/r;                % Drivande kraft [N]
a(1) = F(1)/m;                      % Acceleration [m/s^2]
N1(1)= (m*g*L2 -F(1)*H1)/(L1+L2);
N2(1)= m*g -N1(1);
% Konstant hastighet
F(2) = 0;
a(2) = F(2)/m;
N1(2)= (m*g*L2 -F(2)*H1)/(L1+L2);
N2(2)= m*g -N1(2);
% Acceleration med maximalt motormoment
N2(3)= m*g*L1/(L1+L2+mu*H1) ;
N1(3)= m*g -N2(3);
F(3) = -mu*N2(3);
a(3) = F(3)/m;
% Tabell med lastfördelning
Fall ={'Acceleration        ' 'Konstant hastighet  ' 'Inbromsning         '};
disp(['                    ' 'Fram   ' 'Bak'])
for i =1:3
    disp([Fall{i} num2str(round(N1(i)/(m*g)*100)) '%      ' num2str(round(N2(i)/(m*g)*100)) '% '])
end


