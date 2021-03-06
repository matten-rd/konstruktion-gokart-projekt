%% stoppbromsning.m
% Huvudprogram f?r simulering av stoppbromsning med l?st skivbroms.
%
% Anders S?derberg, KTH - Maskinkonstruktion, 2019-08-13

%% St?dar
clear all
clc
close all

%% Systemparametrar
% Definera systemparametar som globala
global r L1 L2 H1 H2 m g f c rho A mu

% Data f?r gokart
m   = 120;         % Massa gokart inkl. f?rare [kg]
r   = 0.135;       % Hjulradie [m]
L1  = 0.628;       % Masscentrum relativt framaxel [m]
L2  = 0.628;       % Masscentrum relativit bakaxel [m]
H1  = 0.40;        % Masscentrum relativit markniv? [m]
H2  = 0.10;        % Angeppspunkt f?r Fluft relativit masscentrum [m]
A   = 0.5;         % Projicerad area f?r luftmotst?nd [m^2]

% Fysikaliska parametrar
mu  = 0.8;         % Friktionstal mellan d?ck och v?gbana [-]
f   = 0.012;       % Rullmotst?ndskoefficient [-]
g   = 9.81;        % Tyngdacceleration [m/s^2]
c   = 0.6;         % Luftmotst?ndskoefficient [-]
rho = 1.22;        % Denstitet hos luft [kg/m^3]  
  
%% Simulering av stoppbromsing
% Definiera tidsintervall och begynnelsevillkor
tstart = 0;                                                 % Starttid f?r simulering [s]
tend   = 10;                                                % Sluttid f?r simulering [s] 
vstart = 50/3.6;                                            % Utg?ngshastighet [m/s]
sstart = 0;                                                 % Utg?ngsstr?cka [m]
tspan  = [tstart tend];                                     % Start- och sluttid f?r simulering [s]
IC     = [vstart sstart];                                   % S?tter initialvillkor s? att vi bromsar fr?n utg?ngshastigheten och utg?ngsposition 
% L?s problem med l?mplig ode-l?sare
opt    = odeset('RelTol',1e-9);                             % S?tter toleranser p? l?saren
[T,Y] = ode45('derivatabromsning',tspan,IC,opt);            % Anropar ode-l?sare
% Dela upp tillst?ndsmatris p? vektorer
V      = Y(:,1);                                            % Hastighet [m/s]
S      = Y(:,2);                                            % Str?cka [m]
% Ber?kna kontaktkrafter och erforderlig bromsmoment
Frull  = f*m*g*(V>0);                                       % Rullmotst?nd [N]
Fluft  = 0.5*c*rho*A*V.^2.*(V>0);                           % Luftmotst?nd [N]
N2     = (m*g*L1-Frull*H1+Fluft*H2)./(L1+L2+mu*H1*(V>0));   % Normalkraft mellan bakd?ck och v?gbana [N]
N1     =  m*g-N2;                                           % Normalkraft mellan framd?ck och v?gbana [N]
F      = -mu*N2.*(V>0);                                     % Bromsande friktionskraft mellan bakd?ck och v?gbana [N]
M      =  mu*N2*r.*(V>0);                                   % Erforderligt bromsmoment f?r att l?sa bakaxeln [Nm]

% Utv?rdering av inbromsingsf?rlopp
i = find(V<1e-4,1);     % Hittar index till still?stende
t   = T(i);             % Inbromsningstid [s]
s   = S(i);             % Bromsstr?cka [m]
Mb  = max(M);           % Maximalt erfoderligt bromsmoment [Nm]

%% Presentation av resultat
% Grafer som visar hastighet och str?cka
figure(1)
subplot(2,1,1)
plot(T,V*3.6,'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('v [km/h]')
subplot(2,1,2)
plot(S,V*3.6,'LineWidth',2)
grid on
xlabel('s [m]')
ylabel('v [km/h]')
% Grafer som visar kontaktkrafter mellan d?ck och v?gbana samt erforderligt
% bromsmoment
figure(2)
subplot(2,1,1)
plot(T,[N1 N2],'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('N_1, N_2 [N]')
legend('N_1','N_2')
subplot(2,1,2)
plot(T,M,'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('M [Nm]')
% Utskrift i command window
disp(['Stopptid:     ' num2str(t) ' s'])
disp(['Stoppstr?cka: ' num2str(s) ' m'])
disp(['Bromsmoment:  ' num2str(Mb) ' Nm'])


%% EOF
