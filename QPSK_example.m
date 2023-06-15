%% Try to create QPSK, sps = 4, 2 bits in symbol
% Минимальная полоса определяемая по Найквесту : W = 1/2 * Rs, Rs = sym/sec;
% Данный фильтр не реализуем => W = 1/2(1+r) * Rs, r = roll-off
clc, clear, close all
%%
Amplitudes      = [0.1,1,0.5,1,0.25];
NumFrames       = length(Amplitudes);
SamplesY        = [];
UpfirM          = [];
SigMod          = [];
SignalM         = [];

NumSym          = 1e3;
NumBitsInSymbol = 4;
sps             = 4; 
rolloff         = [0.3 0 1];           
span            = 32; %???

SQRRC(1,:) = rcosdesign(rolloff(1), span, sps,'sqrt');
SQRRC(2,:) = rcosdesign(rolloff(1), span, sps,'normal');

SQRRC(3,:) = rcosdesign(rolloff(2), span, sps,'sqrt');
SQRRC(4,:) = rcosdesign(rolloff(3), span, sps,'sqrt');

delay = mean(grpdelay(SQRRC(1,:)));

for i = 1:NumFrames
    x = randi([0 3],NumSym,1);
    symbols  = qammod(x,NumBitsInSymbol);
    SigMod   = [SigMod; symbols];

    Upfir    =  upfirdn(symbols, SQRRC(1,:)/max(SQRRC(1,:)), sps);
     Upfir(1:delay-1)     = [];
     Upfir(end-delay+3:end) = [];

     UpfirM    = [UpfirM;Upfir];
     Signal1   =  Amplitudes(i) * Upfir;
     SignalM   = [SignalM;Signal1];
    
    symbolsUp = upsample(symbols,4,1);
%      for j = 1:1000
%         Signal_pre(1:132)    =  Amplitudes(i) * conv(symbolsUp(1+sps*(j-1):4+sps*(j-1)),SQRRC,'full');
%         Signal_pre(1:delay-1)     = [];
%         Signal_pre(end-delay:end) = [];
%         Signal(1+sps*(j-1):4+sps*(j-1),1) = Signal_pre;
%      end
     Signal_sqrt   =  conv(symbolsUp,SQRRC(1,:)/max(SQRRC(1,:)));
     Signal_sqrt_rol0   =  conv(symbolsUp,SQRRC(3,:)/max(SQRRC(3,:)));
     Signal_sqrt_rol1   =  conv(symbolsUp,SQRRC(4,:)/max(SQRRC(4,:)));
     Signal_normal   =  conv(symbolsUp,SQRRC(2,:)/max(SQRRC(2,:)));

     Signal_sqrt(1:delay)     = [];
     Signal_sqrt_rol0(1:delay) = [];
     Signal_sqrt_rol1(1:delay) = [];
     Signal_normal(1:delay)     = [];

     Signal_sqrt(end-delay+1:end) = [];
     Signal_sqrt_rol0(end-delay+1:end) = [];
     Signal_sqrt_rol1(end-delay+1:end) = [];
     Signal_normal(end-delay+1:end) = [];

     Signal       = Amplitudes(i) * Signal_sqrt;
     SamplesY = [SamplesY ;Signal];
end

Err = max(SamplesY - SignalM);


%% Graphs
scatterplot(symbols)

figure(2),impz(SQRRC(1,:)),grid on

figure(3),subplot(3,1,1),pspectrum(SamplesY),subplot(3,1,2),pwelch(SamplesY,[],[],[],[],'centered'),
subplot(3,1,3),pwelch(SignalM,[],[],[],[],'centered')

figure(4),subplot(2,1,1),plot(real(SamplesY)), grid on,subplot(2,1,2),plot(imag(SamplesY)), grid on

figure(5),plot(real(SignalM)), hold on,grid on, plot(real(SamplesY))

figure(6),subplot(2,1,1),plot(real(Signal_sqrt),'-k'),hold on, stem(real(symbolsUp),'*','-r'),
grid on,plot(real(Signal_normal),'-b','LineStyle','--'),legend('Sqrt','Symbols','Normal',"Location","best"),

subplot(2,1,2),pwelch(real(Signal_sqrt),[],[],[],[],'centered'),hold on,pwelch(real(Signal_normal),[],[],[],[],'centered'),
legend('Sqrt','Normal',"Location","best"),

figure(7),subplot(2,1,1),plot(real(Signal_sqrt_rol0),'-k'),hold on, stem(real(symbolsUp),'*','-r'),
grid on,plot(real(Signal_sqrt_rol1),'-b','LineStyle','--'),legend('B = 0','Symbols','B = 1',"Location","best"),

subplot(2,1,2),pwelch(real(Signal_sqrt_rol0),[],[],[],[],'centered'),hold on,pwelch(real(Signal_sqrt_rol1),[],[],[],[],'centered'),
legend('B = 0','B = 1',"Location","best"),
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