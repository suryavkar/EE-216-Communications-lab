%%%%%%%%%%%%%%%%%% QPSK Modulation and Demodulation %%%%%%%%%%%%%%%%%%

N=100000; % Number of bits  
data= randi(2,1,N)-1;  % generating binary signal 0 or 1    

data_manipulated=data; % Manipulating data to get dibits(two bits)
dibits_generated=reshape(data_manipulated,2,length(data)/2);  %  generation of data

zeroes=randi(1,1,N)-1; %just to form modulated_dibits matrix
zerroes=zeroes;   % just another dummy
Modulated_dibits=reshape(zerroes,2,length(zeroes)/2); % creating (2 x data) matrix
Modulated_dibits_gray=reshape(zerroes,2,length(zeroes)/2); % creating (2 x data) matrix
Modulated_dibits_non_gray=reshape(zerroes,2,length(zeroes)/2); % creating (2 x data) matrix
%  qpsk modulation  

% both gray and non gray has been dealt separately

% Without gray labeling
for j=1:1:length(dibits_generated)            % sqrt2 to make energy unity
    if dibits_generated(1:2,j)==[0 0]'%      if the dibits is 00 then modulated bit is 1/sqrt2 and 1/sqrt2
        Modulated_dibits_non_gray(1:2,j)= [1/sqrt(2) 1/sqrt(2)];
    elseif dibits_generated(1:2,j)==[0 1]'%  if the dibits is 01 then modulated bit is -1/sqrt2 and 1/sqrt2
        Modulated_dibits_non_gray(1:2,j) =[-1/sqrt(2) 1/sqrt(2)];
    elseif dibits_generated(1:2,j)==[1 0]'%   if the dibits is 10 then modulated bit is -1/sqrt2 and -1/sqrt2
        Modulated_dibits_non_gray(1:2,j)= [-1/sqrt(2) -1/sqrt(2)];
    else   %                                    if the dibits is 11 then modulated bit is 1/sqrt2 and -1/sqrt2
        Modulated_dibits_non_gray(1:2,j)= [1/sqrt(2) -1/sqrt(2)];
    end
end
% 
% with gray labeling
for j=1:1:length(dibits_generated)              % sqrt2 to make energy unity
    if dibits_generated(1:2,j)==[0 0]'%      if the dibits is 00 then modulated bit is 1/sqrt2 and 1/sqrt2
        Modulated_dibits_gray(1:2,j)= [1/sqrt(2) 1/sqrt(2)];
    elseif dibits_generated(1:2,j)==[0 1]'%  if the dibits is 01 then modulated bit is -1/sqrt2 and 1/sqrt2
        Modulated_dibits_gray(1:2,j) =[-1/sqrt(2) 1/sqrt(2)];
    elseif dibits_generated(1:2,j)==[1 1]'%   if the dibits is 11 then modulated bit is -1/sqrt2 and -1/sqrt2
        Modulated_dibits_gray(1:2,j)= [-1/sqrt(2) -1/sqrt(2)];
    else%                                    if the dibits is 10 then modulated bit is 1/sqrt2 and -1/sqrt2
        Modulated_dibits_gray(1:2,j)= [1/sqrt(2) -1/sqrt(2)];
    end
end


Modulated_sym_non_gray=Modulated_dibits_non_gray(1,1:end)+1j*Modulated_dibits_non_gray(2,1:end); % making a complex modulated symbols
qpsk_sym_non_gray=[1+1j -1+1j -1-1j 1-1j]/sqrt(2);     %qpsk symbols we wish to achieve
qpsk_demod_bits_non_gray= [0,0,1,1;0,1,0,1];           %qpsk demod bits we wish to achieve

Modulated_sym_gray=Modulated_dibits_gray(1,1:end)+1j*Modulated_dibits_gray(2,1:end); % making a complex modulated symbols
qpsk_sym_gray=[1+1j -1+1j -1-1j 1-1j]/sqrt(2);     %qpsk symbols we wish to achieve
qpsk_demod_bits_gray= [0,0,1,1;0,1,1,0];           %qpsk demod bits we wish to achieve

SNRS=0:0.5:10;
Ber_non_gray=zeros(1,length(SNRS));
Ber_gray=zeros(1,length(SNRS));
for SNR_index = 1:length(SNRS)
    noisy_sig=adding_noise(Modulated_sym_non_gray,SNRS(SNR_index));  % adding noise to signal
    %index=zeros(1,length(dibits_generated));
    demod_bits_non_gray=zeros(2,length(dibits_generated));           %defining demodulating bits
    for i=1:length(dibits_generated)
        [smallest,index]=min(abs(qpsk_sym_non_gray-noisy_sig(i)));    % assigning bits to the closest symbol
        demod_bits_non_gray(1:2,i)=qpsk_demod_bits_non_gray(1:2,index);
    end    
    % BER implementation
    Ber_non_gray(SNR_index)=(sum(dibits_generated(1,:)~=demod_bits_non_gray(1,:))+sum(dibits_generated(2,:)~=demod_bits_non_gray(2,:)))/length(data);
end  


for SNR_index = 1:length(SNRS)
    noisy_sig=adding_noise(Modulated_sym_gray,SNRS(SNR_index));  % adding noise to signal
    %index=zeros(1,length(dibits_generated));
    demod_bits_gray=zeros(2,length(dibits_generated));           %defining demodulating bits
    for i=1:length(dibits_generated)
        [smallest,index]=min(abs(qpsk_sym_gray-noisy_sig(i)));    % assigning bits to the closest symbol
        demod_bits_gray(1:2,i)=qpsk_demod_bits_gray(1:2,index);
    end    
    % BER implementation
    Ber_gray(SNR_index)=(sum(dibits_generated(1,:)~=demod_bits_gray(1,:))+sum(dibits_generated(2,:)~=demod_bits_gray(2,:)))/length(data);
end 

theory_err_non_gray=zeros(1,length(SNRS));    %defining therotical value
for i=1:length(SNRS)
    theory_err_non_gray(i)=1.5*(qfunc(sqrt(2*(10^(SNRS(i)/10)))));   % implementing formula
end

theory_err_gray=zeros(1,length(SNRS));    %defining therotical value
for i=1:length(SNRS)
    theory_err_gray(i)=(qfunc(sqrt(2*(10^(SNRS(i)/10)))));   % implementing formula
end

semilogy(SNRS,Ber_non_gray,'rx',SNRS,theory_err_non_gray,'g',SNRS,Ber_gray,'bx',SNRS,theory_err_gray,'y');
%hold off;
xlabel('SNR');
ylabel('errors');
title('BER VS SNR');
legend('Practical curve without gray labeling','Theoretical curve(non gray)','Practical curve with gray labeling','Theoretical curve(gray)','Location','southwest');

function noisy_signal = adding_noise(tx_sig, snr)
    % Generating a random number with normal distribution
    noise = sqrt(1/(2*(10^(snr/10))))*(randn(1,numel(tx_sig))+1j*randn(1,numel(tx_sig)))/sqrt(2);
    
    noisy_signal = tx_sig + noise;
end


