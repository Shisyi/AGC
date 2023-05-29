function [Out,Product] = AGC_functionFixed(Signal,R,Alpha)
%% Make it on fxp
Alpha        = fi(Alpha,1,13,12);
R            = fi(R,0,2,0);

Out          = [fi(zeros(0,length(Signal)),1,16,11)];
Out(1)       = fi(Signal(1),1,16,11);
Real         = [fi(zeros(0,length(Signal)),1,16,11)];
Imag         = [fi(zeros(0,length(Signal)),1,16,11)];
RealIn2      = [fi(zeros(0,length(Signal)),1,33,22)];
ImagIn2      = [fi(zeros(0,length(Signal)),1,33,22)];
Sum          = [fi(zeros(0,length(Signal)),1,34,22)];
Sqrt         = [fi(zeros(0,length(Signal)),1,18,11)];
Product      = [fi(zeros(0,length(Signal)),1,19,11)];
TimeControll = [fi(zeros(0,length(Signal)),1,25,16)];
Delay        = [fi(zeros(0,length(Signal)),1,25,16)];

F                       = Real.fimath;
F.ProductMode           = 'SpecifyPrecision';
F.OverflowAction        = 'Saturate';
F.RoundMode             = "Floor";
F.OverflowAction        = 'Saturate';
F.ProductWordLength     = 33;
F.ProductFractionLength = 28;

Real.fimath             = F;
Imag.fimath             = F;


%% Скользящее среднее всего сигнала Раскомитить данную секцию - чтобы посмотреть что выйдет
% windowSize = 64;
% window = fi(windowSize,0,6,0);
% Signal_L    = [fi(zeros(0,length(Signal)),1,16,11)];
% 
% for i = 64: length(Signal) 
%     value = fi(0,1,25,16);
%     for j = 0: windowSize - 1
%         value    = value + Signal(i-j);
%     end
%     Signal_L(i) =  value/window;
% 
% end
% Signal(windowSize:end) = Signal_L(windowSize:end);
%% Без логарифма
for i = 1: length(Signal)
    
    if i == 1
        % Квадрат вещественной части 1 33 28
        Real(i)           = real(Signal(i));
        RealIn2(i)        = Real(i)*Real(i);  
        % Квадрат мнимой 1 33 28
        Imag(i)           = imag(Signal(i)); 
        ImagIn2(i)        = Imag(i)*Imag(i);
        % Сумма 1 33 28 с 1 33 28 = 1 34 28
        Sum(i)            = RealIn2 + ImagIn2;    
        % Квадратный корень 1 18 14
        Sqrt(i)           = sqrt(Sum);    
        % Разница 1 19 14
        Product(i)        = R - Sqrt(i);                     
        % Умножение на константу 1 32 26
        TimeControll(i)= Product(i) * Alpha;
        % Тут я предполгаю, что можно округлить это умножение
        Delay(i)       = TimeControll(i);
        % Предполагаю разрядности для воздведения в степень двойки
        Out(i+1)       = Signal(i+1) * Delay(i) ;

    elseif i < length(Signal)

        Real(i)           = real(Out(i));
        RealIn2(i)        = Real(i)*Real(i);  
        % Квадрат мнимой 1 33 30
        Imag(i)           = imag(Out(i)); 
        ImagIn2(i)        = Imag(i)*Imag(i);
        % Сумма 1 32 30 с 1 32 30 = 1 33 30
        Sum(i)            = RealIn2(i) + ImagIn2(i);
        % Квадратный корень 1 18 14
        Sqrt(i)           = sqrt(Sum(i));
        % Разница 1 19 14
        Product(i)        = R - Sqrt(i);
        % Умножение на константу 1 32 27
        TimeControll(i)= Product(i) * Alpha;
        % Тут я предполгаю, что можно округлить это умножение
        Delay(i)       = TimeControll(i) + Delay(i-1);
        % Фи сам округляет до 1 16 11
        Out(i+1)       = Signal(i+1) * Delay(i) ;

    end

