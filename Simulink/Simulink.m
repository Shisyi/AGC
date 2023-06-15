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
span            = 32; %???
%% Sine wave
for i = 1:NumFrames
    [s,t]    = SignalGFunction(F,Fs,Frame,Amplitudes(i));
    SamplesY = [SamplesY, s];
    TimeAxis = [TimeAxis, t + (i-1)*Frame];
end

FixedRe = timeseries(fi(real(SamplesY),1,16,14),TimeAxis);
FixedIm = timeseries(fi(imag(SamplesY),1,16,14),TimeAxis);
FixedR  = fi(R,0,2,0);
Fixeda  = fi(a,1,13,12);

RealSimpleAGC = timeseries(real(SamplesY),TimeAxis); 
ImagSimpleAGC = timeseries(imag(SamplesY),TimeAxis);
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
TimeAxis = 40*0.0001/length(SamplesY)*(0:1:length(SamplesY)-1);

FixedRe = timeseries(fi(real(SamplesY),1,16,14),TimeAxis);
FixedIm = timeseries(fi(imag(SamplesY),1,16,14),TimeAxis);
FixedR  = fi(R,0,2,0);
Fixeda  = fi(a,1,13,12);

RealSimpleAGC = timeseries(real(SamplesY),TimeAxis); 
ImagSimpleAGC = timeseries(imag(SamplesY),TimeAxis);
