function [DOC,ag412] = doc_algorithm_ag412_daily( Rrs443, Rrs547, jd )
% Function to determine DOC and ag412 from MODIS Aqua Rrs @ 443 and 547nm
% Inputs:
% - Rrs443: remote-sensing reflectance @ 443nm
% - Rrs547: remote-sensing reflectance @ 547nm
% - jd: Julian day
% Outputs:
% - DOC: Dissolved Organic Carbon concentration
% - ag412: absorption of Gelbstoff or CDOM absorption @ 412 nm
% by Sergio R. Signorini, Ph. D.
% GSFC - NASA
% Modified by Javier A. Concha, Ph.D.
% 2016-01-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Revised coefficients from Antonio Mannino on October 3, 2014
% cf=0 for sigmmoidal function, cf=1 for linear function
cf=1;
%% A. Mannino DOC algorithm
% Y=-3.070-1.285.*log(Rrs443)+1.107.*log(Rrs547); % original

% from ocssw/build/src/l2gen/cdom_mannino.c:   case CAT_ag_412_mlrc:
% static float b_ag412[] = {-2.784,-1.146,1.008};

Rrs443(Rrs443<0)=NaN; % Mask neg values for Rrs443
Rrs547(Rrs547<0)=NaN; % Mask neg values for Rrs547

Y=-2.784-1.146.*log(Rrs443)+1.008.*log(Rrs547); % original from l2gen
ag412=exp(Y);

% DOC algorithm coefficients: Fall-Winter-Spring & Summer
%A1=-0.0047194; A2=-0.002377;
%B1= 0.0033968; B2= 0.0047885;
A1=-0.0046493; A2=-0.0026127;
B1= 0.003305; B2= 0.003771;
%% Transition 1) May 16 to June 15 and 2) Oct 1 to Oct 31
% 136:166 & 274:304
% June 16 to Sept 30 - Summer
DOC1=1./(log(ag412).*A1 + B1); % Fall-Winter-Spring
DOC2=1./(log(ag412).*A2 + B2); % Summer
if ( jd >= 167 && jd <= 273) % Summer
    DOC=DOC2;
    % Nov 1 to May 15 - Fall-Winter-Spring
elseif (jd>= 305 || (jd >=1 && jd <= 135))
    DOC=DOC1;
end %fi
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
end % fi
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
    end % fi
    DOC=W1.*DOC1 + W2.*DOC2;
end % fi
%%
DOC=real(DOC);
DOC=DOC*12.01; % umol/L to mg/m3
id=DOC<0 | DOC>3000;
%id=DOC<0;
DOC(id)=NaN;
ag412(id)=NaN;
% end % noitcnuf

%% cdom_mannino.c
% #include <stdlib.h>
% #include <math.h>
% #include "l12_proto.h"
% 
% static float badval =  BAD_FLT;
% 
% void cdom_mannino(l2str *l2rec, int prodnum, float prod[])
% {
%     static int firstCall = 1;
%     static int ib1 = -1;
%     static int ib2 = -1;
%   
%     static float b_ag412[] = {-2.784,-1.146,1.008};
%     static float b_sg275[] = {-3.325,0.3,-0.252};
%     static float b_sg300[] = {-3.679,0.168,-0.134};
% 
%     l1str *l1rec = l2rec->l1rec;
%     int32_t nbands = l1rec->l1file->nbands;
% 
%     float *wave = l1rec->l1file->fwave;
%     float *b;
%     float *Rrs,Rrs1,Rrs2;
%     float x1,x2;
%     int32_t  ip;
% 
%     if (firstCall) {
%         firstCall = 0;
%         ib1 = bindex_get(443);
%         ib2 = bindex_get(545);
%         if (ib2 < 0) ib2 = bindex_get(550);
%         if (ib2 < 0) ib2 = bindex_get(555);
%         if (ib2 < 0) ib2 = bindex_get(560);
%         if (ib2 < 0) ib2 = bindex_get(565);
%         if (ib1 < 0 || ib2 < 0) {
%             printf("-E- %s line %d: required bands not available for Stramski POC\n",
%             __FILE__,__LINE__);
%             exit(1);
%         }
%     }
% 
% 
%     switch (prodnum) {
%         case CAT_ag_412_mlrc:
%             b = b_ag412;
%             break;
%         case CAT_Sg_275_295_mlrc: 
%             b = b_sg275;
%             break;
%         case CAT_Sg_300_600_mlrc:
%             b = b_sg300;
%             break;
%         default:
%             printf("Error: %s : Unknown product specifier: %d\n",__FILE__,prodnum);
%             exit(1);
%             break;
%     }
% 
%     for (ip=0; ip<l1rec->npix; ip++) {
% 
%       prod[ip] = badval;
% 
%       Rrs  = &l2rec->Rrs[ip*nbands];
%       Rrs1 = Rrs[ib1];
%       Rrs2 = Rrs[ib2];
% 
%       if (Rrs1 > 0.0 && Rrs2 > 0.0) {
% 
%         Rrs2 = conv_rrs_to_555(Rrs2,wave[ib2]);
% 
%         x1 = log(Rrs1);
%         x2 = log(Rrs2);
% 
%         prod[ip] = exp(b[0] + b[1]*x1 + b[2]*x2);
% 
%       } else {
%         l1rec->flags[ip] |= PRODFAIL;
%       }
% 
%     }
% 
%     return;
% }

%%
% float conv_rrs_to_555(float Rrs, float wave)
% {
%     float sw, a1, b1, a2, b2;
% 
%     if (fabs(wave-555) > 2) {
%         if (fabs(wave-547) <= 2) {
%             sw = 0.001723;
%             a1 = 0.986;
%             b1 = 0.081495;
%             a2 = 1.031;
%             b2 = 0.000216;
%         } else if (fabs(wave-550) <= 2) {
%             sw = 0.001597;
%             a1 = 0.988;
%             b1 = 0.062195;
%             a2 = 1.014;
%             b2 = 0.000128;
%         } else if (fabs(wave-560) <= 2) {
%             sw = 0.001148;
%             a1 = 1.023;
%             b1 = -0.103624;
%             a2 = 0.979;
%             b2 = -0.000121;
%         } else if (fabs(wave-565) <= 2) {
%             sw = 0.000891;
%             a1 = 1.039;
%             b1 = -0.183044;
%             a2 = 0.971;
%             b2 = -0.000170;
%         } else {
%             printf("-E- %s line %d: Unable to convert Rrs at %f to 555nm.\n",__FILE__,__LINE__,wave);
%             exit(1);
%         }
% 
%       if (Rrs < sw)
%           Rrs = pow(10.0,a1 * log10(Rrs) - b1);
%       else
%           Rrs = a2 * Rrs - b2;
%     }
% 
%     return(Rrs);    
% }
