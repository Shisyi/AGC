function [SamplesY,Int16,Int16Curr,SamplesYcur,TimeAxis] = Smisetel_Verilog(F,Fs,Frame,MaxAmplitude,Fc,NoisePowerdBW)

    dt              =           1/Fs                        ;
    L               =           round(Frame/dt)             ;
    n               =           0:1:L-1                     ;
    TimeAxis        =           n*dt                        ;

if nargin == 5

    SamplesY        =   exp(1j * 2 * pi * F * dt *n)        ;
    SamplesY        =   MaxAmplitude * SamplesY * 2 ^ 14             ;
    SamplesYcur     =   exp(1j * 2 * pi * Fc * dt *n) * 2 ^ 14       ;   

    NameData        =   'Data.txt'                      ;
    [Int16]     =   ToInt16((SamplesY), NameData)   ;



    NameCurr    =   'DataCurr.txt'                     ;
    [Int16Curr]             =   ToInt16((SamplesYcur),NameCurr);



elseif nargin == 6

    SamplesY        =   exp(1j * 2 * pi * F * dt *n)        ;
    [NoiseY]        =   Noise(Fs,Frame,NoisePowerdBW)       ;
    SamplesY        =   MaxAmplitude * SamplesY + NoiseY    ;
    SamplesYcur     =   exp(1j * 2 * pi * Fc * dt *n)       ;

end

