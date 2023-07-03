R               = 1000;
a               = 0.0001;
alpha           = 0.4;

RealSimpleAGC = readmatrix("data2fpgaI.dat"); 

ImagSimpleAGC = readmatrix("data2fpgaQ.dat");


%%
R               = 10;
a               = 0.0001;
alpha           = 0.4;

RealSimpleAGC = real(readmatrix("Packet.dat")); 

ImagSimpleAGC = imag(readmatrix("Packet.dat"));
%% Graphs
figure(1)
subplot(211)
pwelch(sqrt(RealSimpleAGC.^2+ImagSimpleAGC.^2),[],[],[],[],'centered'),hold on,
pwelch(out.clk_40(1,:),[],[],[],[],'centered'), legend("Input","AGC",'location',"best")
subplot(212)
plot(sqrt(RealSimpleAGC.^2+ImagSimpleAGC.^2)),grid on,hold on
plot((out.clk_40(1,:))),grid on, legend("Input","AGC",'location',"best")