end
Product(length(Signal)) = 0;
%% Добавление аппроксимации модуля  Андрея Валерьевича
% a = fi(0.875,0,3,3);
% b = fi(0.5,0,1,1);
% 
% Sum          = [fi(zeros(0,length(Signal)),1,17,11)];
% Product      = [fi(zeros(0,length(Signal)),1,19,11)];
% TimeControll = [fi(zeros(0,length(Signal)),1,25,16)];
% Delay        = [fi(zeros(0,length(Signal)),1,25,16)];
% for i = 1: length(Signal)
%     
%     if i == 1
%         % Квадрат вещественной части 1 33 28
%         Real(i)           = max(abs(real(Signal(i))),abs(imag(Signal(i)))); 
%         % Квадрат мнимой 1 33 28
%         Imag(i)           = min(abs(real(Signal(i))),abs(imag(Signal(i))));  
%         % Сумма 1 33 28 с 1 33 28 = 1 34 28
%         Sum(i)            = a*Real + b*Imag;      
%         % Разница 1 19 14
%         Product(i)        = R - Sum(i);                     
%         % Умножение на константу 1 32 26
%         TimeControll(i)= Product(i) * Alpha;
%         % Тут я предполгаю, что можно округлить это умножение
%         Delay(i)       = TimeControll(i);
%         % Предполагаю разрядности для воздведения в степень двойки
%         Out(i+1)       = Signal(i+1) * Delay(i) ;
% 
%     elseif i < length(Signal)
% 
%         Real(i)           = max(abs(real(Out(i))),abs(imag(Out(i))));
%         % Квадрат мнимой 1 33 30
%         Imag(i)           = min(abs(real(Out(i))),abs(imag(Out(i)))); 
%         % Сумма 1 32 30 с 1 32 30 = 1 33 30
%         Sum(i)            = a*Real(i) + b*Imag(i);
%         % Разница 1 19 14
%         Product(i)        = R - Sum(i);
%         % Умножение на константу 1 32 27
%         TimeControll(i)= Product(i) * Alpha;
%         % Тут я предполгаю, что можно округлить это умножение
%         Delay(i)       = TimeControll(i) + Delay(i-1);
%         % Фи сам округляет до 1 16 11
%         Out(i+1)       = Signal(i+1) * Delay(i) ;
% 
%     end
% 
% end
% Product(length(Signal)) = 0;

%% Добавление скользящего среднего внутри AGC ( расскомитить данную секцию)

% windowSize = 64;
% window = fi(windowSize,0,6,0);
% Out(1)       = fi(Signal(1),1,16,11);
% 
% Sqrt_pre     = [fi(zeros(0,length(Signal)),1,18,11)];
% for i = 1: length(Signal) +(windowSize-1)
%     
%     if i <= 64
% 
%         % Квадрат вещественной части 1 33 28
%         Real(i)           = real(Signal(i));
%         RealIn2(i)        = Real(i)*Real(i);  
%         % Квадрат мнимой 1 33 28
%         Imag(i)           = imag(Signal(i)); 
%         ImagIn2(i)        = Imag(i)*Imag(i);
%         % Сумма 1 33 28 с 1 33 28 = 1 34 28
%         Sum(i)            = RealIn2(i) + ImagIn2(i);    
%         % Квадратный корень 1 18 14
%         Sqrt_pre(i)       = sqrt(Sum(i));
%         if i == 64
%             value = fi(0,1,25,16);
%             for j = 0: windowSize - 1
%                 value    = value + Sqrt_pre(i-j);
%             end
%             Sqrt(i-(windowSize-1)) =  value/window;
%         
%             % Разница 1 19 14
%             Product(i-(windowSize-1))   = R - Sqrt(i-(windowSize-1));                     
%             % Умножение на константу 1 32 26
%             TimeControll(i-(windowSize-1))= Product(i-(windowSize-1)) * Alpha;
%             % Тут я предполгаю, что можно округлить это умножение
%             Delay(i-(windowSize-1))       = TimeControll(i-(windowSize-1));
%             % Предполагаю разрядности для воздведения в степень двойки
%             Out(i+1-(windowSize-1))       = Signal(i+1-(windowSize-1)) * Delay(i-(windowSize-1)) ;
%         end
%     elseif i < length(Signal) +(windowSize-1)
% 
%         Real(i)           = real(Out(i-(windowSize-1)));
%         RealIn2(i)        = Real(i)*Real(i);  
%         % Квадрат мнимой 1 33 30
%         Imag(i)           = imag(Out(i-(windowSize-1))); 
%         ImagIn2(i)        = Imag(i)*Imag(i);
%         % Сумма 1 32 30 с 1 32 30 = 1 33 30
%         Sum(i)            = RealIn2(i) + ImagIn2(i);
%         % Квадратный корень 1 18 14
%         Sqrt_pre(i)       = sqrt(Sum(i));
%         value = fi(0,1,25,16);
%             for j = 0: windowSize - 1
%                 value    = value + Sqrt_pre(i-j);
%             end
%         Sqrt(i-(windowSize-1)) =  value/window;
%         % Разница 1 19 14
%         Product(i-(windowSize-1))        = R - Sqrt(i-(windowSize-1));
%         % Умножение на константу 1 32 27
%         TimeControll(i-(windowSize-1))= Product(i-(windowSize-1)) * Alpha;
%         % Тут я предполгаю, что можно округлить это умножение
%         Delay(i-(windowSize-1))       = TimeControll(i-(windowSize-1)) + Delay(i-1-(windowSize-1));
%         % Фи сам округляет до 1 16 11
%         Out(i+1-(windowSize-1))       = Signal(i+1-(windowSize-1)) * Delay(i-(windowSize-1)) ;
% 
%     end
% 
% end
% Product(length(Signal)) = 0;

