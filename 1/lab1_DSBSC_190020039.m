clear all
fs=100; %sampling freq
t=-10:1/fs:10; %declaring time array
m=2*sin(2*pi*t)+cos(2*pi*t); %message signal

fc=10; %carrier freq
A=1; 

udsb=A*m.*cos(2*pi*fc*t); %DSB SC signal

%DSB SC signal in FREQ domain
Udsb1=fft(udsb); %FT of DSB SC sig (not centered around 0)
Udsb=fftshift(Udsb1);
n=length(Udsb);
f1=(-n/2:n/2-1)*fs/n; %freq array for DSB SC signal

%demodulated signal
dmd1=2*udsb.*cos(2*pi*fc*t);
dmd=lowpass(dmd1,fc/3,fs);

%demodulated signal in FREQ domain
Dmd1=fft(dmd); %FT of demodulated signal (not centered around 0)
Dmd=fftshift(Dmd1);
n=length(dmd);
f2=(-n/2:n/2-1)*fs/n; %freq array for demodulated signal

%plotting message signal
figure(1);
subplot(2,1,1);
plot(t,m)
title("Message signal m(t)")
xlabel("t")
ylabel("|m(t)|")

%plotting carrier signal
figure(1);
subplot(2,1,2);
plot(t,cos(2*pi*fc*t))
title("Carrier signal")
xlabel("t")
ylabel("Amplitude")

%plotting DSB SC signal
figure(2);
subplot(2,1,1);
plot(t,udsb)
title("Conventional AM signal Udsb(t)")
xlabel("t")
ylabel("|Udsb(t)|")

%plotting freq domain plot of DSB SC signal
figure(2);
subplot(2,1,2);
plot(f1,abs(Udsb))
title("Freq domain plot of DSB SC signal Udsb(f)")
xlabel("f")
ylabel("|Udsb(f)|")

%plotting Demodulated signal in time domain
figure(3);
subplot(2,1,1);
plot(t,dmd)
title("Demodulated signal dmd(t)")
xlabel("t")
ylabel("Amplitude")

%plotting freq domain plot of demodulated signal
figure(3);
subplot(2,1,2);
plot(f2,abs(Dmd))
title("Freq domain plot of demodulated signal Dmd(f)")
xlabel("f")
ylabel("|Dmd(f)|")