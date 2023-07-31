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
%% Graphs
figure(1)
subplot(211)
    plot(out.clk_10(1,1:20000)),hold on, grid on
    plot(out.clk_2(1,1:20000)),
    plot(out.clk_4(1,1:20000)),
    plot(out.clk_40(1,1:20000)),
    legend('10clk','2clk','4clk','40clk','location','best')
subplot(212)
    pwelch(out.clk_10(1,1:20000),[],[],[],[],'centered'),hold on,
    pwelch(out.clk_2(1,1:20000),[],[],[],[],'centered'),
    pwelch(out.clk_4(1,1:20000),[],[],[],[],'centered'),
    pwelch(out.clk_40(1,1:20000),[],[],[],[],'centered'),
    legend('10clk','2clk','4clk','40clk','location','best')
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
%%
ReadData = readmatrix('DataVivado.txt');
RealDataVivado = ReadData(1:2:end);
ImagDataVivado = ReadData(2:2:end);
figure(2)
subplot(211)
    plot(RealDataVivado(3:end)/2^18),hold on, grid on,
    plot(double(out.clk_40(1,3:20000))),
    legend('Vivado','Matlab','location','best')
subplot(212)
    pwelch(RealDataVivado/2^18,[],[],[],[],'centered'),hold on,
    pwelch(double(out.clk_40(1,3:20000)),[],[],[],[],'centered'),
    legend('Vivado','Matlab','location','best')