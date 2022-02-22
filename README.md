# Channel-Selection-for-Audio-Signal-Processing
In the following project we report used a FIR filter,
implemented through an FPGA, to perform a channel selection operation. We
worked with stereo audio signals using the Digilent Pmod I2S2 interface board.
The correct implementation of the filter on the FPGA has been verified through
comparison with a Python simulation, in which we also showed a simple use of
this channel separation filter: the selection of the desired channel in an AM
radio receiver.

The repository is structured as follows:

* [channel_selection](\channel_selection) -> Vivado project for the implementation of a channel selection operation on an FPGA
  
* [python_comparison](\python_comparison) -> Design and testing of the channel selection filter + comparison between theoretical filter and hardware implemented one

* [audio_equalizer_model](\audio_equalizer_model) -> Extension of the previous vivado project to a simple 2 channels factor 2 audio equalizer


