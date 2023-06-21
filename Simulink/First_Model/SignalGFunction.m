function [SamplesY,TimeAxis] = SignalGFunction(F,Fs,Frame,MaxAmplitude,NoisePowerdBW,Fc)

% Простейший случай синусоидального сигнала
    dt              =           1/Fs                        ;
    L               =           round(Frame/dt)             ;
    n               =           0:1:L-1                     ;
    TimeAxis        =           n*dt                        ;

if nargin == 4

    Signal          =   exp(1j * 2 * pi * F * dt *n)        ;
    SamplesY        =   Signal*MaxAmplitude                 ;

elseif nargin == 5

    Signal          =   exp(1j * 2 * pi * F * dt *n)        ;
    [NoiseY]        =   Noise(Fs,Frame,NoisePowerdBW)       ;
    SamplesY        =   Signal*MaxAmplitude + NoiseY        ;

elseif nargin == 6
    
    Signal          =   exp(1j * 2 * pi * F * dt *n)        ;
    SignalCur       =   exp(1j * 2 * pi * Fc * dt *n)       ;
    SamplesY        =   Signal.*SignalCur.*MaxAmplitude     ;

end

end

