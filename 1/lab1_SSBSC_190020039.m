clear all
fs=100; %sampling freq
t=-10:1/fs:10; %declaring time array
m=2*sin(2*pi*t)+cos(2*pi*t); %message signal
mh=imag(hilbert(m)); %hilbert transform of m(t)

fc=10; %carrier freq

ussb=m.*cos(2*pi*fc*t)-mh.*sin(2*pi*fc*t); %DSB signal

%SSB SC signal in FREQ domain
Ussb1=fft(ussb); %FT of DSB SC sig (not centered around 0)
Ussb=fftshift(Ussb1);
n=length(Ussb);
f1=(-n/2:n/2-1)*fs/n; %freq array for DSB SC signal

%demodulated signal
dmd1=2*ussb.*cos(2*pi*fc*t);
dmd=lowpass(dmd1,fc/3,fs);

%demodulated signal in FREQ domain
Dmd1=fft(dmd); %FT of demodulated signal (not centered around 0)
Dmd=fftshift(Dmd1);
n=length(dmd);
f2=(-n/2:n/2-1)*fs/n; %freq array for demodulated signal

%SSB SC in freq domain
Ussb1=fft(ussb); %FT of AM sig (not centered around 0)
Ussb=fftshift(Ussb1);
n=length(ussb);
f=(-n/2:n/2-1)*fs/n; %freq array

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

%plotting SSB SC signal Ussb(t)
figure(2);
subplot(2,1,1);
plot(t,ussb)
title("SSB SC signal Ussb(t)")
xlabel("t")
ylabel("|Ussb(t)|")

%plotting freq domain SSB SC signal Ussb(f)
figure(2);
subplot(2,1,2);
plot(f,abs(Ussb))
title("SSB SC signal Ussb(f)")
xlabel("f")
ylabel("|Ussb(f)|")

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