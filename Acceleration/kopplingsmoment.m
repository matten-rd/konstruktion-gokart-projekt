function MK = kopplingsmoment(omega1)
% Funktionsfil f�r ber�kning av maximalt �verf�rbart kopplingsmoment som
% funktion av vinkelhastigheten hos medbringaren.
%
% OBS! Ekvationerna i funktionen ska bytas ut n�r ni kommer s�
% l�ngt att ni har tagit fram en modell som beskriver er egen koppling.
%
% Anders S�derberg, KTH Maskinkonstuktion, 2019-08-13

b(1) =  -3.392;
b(2) =  2.148e-004;

MK = b(1) + b(2)*omega1.^2;     % Maximalt �verf�rbart kopplingsmoment [Nm]
MK = MK.*(MK>0);                % Ingen kontakt mellan block och trumma: MK=0 Nm

end