function [Out,Copmare] = Lyons(Signal,R,Alpha,FilterAlfa,fixed)
%% Floating point
Out            = complex(zeros(1,length(Signal)));  
Sum            = complex(zeros(1,length(Signal)));
Product        = complex(zeros(1,length(Signal)));
Product_plus   = complex(zeros(1,length(Signal)));
Delay_filter   = zeros(1,length(Signal));
Delay_x        = zeros(1,length(Signal));
TimeControll   = complex(zeros(1,length(Signal))); 
Copmare        = zeros(1,length(Signal));
Delay          = zeros(1,length(Signal));
Out(1) = Signal(1);

if nargin == 4

    for i = 1: length(Signal)

        if i == 1
          
            Sum(i)         = abs(real(Signal(i)))+ abs(imag(Signal(i)));
            Product(i)     = Sum(i) * FilterAlfa/2;
            Delay_filter(i)= Product(i);
            Delay_x(i)     = Delay_filter(i)* (1-FilterAlfa);

            Copmare(i)     = R - Product(i);
            TimeControll(i)= Copmare(i) * Alpha;
            Delay(i)       = TimeControll(i);
            Out(i+1)       = (Signal(i+1)) * Delay(i) ;
    
    
        elseif i < length(Signal)
    
            Sum(i)         = abs(real(Out(i)))+ abs(imag(Out(i)));  
            Product(i)     = Sum(i) * FilterAlfa/2;
            Product_plus(i)= (Product(i) + Delay_x(i-1));
            Delay_filter(i)= Product_plus(i);
            Delay_x(i)     = Delay_filter(i)* (1-FilterAlfa);

            Copmare(i)     = R - 1.4*Product_plus(i);
            TimeControll(i)= Copmare(i) * Alpha;
            Delay(i)       = Delay(i-1) + TimeControll(i);
            Out(i+1)       = (Signal(i+1)) * Delay(i) ;
    
        end
    end
%% Fixed point
else if nargin == 5
    Alpha        = fi(Alpha,1,13,12);
    R            = fi(R,0,2,0);
    FilterAlfa   = fi(FilterAlfa,0,6,6);
    FilteredDrob = fi(FilterAlfa/2,0,6,6);
    K            = fi(1.4,0,6,5);
    One          = fi(1,0,1,0);
    OneMinus     = fi(One-FilterAlfa,0,6,6);
    
    Out          = [fi(zeros(0,length(Signal)),1,16,11)];
    Out(1)       = fi(Signal(1),1,16,11);
    Real         = [fi(zeros(0,length(Signal)),1,16,11)];
    Imag         = [fi(zeros(0,length(Signal)),1,16,11)];
    Sum          = [fi(zeros(0,length(Signal)),1,17,11)];
    Product      = [fi(zeros(0,length(Signal)),1,17,11)];
    Product_plus = [fi(zeros(0,length(Signal)),1,25,16)];
    Delay_filter = [fi(zeros(0,length(Signal)),1,25,16)];
    Delay_x      = [fi(zeros(0,length(Signal)),1,25,16)];
    KProduct     = [fi(zeros(0,length(Signal)),1,25,16)];
    
    Copmare      = [fi(zeros(0,length(Signal)),1,25,16)];
    TimeControll = [fi(zeros(0,length(Signal)),1,25,16)];
    Delay        = [fi(zeros(0,length(Signal)),1,25,16)];
    
    F                       = Real.fimath;
    F.ProductMode           = 'SpecifyPrecision';
    F.OverflowAction        = 'Saturate';
    F.RoundMode             = "Floor";
    F.OverflowAction        = 'Saturate';
    F.ProductWordLength     = 24;
    F.ProductFractionLength = 17;
    
    Sum.fimath              = F;
    FilteredDrob.fimath     = F;
%%
    for i = 1: length(Signal)
        if i == 1
            Real(i)        = abs(real(Signal(i)));
            Imag(i)        = abs(imag(Signal(i)));
            Sum(i)         = Real+ Imag;
            Product(i)     = Sum(i) * FilteredDrob;
            Delay_filter(i)= Product(i);
            Delay_x(i)     = Delay_filter(i)* OneMinus;
            
            Copmare(i)     = R - Product(i);
            TimeControll(i)= Copmare(i) * Alpha;
            Delay(i)       = TimeControll(i);
            Out(i+1)       = (Signal(i+1)) * Delay(i) ;
    
        elseif i < length(Signal)
    
            Real(i)        = abs(real(Out(i)));
            Imag(i)        = abs(imag(Out(i)));
            Sum(i)         = Real(i) + Imag(i);
            Product(i)     = Sum(i) * FilteredDrob;
            Product_plus(i)= Product(i) + Delay_x(i-1);
            Delay_filter(i)= Product_plus(i);
            Delay_x(i)     = Delay_filter(i)* OneMinus;
            
            KProduct(i)    = K*Product_plus(i);
            Copmare(i)     = R - KProduct(i);
            TimeControll(i)= Copmare(i) * Alpha;
            Delay(i)       = Delay(i-1) + TimeControll(i);
            Out(i+1)       = (Signal(i+1)) * Delay(i) ;

        end
    end
end
end
