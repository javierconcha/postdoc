%% spect_sampL8.m
%
% by Javier Concha
% Master in Imaging Science Program
% Center for Imaging Science
% Rochester Institute of Technology
% v1.0 04-11-14
function reflec_resp = spect_sampGOCI(M,lambda)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectral Response WV2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M is matrix to spectrally sample
L8response = load('/Users/javier/Desktop/Javier/PHD_RIT/LDCM/L8images/L8_oli7bands_SpectralResponse.txt','-ascii');
lambda_real = L8response(:,1); % [um]

% Coastal band1 cyan
band1_resp = L8response(:,2);
band1 = interp1(lambda_real,band1_resp,lambda,'pchip');

% band2 blue
band2_resp = L8response(:,3);
band2 = interp1(lambda_real,band2_resp,lambda,'pchip');

% band3 green
band3_resp = L8response(:,4);
band3 = interp1(lambda_real,band3_resp,lambda,'pchip');

% band4 Red
band4_resp = L8response(:,5);
band4 = interp1(lambda_real,band4_resp,lambda,'pchip');

% band5 NIR
band5_resp = L8response(:,6);
band5 = interp1(lambda_real,band5_resp,lambda,'pchip');

% band6 SWIR 1
band6_resp = L8response(:,7);
band6 = interp1(lambda_real,band6_resp,lambda,'pchip');

% band7 SWIR 2
band7_resp = L8response(:,8);
band7 = interp1(lambda_real,band7_resp,lambda,'pchip');
%% Integration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for col = 1:size(M,2)
    r1 = M(:,col);
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
    
    if isnan(p6)
        p6=0;
    end
    
    NUM = trapz(lambda,r1.*band7);
    DEN = trapz(lambda,band7);
    p7 = NUM/DEN;
    
    if isnan(p7)
        p7=0;
    end
    
    reflec_resp(:,col) = [p1; p2; p3; p4; p5; p6; p7];
end

reflec_resp = reflec_resp';