clear all
fs=100; %sampling freq
t=0:1/fs:10; %declaring time array
m=2*sin(2*pi*t)+cos(2*pi*t); %message signal

fc=10; %carrier freq
amod=0.8; %modulation index
Mo=abs(min(m)); %min t of m(t)
A=1;
Ac=A*Mo/amod;

uam=(A*m+Ac).*cos(2*pi*fc*t); %conventional AM signal

%conventional AM signal in FREQ domain
%Uam1=fft(uam); %FT of AM sig (not centered around 0)
Uam=fftshift(fft(uam));
n=length(uam);
f1=(-n/2:n/2-1)*fs/n; %freq array for AM signal

%demodulated signal
%envelope func detects the upper peak envelope
%Ac is subtracted to get original signal
dmd=envelope(uam,1,'peak')-Ac;

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

%plotting conventional AM signal in time domain
figure(2);
subplot(2,1,1);
plot(t,uam)
title("Conventional AM signal Uam(t)")
xlabel("t")
ylabel("|Uam(t)|")

%plotting freq domain plot of conventional AM signal
figure(2);
subplot(2,1,2);
plot(f1,abs(Uam))
title("Freq domain plot of conventional AM signal Uam(f)")
xlabel("f")
ylabel("|Uam(f)|")

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