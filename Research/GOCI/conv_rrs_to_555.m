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