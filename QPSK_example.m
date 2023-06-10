%% Try to create QPSK, sps = 4, 2 bits in symbol
clc, clear, close all
Amplitudes      = [0.1,1,0.5,1,0.25];
NumFrames       = length(Amplitudes);
SamplesY        = [];
BitsIn          = [];
SigMod          = [];

NumSym          = 100;
NumBitsInSymbol = 4;
sps             = 4; 
rolloff         = 0;           
span            = 100; %???

SQRRC = rcosdesign(rolloff, span, sps);

for i = 1:NumFrames
    x = randi([0 1],NumSym*NumBitsInSymbol,1);
    BitsIn = [BitsIn; x];
    QPSK   = qammod(x,NumBitsInSymbol,'InputType','bit');
    SigMod = [SigMod; QPSK];
    Signal = Amplitudes(i) * upfirdn(QPSK, SQRRC, sps);
    SamplesY = [SamplesY; Signal];
end

%% Graphs
scatterplot(QPSK)
figure(2),impz(SQRRC),grid on
figure(3),subplot(2,1,1),pspectrum(SamplesY),subplot(2,1,2),pwelch(SamplesY,[],[],[],[],'centered')
figure(4),subplot(2,1,1),plot(real(SamplesY)), grid on,subplot(2,1,2),plot(imag(SamplesY)), grid on

%% Try to understand fixed math
a = fi(1.99,1,16,14);
F = a.fimath;

b = fi(1.99,1,16,14);
M = b.fimath;

F.SumMode = 'SpecifyPrecision';
F.ProductMode = 'SpecifyPrecision';
F.OverflowAction = 'Saturate';
F.RoundMode = "Floor";
F.OverflowAction = 'Saturate';
F.ProductWordLength = 33;
F.ProductFractionLength = 30;

P = fipref;
P.LoggingMode = 'on';

a.fimath = F;
b.fimath = F;

c = a*b;