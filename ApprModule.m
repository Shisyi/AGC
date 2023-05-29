function [Out,Copmare] = ApprModule(Signal,R,Alpha,FromSciHub,Rashich)

Out            = complex(zeros(1,length(Signal)));  
RealOut        = complex(zeros(1,length(Signal))); 
ImagOut        = complex(zeros(1,length(Signal))); 
Copmare        = zeros(1,length(Signal))         ;
Out(1) = Signal(1);
%% Линейный
if nargin == 4
for i = 1: length(Signal)

    if i == 1
      
        MultyCos(i)    = abs(real(Signal(i)))+ abs(imag(Signal(i))) ;
        Copmare(i)     = R - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha   ;
        Delay(i)       = TimeControll(i)      ;
        Out(i+1)       = (Signal(i+1)) * Delay(i) ;


    elseif i < length(Signal)

        MultyCos(i)    = abs(real(Out(i)))+ abs(imag(Out(i))) ;        
        Copmare(i)     = R - MultyCos(i);
        TimeControll(i)= Copmare(i) * Alpha;
        Delay(i)       = Delay(i-1) + TimeControll(i);
        Out(i+1)       = (Signal(i+1)) * Delay(i) ;

    end
    S(i) = (Out(i)^2);
end
    Copmare(length(Signal)) = 0;

%% Аппроксимация Андрея Валерьевича
elseif nargin == 5
for i = 1: length(Signal)

    if i == 1
      
        MultyCos(i)    = 0.875*max(abs(real(Signal(i))),abs(imag(Signal(i))))+ 0.5*min(abs(real(Signal(i))),abs(imag(Signal(i)))) ;
        Copmare(i)     = R - MultyCos(i)      ;
        TimeControll(i)= Copmare(i) * Alpha   ;
        Delay(i)       = TimeControll(i)      ;
        Out(i+1)       = (Signal(i+1)) * Delay(i) ;


    elseif i < length(Signal)

        MultyCos(i)    = 0.875*max(abs(real(Out(i))),abs(imag(Out(i))))+ 0.5*min(abs(real(Out(i))),abs(imag(Out(i)))) ;       
        Copmare(i)     = R - MultyCos(i);
        TimeControll(i)= Copmare(i) * Alpha;
        Delay(i)       = Delay(i-1) + TimeControll(i);
        Out(i+1)       = (Signal(i+1)) * Delay(i) ;

    end
    S(i) = (Out(i)^2);
end
    Copmare(length(Signal)) = 0;
end
end

