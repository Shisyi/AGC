clear ; clc

NumBitsPerSym = 4;
NumSym = 100;
NumFrame = 100;

h2db = 0:1:15;
ber = zeros(size(h2db));
NumBitsErr = 0
for i = 1:length(h2db);
    for k = 1 :NumFrame
        BitsIn = randi([0 1], k*NumSym*NumBitsPerSym,1);
        SigMod = qammod(BitsIn,2^NumBitsPerSym);
        
        Constellation = [sqrt(2) + j*sqrt(2),sqrt(2) - j*sqrt(2),-sqrt(2) + j*sqrt(2),-sqrt(2) - j*sqrt(2)];
        Ps = mean(abs(Constellation));
        Pb = Ps/NumBitsPerSym;
        Var = Pb*10^(h2db(i)/10);
        Noise = (randn(size(SigMod))+1*j*randn(size(SigMod)))*sqrt(Var/2);
        SigRx = SigMod + Noise;
        BitsOut = qamdemod(SigRx,2^NumBitsPerSym);
        NumBitsErr = NumBitsErr+biterr(BitsIn,BitsOut);
    end
    Ber(i) = NumBitsErr/(k*NumSym*NumBitsPerSym);
end
figure(1)
semilogy(h2db,Ber);


hold on

% Ber_teor = berawgn('qam',2^NumBitsPerSym,1);
Ber_teor = berawgn(h2db,'qam',2^NumBitsPerSym);
semilogy(h2db,Ber_teor)

%Peakfactor%
%mean(/s(t)/^2)%

%% Разбор кода банга

 clear ; clc, close all

sps = 100; % Количество точек импульса
pulse = cos(1.5*pi+pi*(0:1/sps:0.999)).^4; % Создаём импульс
% plot(pulse) % График импульса

M = 16;
%Bits_per_sym = log2(M); % Проверил количество битов на символ

NumBitsPerSym = 4;  % Количество бит которыми кодируется один символ
NumSym = 100;       % Количество символов в одном кадре    
NumFrame = 15;     % Количество Кадров [Весь сигнал = Количество кадров * Символы* бит на символ]

h2db = 0:1:10;      % Отношения сигнал шум
ber = zeros(size(h2db)); % Генерируем нулевую матрицу размера размаха SNR


 for i = 1:length(h2db)  % Цикл по каждому из значений SNR
     NumBitsErr = 0 ;    % Изначальное количество битовых ошибок инициализируем нулём
     for k = 1 :NumFrame  % Цикл по каждому кадру (Хз)
        %BitsIn = randi([0 15], NumSym*NumBitsPerSym,1);  % Инициализируем входной стигнал случайными 
        % числами от 0 до 15 , размера длительности всего сигнала ( если умножить на кадр)
        BitsIn = randi([0 1],k*NumSym*NumBitsPerSym,1); %% 0|1
        SigMod = qammod(BitsIn,M,'InputType','bit'); %% Подаём последовательность 0 | 1 на модулятор 
        % и получаем модулированные QAM - 16 значения
        %scatterplot(SigMod), grid on,hold on  % График созвездия
        
        % Формируем шум
        Constellation = [-3 -3i 3 3i -3 -3-3i -3i 3-3i 3 3+3i 3i -3+3i -1 -1i 1 1i];
        Ps = mean(abs(Constellation).^2);
        Pb = Ps/NumBitsPerSym;
        Var = Pb*10^(-h2db(i)/10);
        Noise = (randn(size(SigMod))+1*1j*randn(size(SigMod)))*sqrt(Var/2);

        % Формируем модулированный сигнал
        SigRx = SigMod + Noise; % Добавляем шум к модулированной последовательности

        %h = scatterplot(SigRx), hold on, scatterplot(SigMod,[],[],'r*',h)  % График созвездия с шумом

        baseband = upfirdn(SigRx,pulse,sps); % Переносим последовательность символов на синусоидe
       
        % Демодулируем сигнал
        %SigDe   = decimate(baseband,sps);
        SigDe   = downsample(baseband,sps,sps/2);
        BitsOut = qamdemod(SigDe,M,'OutputType','bit');
        NumBitsErr = NumBitsErr+biterr(BitsIn,BitsOut);


     end
    ber(i) = NumBitsErr/(k*NumSym*NumBitsPerSym);
 end
        figure
        subplot(3,1,1)
        plot(real(baseband)),grid on, hold on % Вещественная часть QAM - 16 через Cos^4
        title('Вещественная часть Cos^4')
        subplot(3,1,2)
        plot(imag(baseband)),grid on % Мнимая часть QAM - 16 через Cos^4
        title('Вещественная часть Cos^4')

subplot(3,1,3)                                                            
semilogy(h2db,ber),hold on, grid on;

Ber_teor = berawgn(h2db,'qam',2^NumBitsPerSym);
semilogy(h2db,Ber_teor);
title('Сравнение теоретической и полученной ошибок в битах');

figure
subplot(2,1,1) 
pspectrum(baseband);
subplot(2,1,2)
pwelch(baseband,[],[],[],[],'centered')

h = scatterplot(SigRx); hold on, scatterplot(SigMod,[],[],'r*',h)

figure
plot(BitsIn,'b-'), grid on, hold on,xlim([0 50]),ylim([-0.5 1.5]),title('BitsIn, BitsOut')
plot(BitsOut,'x'),legend;