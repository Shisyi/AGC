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

c = a*b