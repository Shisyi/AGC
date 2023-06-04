clc,clear,close all
%%
F               = 1e1;
Fs              = 100e2;
Frame           = 1  ;
Amplitudes      = [0.1,1,0.5,1,0.25];
R               = 2;
a               = 0.01;
alpha           = 0.4;
NumFrames       = length(Amplitudes);
SamplesY        = [];
TimeAxis        = [];

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


