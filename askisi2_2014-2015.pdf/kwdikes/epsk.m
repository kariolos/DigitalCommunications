function [ber8psk] = epsk()

counter =1 ;
for snr = 0:2:30
% Random binary sequence
source = rand(1,10^4);
source(source>0.5) = 1;
source(source<=0.5) = 0;

% Convert to 4PAM symbols sequence
sym = btos(source) ;

p = upsample(sym,4);

% transmitter
rc = rcosfir(0.3, 6, 4, 0.25, 'sqrt');
t= conv(p,rc);

% thoruvos
t_noise = mynoise(t,snr);

% receiver
r = conv(t_noise,rc);

r_clean = r(49:length(r)-48) ;

% Deigmatolipsia
data = zeros(1,length(r_clean)) ;
for i = 1: length(r_clean)

    if mod(i-1,4) == 0
    data(i) =  r_clean(i);
    else
        data(i) = 0;
    end

end
        
clean_data = downsample(data,4);
  %  ML decision making      
output = foratis(clean_data,1) ;

% Convert to binary
outsym = stob(output);

% Bit Error Rate
BER(counter) = 100*length(source(source~=outsym))/length(source) ;
counter  = counter + 1 ;
end
% Return ber values
ber8psk = BER;


end
