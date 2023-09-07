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
FixedR  = fi(R,1,8,6);
Fixeda  = fi(a,1,13,12);

RealSimpleAGC = double(int16(real(SamplesY)*2^14))/2^14; 
ImagSimpleAGC = double(int16(imag(SamplesY)*2^14))/2^14;
%% To FPGA
NameData    =   'Data.txt';
[Int16]     =   ToInt16(SamplesY*2^14, NameData);
NameFilter  =   'Filter.txt';
[Int16]     =   ToInt16(alpha*2^13, NameFilter);
NameError   =   'Error.txt';
[Int16]     =   ToInt16(a*2^13,     NameError);

fp = fopen('R.txt','wt');
fprintf(fp, '%d', R*2^6);
fclose(fp);
%% Graphs
figure(1)
subplot(211)
    plot(double(out.clk_40(1,1:20000))),hold on, grid on
    legend('40clk','location','best')
subplot(212)
    pwelch(double(out.clk_40(1,1:20000)),[],[],[],[],'centered'),
    legend('40clk','location','best')
%%

ReadData = readmatrix('DataVivado.txt');
RealDataVivado = ReadData(1:2:end)'/2^14;
ImagDataVivado = ReadData(2:2:end)'/2^14;