%% Логарифм по основанию два

% for i = 1: length(Signal)
%     
%     if i == 1
%         % Квадрат вещественной части 1 33 30
%         RealIn2(i)        = fi(real(Signal(i)),'fimath',f)*fi(real(Signal(i)),'fimath',f);  
%         % Квадрат мнимой 1 33 30
%         ImagIn2(i)        = fi(imag(Signal(i)),'fimath',f)*fi(imag(Signal(i)),'fimath',f); 
%         % Сумма 1 32 30 с 1 32 30 = 1 33 30
%         Sum(i)            = RealIn2 + ImagIn2;    
%         % Квадратный корень 1 17 15
%         Sqrt(i)           = sqrt(Sum);    
%         % Логарифм по основанию 2 1 19 15
%         Logo(i)           = fi(log2(double(Sqrt)),1,19,15);
%         % Логарифм по основанию 2 2
%         LogR(i)           = fi(log2(R),0,2,0); 
%         % Разница 1 19 15
%         Product(i)        = fi(LogR - Logo(i),1,19,15);                     
%         % Умножение на константу 1 32 27
%         TimeControll(i)= Product(i) * fi(Alpha,1,13,12);
%         % Тут я предполгаю, что можно округлить это умножение
%         Delay(i)       = fi(TimeControll(i),1,19,15);
%         % Предполагаю разрядности для воздведения в степень двойки
%         DelayIn2(i)    = fi(2^(double(Delay(i))),1,22,18);
%         % Фи сам округляет до 1 16 11
%         Out(i+1)       = Signal(i+1) * DelayIn2(i) ;
% 
%     elseif i < length(Signal)
% 
%         % Квадрат вещественной части 1 33 30
%         RealIn2(i)        = fi(real(Out(i)),'fimath',f)*fi(real(Out(i)),'fimath',f);  
%         % Квадрат мнимой 1 33 30
%         ImagIn2(i)        = fi(imag(Out(i)),'fimath',f)*fi(imag(Out(i)),'fimath',f);
%         % Сумма 1 32 30 с 1 32 30 = 1 33 30
%         Sum(i)            = RealIn2(i) + ImagIn2(i);
%         % Квадратный корень 1 17 15
%         Sqrt(i)           = sqrt(Sum(i));
%         % Логарифм по основанию 2 1 19 15
%         Logo(i)            = fi(log2(double(Sqrt(i))),1,19,15); 
%         % Логарифм по основанию 2 2
%         LogR              = fi(log2(R),1,2);
%         % Разница 1 19 15
%         Product(i)        = LogR - Logo(i);
%         % Умножение на константу 1 32 27
%         TimeControll(i)= Product(i) * fi(Alpha,1,13,12);
%         % Тут я предполгаю, что можно округлить это умножение
%         Delay(i)       = fi(TimeControll(i),1,19,15) + Delay(i-1);
%         % Предполагаю разрядности для воздведения в степень двойки
%         DelayIn2(i)    = fi(2^(double(Delay(i))),1,22,18);
%         % Фи сам округляет до 1 16 11
%         Out(i+1)       = Signal(i+1) * DelayIn2(i) ;
% 
%     end
% 
% end
% Out = fi(Out,1,16,11);
% Product(length(Signal)) = 0;
end

