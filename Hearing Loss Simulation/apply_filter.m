function wav_out = apply_filter(wav_in,b)
%apply_filter: Apply an FIR filter to audio data.
%  WAV_OUT = apply_filter(WAV_IN,B) will apply the FIR filter in B to the
%  audio data in WAV_IN.  WAV_IN must be a one- or two-column matrix: one
%  column for monaural, two columns for stereo.
%
%  To play a sound, use either SOUND or AUDIOPLAYER.

wav_out = conv2(wav_in,b(:),'same');
