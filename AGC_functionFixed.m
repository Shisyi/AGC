function [Out,Product] = AGC_functionFixed(Signal,R,Alpha)
%% Make it on fxp
Alpha        = fi(Alpha,1,13,12);
R            = fi(R,0,2,0);

Out(1)       = fi(Signal(1),1,16,11);
Real         = [fi(zeros(0,length(Signal)),1,16,11)];
Imag         = [fi(zeros(0,length(Signal)),1,16,11)];
RealIn2      = [fi(zeros(0,length(Signal)),1,33,22)];
ImagIn2      = [fi(zeros(0,length(Signal)),1,33,22)];
Sum          = [fi(zeros(0,length(Signal)),1,34,22)];
Sqrt         = [fi(zeros(0,length(Signal)),1,18,11)];
Product      = [fi(zeros(0,length(Signal)),1,19,11)];
TimeControll = [fi(zeros(0,length(Signal)),1,34,23)];
Delay        = [fi(zeros(0,length(Signal)),1,35,23)];

F                       = Real.fimath;
F.ProductMode           = 'SpecifyPrecision';
F.OverflowAction        = 'Saturate';
F.RoundMode             = "Floor";
F.OverflowAction        = 'Saturate';
F.ProductWordLength     = 33;
F.ProductFractionLength = 28;

Real.fimath             = F;
Imag.fimath             = F;

M                       = TimeControll.fimath;
M.ProductMode           = 'SpecifyPrecision';
M.OverflowAction        = 'Saturate';
M.RoundMode             = "Floor";
M.OverflowAction        = 'Saturate';
M.ProductWordLength     = 35;
M.ProductFractionLength = 26;

TimeControll.fimath     = M;


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
        TimeControll(i)= Product(i) * fi(Alpha,1,13,12);
        % Тут я предполгаю, что можно округлить это умножение
        Delay(i)       = TimeControll(i) + Delay(i-1);
        % Фи сам округляет до 1 16 11
        Out(i+1)       = Signal(i+1) * Delay(i) ;

    end

end
Product(length(Signal)) = 0;
% Out = fi(Out,1,16,10);

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

