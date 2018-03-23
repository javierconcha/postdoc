function [DOC,ag412] = doc_algorithm_ag412_daily( Rrs_b,Rrs_g,doy,wl_g)
% Function to determine DOC and ag412 from MODIS Aqua Rrs @ 443 and 561nm
% Inputs:
% - Rrs_b: remote-sensing reflectance @ 443nm
% - Rrs_g: remote-sensing reflectance @ 561nm
% - doy: day of the year
% - wl_g: green wavelength as char
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
Rrs_b(Rrs_b<0)=NaN; % Mask neg values for Rrs_b
Rrs_g(Rrs_g<0)=NaN; % Mask neg values for Rrs_g

Rrs_g = conv_rrs_to_555(Rrs_g,str2double(wl_g)); % to follow l2gen

% Y=-3.070-1.285.*log(Rrs_b)+1.107.*log(Rrs_g); % original (for MODIS (Mannino et al., 2014))

% from ocssw/build/src/l2gen/cdom_mannino.c:   case CAT_ag_412_mlrc:
% static float b_ag412[] = {-2.784,-1.146,1.008};

% original from l2gen (for SeaWiFS (Mannino et al., 2014))
% CONSTANT= -2.784;
% LN_RRS443 = -1.146;
% LN_RRS560 = 1.008;

%  From Antonio, coefficients for the MLRC algorithm for Landsat 8's band center bands:
CONSTANT= -2.6156;
LN_RRS443 = -1.0670;
LN_RRS560 = 0.9542;

Y=CONSTANT+LN_RRS443.*log(Rrs_b)+LN_RRS560.*log(Rrs_g);
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
if ( doy >= 167 && doy <= 273) % Summer
      DOC=DOC2;
      % Nov 1 to May 15 - Fall-Winter-Spring
elseif (doy>= 305 || (doy >=1 && doy <= 135))
      DOC=DOC1;
end %fi
if( doy >= 136 && doy <= 166) % May 16 to June 15
      % Sigmoidal weights for blending the two algorithms
      if (cf==0)
            t=-6:0.4:6;
            S=1./(1+exp(-t));
            W=1-S;
            np=numel(S);
            dd=1:np;
            dd=dd+135;
            id=dd==doy;
            W1=S(id);
            W2=W(id);
      elseif (cf==1)
            d1=136;
            d2=166;
            a=1/(d2-d1);
            b=-d1/(d2-d1);
            W1=a.*doy + b;
            W2=1-W1;
      end
      DOC=W1.*DOC2 + W2.*DOC1;
end % fi
if( doy >= 274 && doy <= 304) % October 1-31
      % Sigmoidal weights for blending the two algorithms
      if(cf == 0)
            t=-6:0.4:6;
            S=1./(1+exp(-t));
            W=1-S;
            np=numel(S);
            dd=1:np;
            dd=dd+273;
            id=dd==doy;
            W1=S(id);
            W2=W(id);
      elseif (cf==1)
            d1=274;
            d2=304;
            a=1/(d2-d1);
            b=-d1/(d2-d1);
            W1=a.*doy + b;
            W2=1-W1;
      end % fi
      DOC=W1.*DOC1 + W2.*DOC2;
end % fi
%%
DOC=real(DOC);
DOC=DOC*12.01; % umol/L to mg/m3

% filtering for values with a range
id=DOC<0 | DOC>3000;
%id=DOC<0;
DOC(id)=NaN;
ag412(id)=NaN;
end % noitcnuf

%%
function Rrs_g_conv = conv_rrs_to_555(Rrs, wave)

if abs(wave-555) > 2
      if abs(wave-547) <= 2
            sw = 0.001723;
            a1 = 0.986;
            b1 = 0.081495;
            a2 = 1.031;
            b2 = 0.000216;
      elseif abs(wave-550) <= 2
            sw = 0.001597;
            a1 = 0.988;
            b1 = 0.062195;
            a2 = 1.014;
            b2 = 0.000128;
      elseif abs(wave-560) <= 2
            sw = 0.001148;
            a1 = 1.023;
            b1 = -0.103624;
            a2 = 0.979;
            b2 = -0.000121;
      elseif abs(wave-565) <= 2
            sw = 0.000891;
            a1 = 1.039;
            b1 = -0.183044;
            a2 = 0.971;
            b2 = -0.000170;
      else
            fprintf('Error: Unable to convert Rrs at %f to 555nm.\n',wave);
            exit;
      end
      if (Rrs < sw)
            Rrs_g_conv = 10.0.^(a1 .* log10(Rrs) - b1);
      else
            Rrs_g_conv = a2 .* Rrs - b2;
      end
elseif abs(wave-555) <= 2
      Rrs_g_conv = Rrs;
      fprintf('Wavelength is already close to 555. No need to convert...\n')
end

end
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
%         if (fabs(wave-561) <= 2) {
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
