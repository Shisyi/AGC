




function [Out,Product] = AGC_functionFixed(Signal,R,Alpha)
%% Make it on fxp
%%

Out(1) = fi(Signal(1),1,16,11);
f  = fimath('ProductWordLength',33,...
    'ProductMode','FullPrecision',...
    'OverflowAction','Saturate'...
    ,'CastBeforeSum',true,...
    'SumWordLength',34);
%% Логарифм по основанию два

for i = 1: length(Signal)
    
    if i == 1
        % Квадрат вещественной части 1 33 30
        RealIn2(i)        = fi(real(Signal(i)),'fimath',f)*fi(real(Signal(i)),'fimath',f);  
        % Квадрат мнимой 1 33 30
        ImagIn2(i)        = fi(imag(Signal(i)),'fimath',f)*fi(imag(Signal(i)),'fimath',f); 
        % Сумма 1 32 30 с 1 32 30 = 1 33 30
        Sum(i)            = RealIn2 + ImagIn2;    
        % Квадратный корень 1 17 15
        Sqrt(i)           = sqrt(Sum);    
        % Логарифм по основанию 2 1 19 15
        Logo(i)           = fi(log2(double(Sqrt)),1,19,15);
        % Логарифм по основанию 2 2
        LogR(i)           = fi(log2(R),0,2,0); 
        % Разница 1 19 15
        Product(i)        = fi(LogR - Logo(i),1,19,15);                     
        % Умножение на константу 1 32 27
        TimeControll(i)= Product(i) * fi(Alpha,1,13,12);
        % Тут я предполгаю, что можно округлить это умножение
        Delay(i)       = fi(TimeControll(i),1,19,15);
        % Предполагаю разрядности для воздведения в степень двойки
        DelayIn2(i)    = fi(2^(double(Delay(i))),1,22,18);
        % Фи сам округляет до 1 16 11
        Out(i+1)       = Signal(i+1) * DelayIn2(i) ;

    elseif i < length(Signal)

        % Квадрат вещественной части 1 33 30
        RealIn2(i)        = fi(real(Out(i)),'fimath',f)*fi(real(Out(i)),'fimath',f);  
        % Квадрат мнимой 1 33 30
        ImagIn2(i)        = fi(imag(Out(i)),'fimath',f)*fi(imag(Out(i)),'fimath',f);
        % Сумма 1 32 30 с 1 32 30 = 1 33 30
        Sum(i)            = RealIn2(i) + ImagIn2(i);
        % Квадратный корень 1 17 15
        Sqrt(i)           = sqrt(Sum(i));
        % Логарифм по основанию 2 1 19 15
        Logo(i)            = fi(log2(double(Sqrt(i))),1,19,15); 
        % Логарифм по основанию 2 2
        LogR              = fi(log2(R),1,2);
        % Разница 1 19 15
        Product(i)        = LogR - Logo(i);
        % Умножение на константу 1 32 27
        TimeControll(i)= Product(i) * fi(Alpha,1,13,12);
        % Тут я предполгаю, что можно округлить это умножение
        Delay(i)       = fi(TimeControll(i),1,19,15) + Delay(i-1);
        % Предполагаю разрядности для воздведения в степень двойки
        DelayIn2(i)    = fi(2^(double(Delay(i))),1,22,18);
        % Фи сам округляет до 1 16 11
        Out(i+1)       = Signal(i+1) * DelayIn2(i) ;

    end

end
% Out = fi(Out,1,16,11);
Product(length(Signal)) = 0;
end

