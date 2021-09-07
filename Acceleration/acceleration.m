% Huvudprogram f�r simulering av accelerationsf�rlopp av gokart med c-koppling och v�xel.
% 
% Programmet anropar funktionsfilerna:
%   1. motormoment.m
%   2. kopplingsmoment.m
%   3. lastmoment.m
%   4. derivataacceleration.m
% 
% Anders S�derberg, KTH - Maskinkonstruktion, 2019-08-13

%% St�dar arbetsminnet och command window, samt st�nger alla �ppna f�nster
clear all
clc
close all

%% S�tter v�rden p� systemparametrar

% Definera systemparametar som globala
global eta u r m  JM JK1 JK2 JV1 JV2 JL g f c rho A

% Data f�r gokart
m   = 120;                  % Total massa [kg]
r   = 0.135;                % Hjulradie [m]
A   = 0.5;                  % Projicerad area f�r luftmotst�nd [m^2]
f   = 0.012;                % Rullmotst�ndskoefficient [-]
g   = 9.81;                 % Tyngdacceleration [m/s^2]
c   = 0.6;                  % Luftmotst�ndskoefficient [-]
rho = 1.22;                 % Denstitet hos luft [kg/m^3]

% Masstr�ghetsmoment i systemet:
JM  = 0.02;                 % Tr�ghetsmoment f�r motorn [kg*m^2]
JK1 = 0.003;                % Tr�ghetsmoment f�r medbringar med block [kg*m^2]
JK2 = 0.005;                % Tr�ghetsmoment f�r trumma [kg*m^2]
JV1 = 0;                    % Tr�ghetsmoment f�r v�xel drev [kg*m^2]
JV2 = 0;                    % Tr�ghetsmoment f�r v�xel hjul [kg*m^2]
JA  = 0.070;                % Tr�ghetsmoment f�r bakaxel [kg*m^2]
JB  = 0;                    % Tr�ghetsmoment f�r bromsskiva [kg*m^2]
JH  = 0;                    % Tr�ghetsmoment per hjul [kg*m^2]
JL  = JA+JB+4*JH+m*r^2;     % Tr�ghetsmoment f�r lasten [kg*m^2]

% Data f�r motorn
n0   =  1000;               % Tomg�ngsvarvtal [rpm]

% Data f�r v�xeln
u   =    2;                 % Utv�xling [-]
eta =    0.95;              % Verkningsgrad i v�xel [-]


%% Plot av momentkurvor

% Definition av varvtalsvektorer
n1     = n0:8000;                   % Motorvarvtal [rpm]
n2     = 0:8000;                    % Utg�ende varvtal fr�n koppling [rpm]
n3     = n2/u;                      % Varvtal p� bakaxel [rpm]

% Ber�kning av vinkelhastighetersvektorer
omega1 = n1*2*pi/60;                % Vinkelhastighet p� motoraxel [1/s]
omega2 = n2*2*pi/60;                % Utg�ende vinkelhastighet fr�n koppling [1/s]
omega3 = n3*2*pi/60;                % Vinkelhastighet p� bakaxel [1/s]
v      = omega3*r;                  % Hastighet hos gokart [m/s]

% Ber�kning av momentvektorer
MM     = motormoment(omega1);       % Motormoment [Nm]
MK     = kopplingsmoment(omega1);   % Maximalt �verf�rbart kopplingsmoment [Nm]
ML     = lastmoment(v);             % Lastmoment [Nm]

% Plot av kurvor
figure(1)
plot(n1,MM,n1,MK,n2,ML/(eta*u),'LineWidth',2)
grid on
legend('Motor','Koppling','Last')
xlabel('n [rpm]')
ylabel('M [Nm]')
ylim([0 12])

