%%  LastfordelningSida.m
% Program för beräkning av lastfördelning och maximal hastighet vid kurvtagning
% 
% Anders Söderberg KTH Maskinkonstruktion 2019-08-13

%% Städar arbetsminnet, commad window sa
clear all
close all
clc

%% Givna parametervärden
B1 = 0.400;                     % Masscentrums läge relativit vänster hjul [m]
B2 = 0.400;                     % Masscentrums läge relativit höger hjul [m]
H1 = 0.400;                     % Masscentrums läge över marknivån [m]
m  = 120;                       % Massa hos fordon ink. förare 
mu = 0.8;                       % Friktion mellan däck och vägbana [-]
g  = 9.81;                      % Tyngdaccelation [m/s^2]

%% Bestämning av masscentrums maximala höjd över marken för att undvika tippning
Bmin = min(B1,B2);              % Avgör minsta avstånd från masscentrum till hjul [m]
H1max = Bmin/mu;                % Beräknar maximalt tillåtet värde på H1

%% Bestämning av maximal kurvhastighet för att undvika sladd
R = [5:20];                     % Kurvradier [m]
v  = sqrt(mu*g*R);              % Maximal hastiget för att undvika sladd [m/s]

%% Bestämning av normalkrafter i olika körfall
% Vänsterkurva på gränsen till sladd
N1(1) = m*g*(B2-mu*H1)/(B1+B2); % Normalkraft på vänster sida [N]
N2(1) = m*g -N1(1);             % Normalkraft på höger sida [N]
% Körning rakt fram
N1(2) = m*g*B2/(B1+B2);         % Normalkraft på vänster sida [N]
N2(2) = m*g -N1(2);             % Normalkraft på höger sida [N]
% Högerkurva på gränsen till sladd
N1(3) = m*g*(B2+mu*H1)/(B1+B2); % Normalkraft på vänster sida [N]
N2(3) = m*g -N1(3);             % Normalkraft på höger sida [N]

%% Presentation av resultat
% Skriver ut massecntrums maximalt tillåtna höjd över marken
disp(' ')
disp(['H1max = ' num2str(round(H1max*1e3)) ' mm']);
disp(' ')
% Graf som visar vmax som funktion av kurvradien
figure
plot(R,v*3.6)
xlabel('Kurvradie R [m]')
ylabel('Gränshastighet för sladd v_m_a_x [km/h]')
grid on
% Tabell med lastfördelning
Fall ={'Vänster kurva   ' 'Rakt            ' 'Höger kurva     '};
disp(['               ' 'Vänster   ' 'Höger'])
for i =1:3
    disp([Fall{i} num2str(round(N1(i)/(m*g)*100)) '%      ' num2str(round(N2(i)/(m*g)*100)) '% '])
end

%% EOF


