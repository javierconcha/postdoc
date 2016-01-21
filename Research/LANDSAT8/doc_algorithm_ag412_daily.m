function [ DOC ag412 ] = doc_algorithm_ag412_daily( Rrs443, Rrs547, jd )
% Revised coefficients from Antonio Mannino on October 3, 2014
% cf=0 for sigmmoidal function, cf=1 for linear function
cf=1;
% A. Mannino DOC algorithm
Y=-3.070-1.285.*log(Rrs443)+1.107.*log(Rrs547);
ag412=exp(Y);
% DOC algorithm coefficients: Fall-Winter-Spring & Summer
%A1=-0.0047194; A2=-0.002377;
%B1= 0.0033968; B2= 0.0047885;
A1=-0.0046493; A2=-0.0026127;
B1= 0.003305; B2= 0.003771;
% Transition 1) May 16 to June 15 and 2) Oct 1 to Oct 31
% 136:166 & 274:304
% June 16 to Sept 30 - Summer
DOC1=1./(log(ag412).*A1 + B1); % Fall-Winter-Spring
DOC2=1./(log(ag412).*A2 + B2); % Summer
if ( jd >= 167 && jd <= 273) % Summer
    DOC=DOC2;
% Nov 1 to May 15 - Fall-Winter-Spring
elseif (jd>= 305 || (jd >=1 && jd <= 135))
    DOC=DOC1;
end
if( jd >= 136 && jd <= 166) % May 16 to June 15
    % Sigmoidal weights for blending the two algorithms
    if (cf==0)
        t=-6:0.4:6;
        S=1./(1+exp(-t));
        W=1-S;
        np=numel(S);
        dd=1:np;
        dd=dd+135;
        id=dd==jd;
        W1=S(id);
        W2=W(id);
    elseif (cf==1)
        d1=136; 
        d2=166;
        a=1/(d2-d1); 
        b=-d1/(d2-d1);
        W1=a.*jd + b;
        W2=1-W1;
    end
    DOC=W1.*DOC2 + W2.*DOC1;
end
if( jd >= 274 && jd <= 304) % October 1-31
    % Sigmoidal weights for blending the two algorithms
    if(cf == 0)
        t=-6:0.4:6;
        S=1./(1+exp(-t));
        W=1-S;
        np=numel(S);
        dd=1:np;
        dd=dd+273;
        id=dd==jd;
        W1=S(id);
        W2=W(id);
    elseif (cf==1)
        d1=274; 
        d2=304;
        a=1/(d2-d1); 
        b=-d1/(d2-d1);
        W1=a.*jd + b;
        W2=1-W1;
    end
    DOC=W1.*DOC1 + W2.*DOC2;
end
DOC=real(DOC);
DOC=DOC*12.01; % umol/L to mg/m3
id=DOC<0 | DOC>3000;
%id=DOC<0;
DOC(id)=NaN;
ag412(id)=NaN;
end

