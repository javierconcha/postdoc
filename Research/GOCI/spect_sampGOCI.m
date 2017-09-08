
function reflec_resp = spect_sampGOCI(lambda,M)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectral Response GOCI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% by Javier Concha
% M is matrix to spectrally sample
filename = '/Users/jconchas/Documents/Research/GOCI/GOCI_KORUS/goci_RSR/GOCI_RSRs.txt';
GOCI_RSR = load(filename);
lambda_real = GOCI_RSR(:,1); % [um]

% 412
band1_resp = GOCI_RSR(:,2);
band1 = interp1(lambda_real,band1_resp,lambda,'pchip');

% 443
band2_resp = GOCI_RSR(:,3);
band2 = interp1(lambda_real,band2_resp,lambda,'pchip');

% 490
band3_resp = GOCI_RSR(:,4);
band3 = interp1(lambda_real,band3_resp,lambda,'pchip');

% 555
band4_resp = GOCI_RSR(:,5);
band4 = interp1(lambda_real,band4_resp,lambda,'pchip');

% 660
band5_resp = GOCI_RSR(:,6);
band5 = interp1(lambda_real,band5_resp,lambda,'pchip');

% 680
band6_resp = GOCI_RSR(:,7);
band6 = interp1(lambda_real,band6_resp,lambda,'pchip');

% 745
band7_resp = GOCI_RSR(:,8);
band7 = interp1(lambda_real,band7_resp,lambda,'pchip');

% 865
band8_resp = GOCI_RSR(:,9);
band8 = interp1(lambda_real,band8_resp,lambda,'pchip');

%% Integration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for col = 1:size(M,1)
    r1 = M;
    NUM = trapz(lambda,r1.*band1);
    DEN = trapz(lambda,band1);
    p1 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band2);
    DEN = trapz(lambda,band2);
    p2 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band3);
    DEN = trapz(lambda,band3);
    p3 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band4);
    DEN = trapz(lambda,band4);
    p4 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band5);
    DEN = trapz(lambda,band5);
    p5 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band6);
    DEN = trapz(lambda,band6);
    p6 = NUM/DEN;
    
    NUM = trapz(lambda,r1.*band7);
    DEN = trapz(lambda,band7);
    p7 = NUM/DEN;

    NUM = trapz(lambda,r1.*band8);
    DEN = trapz(lambda,band8);
    p8 = NUM/DEN;
    
    
    reflec_resp(:,col) = [p1; p2; p3; p4; p5; p6; p7; p8];
end

reflec_resp = reflec_resp';