 clc; clear

            F               =       1e2;
            Fc              =       1e3;
            Fs              =       1e4;
            Frame           =       1  ;
            MaxAmplitude    =       1  ;
            power           =       0  ;


[SamplesY,Int16,Int16Curr,SamplesYcur,TimeAxis] = Smisetel_Verilog(F,Fs,Frame,MaxAmplitude,Fc);

%%
int16_double = double(Int16);
Int16Curr_double = double(Int16Curr);
Multy = Int16Curr_double.*int16_double;
RealMatlab = real(Multy);
ImagMatlab = imag(Multy);
RealData = DataVivado(1:2:end)';
ImagData = DataVivado(2:2:end)';
%%
RealDifferent=RealMatlab(1:9994)-RealData;
ImagDifferent=ImagMatlab(1:9994)-ImagData;

subplot(211)
plot(RealDifferent)

subplot(212)
plot(ImagDifferent)