% Svar till resultablad
i  = find(MK>0, 1 );
nA =n1(i);
disp(['Kopplingen b�rjar slira vid n1=' num2str(nA) ' rpm'])
i  = find(MK>=(ML(1)/(eta*u)), 1 );
nB = n1(i);
disp(['Bakaxeln b�rjar rotera vid n1=' num2str(nB) ' rpm'])
i = find(MK>=MM, 1 );
nC = n1(i);
disp(['Kopplingen slutar slira vid n1=' num2str(nC) ' rpm'])
i = find(n2>=n0);
j = find(MM<=(ML(i)/(eta*u)), 1 );
nD = n1(j);
disp(['Systemet n�r kontiumerlig drift vid n1=' num2str(nD) ' rpm'])
vD = 2*pi/60*nD/u*r;
disp(['Teoretisk topphastighet hos fordonet �r ' num2str(vD*3.6) ' m/s'])

%% Simulering av accelerationsf�rlopp
% Definiera tidsintervall och begynnelsevillkor
tspan  = [0:0.001:90];                      % Start- och sluttid f�r simulering [s]
IC     = [n0*2*pi/60 0 0 0 0];              % Vid start g�r motorn p� tomg�ng och lasten st�r still

% L�s problem med l�mplig ode-l�sare
opt    = odeset('RelTol',1e-9);             % S�tter toleranser p� l�saren
[T,Y] = ode45('derivataacceleration',tspan,IC,opt);    % Anropar ode-l�sare

% Dela upp tillst�ndsmatris p� vektorer
Omega1 = Y(:,1);                            % Vinkelhastighet p� motoraxel [rad/s]
Omega2 = Y(:,2);                            % Vinklehastighet p� kopplingstrumma [rad/s]
Omega3 = Y(:,3);                            % Vinkelhastighet p� bakaxel [rad/s]
V      = Y(:,4);                            % Hastighet p� gokart [m/s]
S      = Y(:,5);                            % F�rdstr�cka f�r gokart [m]

% Ber�kna varvtalsvektorer
N1 = Omega1*60/(2*pi);                      % Varvtal p� motoraxel [rpm]
N2 = Omega2*60/(2*pi);                      % Varvtal p� kopplingstrumma [rpm]
N3 = Omega3*60/(2*pi);                      % Varvtal p� bakaxel [rpm]

% Graf som visar varvtal p� axlar sfa tid
figure(2)
plot(T,[N1 N2 N3],'LineWidth',2)
grid on
legend('n_1','n_2','n_3')
xlabel('t [s]')
ylabel('n [rpm]')

% Graf som visar gokartenshastighet sfa tid
figure(3)
plot(T,V*3.6,'LineWidth',2)
grid on
xlabel('t [s]')
ylabel('v [km/h]')

% Graf som visar gokartens hastighet sfa k�rstr�cka
figure(4)
plot(S,V*3.6,'LineWidth',2)
grid on
xlabel('s [m]')
ylabel('v [km/h]')

% Svar till resultatblad
disp(' ')
i = find(N1>=nA, 1 );
tA = T(i);
disp(['Kopplingen b�rjar slira vid n1=' num2str(ceil(N1(i))) ' rpm och t=' num2str(T(i)) ' s'])
i = find(N2>0, 1);
disp(['Lasten b�rjar rotera vid n1=' num2str(ceil(N1(i))) ' rpm och t=' num2str(T(i)) ' s'])
i = find(N2<=N1, 1, 'last' );
tC = T(i);
disp(['kopplingen slutar slira vid n1=' num2str(ceil(N1(i))) ' rpm och t=' num2str(T(i)) ' s'])
i = find(N1>=0.95*nD, 1);
disp(['Motorn n�r 95% av kontinuerligtdriftvarvatal (' num2str(ceil(N1(i))) ' rpm) vid t=' num2str(T(i)) ' s'])
disp(['Kopplingen slirar under totalt ' num2str(tC-tA) ' s'])
disp(['Fordonet n�r 95% hav teoretisk topphastighet efter ' ceil(num2str(S(i))) ' m och ' num2str(T(i)) ' s'])
i = find(V>(50*1e3/3600),1);
disp(['Fordonet n�r 50 km/h efter ' ceil(num2str(ceil(S(i)))) ' m och ' num2str(T(i)) ' s'])



%% EOF