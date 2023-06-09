function [Out,Copmare] = AGC_function(Signal,R,Alpha,Log)

Out            = complex(zeros(1,length(Signal)))  ;               
Copmare        = zeros(1,length(Signal))          ;
Out(1)         = Signal(1);
%% Скользящее среднее
% windowSize = 64;
% for i = 64: length(Signal) 
%     value = 0;
%     for j = 0: windowSize - 1
%         value    = value + Signal(i-j);
%     end
%     Signal_L(i) =  value/windowSize;
% 
% end
% Signal(windowSize:end) = Signal_L(windowSize:end);
%% Линейный
if nargin ==3
    
for i = 1: length(Signal)

    if i == 1
      
        MultyCos(i)    = (sqrt(real(Signal(i))^2+imag(Signal(i))^2))  ;
        Copmare(i)     = R - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha   ;
        Delay(i)       = TimeControll(i)      ;
        Out(i+1)       = Signal(i+1) * Delay(i) ;

    elseif i < length(Signal)

        MultyCos(i)    = (sqrt(real(Out(i))^2+imag(Out(i))^2));        
        Copmare(i)     = R - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha       ;
        Delay(i)       = Delay(i-1) + TimeControll(i);
        Out(i+1)       = Signal(i+1) * Delay(i) ;
    end
    S(i) = (Out(i)^2);
end
    Copmare(length(Signal)) = 0;

%% Логарифм по основанию два
elseif nargin ==4

for i = 1: length(Signal)

    if i == 1
  %      MultyCos(i)    = log2(abs(Signal(i)))  ;
        MultyCos(i)    = log2(sqrt(real(Signal(i))^2+imag(Signal(i))^2))  ;
        Copmare(i)     = log2(R) - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha       ;
        Delay(i)       = (TimeControll(i))      ;
        Out(i+1)       = Signal(i+1) * 2^(Delay(i)) ;

    elseif i < length(Signal)
 %       MultyCos(i)    = log2(abs(Out(i));
        MultyCos(i)    = log2(sqrt(real(Out(i))^2+imag(Out(i))^2));
        Copmare(i)     = log2(R) - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha       ;
        Delay(i)       = (Delay(i-1)) + TimeControll(i);
        Out(i+1)       = Signal(i+1) * 2^(Delay(i)) ;
    end
    S(i) = (Out(i)^2);
    Copmare(length(Signal)) = 0;
end

end

