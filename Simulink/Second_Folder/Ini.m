clc,clear,close all
%% Parameters
F               = 1e1;
Fs              = 200e6;
Frame           = 1  ;
Amplitudes      = [0.1,1,0.5,1,0.25];
R               = 2;
a               = 0.01;
alpha           = 0.4;
NumFrames       = length(Amplitudes);
SamplesY        = [];
TimeAxis        = [];

NumSym          = 1e3;
NumBitsInSymbol = 4;
sps             = 4; 
rolloff         = 0.3;           
span            = 32; 
%% QPSK - signal

SQRRC = rcosdesign(rolloff, span, sps);
delay = mean(grpdelay(SQRRC));

for i = 1:NumFrames
    x = randi([0 3],NumSym,1);
    QPSK   = qammod(x,NumBitsInSymbol);
    Signal = Amplitudes(i) * upfirdn(QPSK, SQRRC, sps);
     Signal(1:delay-1)     = [];
     Signal(end-delay+3:end) = [];
    SamplesY = [SamplesY; Signal];
end
SamplesY = SamplesY.';

FixedRe = fi(real(SamplesY),1,16,14);
FixedIm = fi(imag(SamplesY),1,16,14);
FixedR  = fi(R,0,2,0);
Fixeda  = fi(a,1,13,12);

RealSimpleAGC = real(SamplesY); 
ImagSimpleAGC = imag(SamplesY);