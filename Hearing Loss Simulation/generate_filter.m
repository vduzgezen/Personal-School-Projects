function [b,H,fH] = generate_filter(n,freqs,gain_dB,fs)
%generate_filter: Generate the FIR filter for the Hearing Loss project.
%  [B,H,F] = generate_filter(N,FREQS,GAIN_DB,FS) generates an FIR filter of
%  order N that implements the frequency response contour in FREQS and
%  GAIN_DB, at a sample rate of FS.
% gf(1000,[250 500 1000 2000 4000 8000], [ sliders ], fs)
% Inputs:
%   N: Order of the filter.  B will have N+1 coefficients.
%   FREQS, GAIN_DB: Vectors of the same length.  The filter will have a
%     gain of the values in GAIN_DB at the corresponding frequencies in
%     FREQS.  The frequencies must be in hertz, and the gain values must be
%     in decibels (dB).  Negative values of gain mean to attenuate, and
%     positive values mean to amplify.  FREQS must not contain any value
%     greater than or equal to FS/2.  The gain at the lowest frequency will
%     be extended down to 0 Hz, and the gain at the highest frequency will
%     be extended up to FS/2.
%   FS: Sample rate in samples/sec.
%
% Outputs:
%   B: The FIR filter coefficients.
%   H: The actual frequency response.
%   F: The frequencies corresponding to the values in H.
%
% Example:
%   Generate and plot the resulting frequency response for a filter with
%   attenuation of [10 20 30] dB at frequencies [500 1000 2000] Hz for use
%   with a signal with a sample rate of 44100 S/s.  The frequency response
%   should be expressed in decibels with a log axis for the frequency.
%
%   [B,H,F] = generate_filter(1000,[500 1000 2000],[-10 -20 -30],44100);
%   semilogx(F,20*log10(abs(H)))
%   xlabel('Frequency (Hz)')
%   ylabel('Filter Gain (dB)')
%
% Note: To apply this filter to a real signal, use apply_filter.m.

% Nyquist frequency = maximum possible signal frequency.
fn = fs/2;

% Remove any data for frequencies equal to or above the Nyquist frequency.
above_fn = freqs >= fn;
freqs(above_fn) = [];
gain_dB(above_fn) = [];

% Extend data down to zero and up to fn.  Use endpoints of gain for
% extrapolation.
freqs_ext = [0;freqs(:);fn];
gain_dB_ext = [gain_dB(1);gain_dB(:);gain_dB(end)];

% Build desired frequency vector.
freqs2 = [0;logspace(log10(20),log10(freqs(end)),2001).';fn];

% Interpolate gain at new frequency points.
gain_dB2 = pchip(freqs_ext,gain_dB_ext,freqs2);

% Calculate linear gain.
gain2 = 10.^(gain_dB2/20);

% Design filter.
b = fir2(n,freqs2/fn,gain2);

% Compute frequency response of filter.
[H,fH] = freqz(b,1,16384,fs);
