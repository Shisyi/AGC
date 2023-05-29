clc, clear, close all;
%% Create input signal
F               = 1e1;
Fs              = 20e2;
Frame           = 1  ;
Amplitudes      = [0.1,1,0.5,1,0.25];

NumFrames       = length(Amplitudes);
SamplesY        = [];
TimeAxis        = [];

for i = 1:NumFrames
    [s,t]    = SignalGFunction(F,Fs,Frame,Amplitudes(i));
    SamplesY = [SamplesY, s];
    TimeAxis = [TimeAxis, t + (i-1)*Frame];
end

fiSampl = fi(SamplesY,1,16,14); %% Перевод в fxp, функцией фи
err = abs(max(fiSampl - SamplesY));

% figure('Name','InputSignal','NumberTitle','off')
% subplot(2,1,1),plot(TimeAxis,real(SamplesY)),title('Входной сигнал'),grid on,xlim([0 5])
% subplot(2,1,2),plot(TimeAxis,real(fiSampl)),title('Входной сигнал'),grid on,xlim([0 5])

%% Parameters, Fixed vs Double
R             = 2;
a             = 0.001;

[Out,Compare]   = AGC_functionFixed(fiSampl,R,a);
[Out2,Compare2] = AGC_function(SamplesY,R,a);

Err             = Out2-Out; % Ошибка в каждом отчёте
figure('Name','Err','NumberTitle','off')
plot(TimeAxis,abs(Err)./abs(Out2)),grid on % График ошибки в каждом отчёте
Err = max(abs(Out2-Out)); % Максимальная ошибка
%%
figure('Name','Log','NumberTitle','off')
subplot(3,1,1),plot(TimeAxis,real(SamplesY)),title('Входной сигнал'),grid on,xlim([0 5])

subplot(3,1,2),plot(TimeAxis,Out),hold on,plot([0 TimeAxis(length(TimeAxis))],[R R])

plot([0 TimeAxis(length(TimeAxis))],[-R -R]),title('AGC'),grid on,xlim([0 5]),ylim([-3*R 3*R])

plot(TimeAxis,Out2,'-o'),

subplot(3,1,3),plot(TimeAxis,Compare),hold on,title('Compare'),grid on,xlim([0 5]),ylim([-3*R 3*R])