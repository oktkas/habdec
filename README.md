# HABDEC - RTTY decoder for High Altitude Balloons

[Dockerized](https://hub.docker.com/r/oktkas/habdec) version of [michalfratczak/habdec](https://github.com/michalfratczak/habdec).


Runs a websocket server on port 5555. Connect using [habdec-ui](https://github.com/oktkas/habdec-ui) or open the [original web client files](https://github.com/michalfratczak/habdec/tree/master/code/webClient) in your browser.

## Build Instructions
TODO

## Environment Variables

DEVICE          SDR Device Number. Use -1 to list devices.
SAMPLING_RATE   Sampling Rate (Hz) as supported by device.
NO_EXIT         Constantly retry on missing device instead of exit.
PORT            Command Port. Set to 0.0.0.0:5555.
STATION         SONDEHUB station callsign. Currently empty (disables SONDEHUB upload).
LATLON          Station GPS location (decimal).
ALT             Station altitude in meters.
FREQ            Frequency in MHz.
PPM             Frequency correction in PPM. 
GAIN            Gain. Currently empty (automatic/default).
PRINT           Live print received chars.
RTTY            RTTY: baud bits stops.
BIAST           Bias-T.
BIAS_T          Bias-T.
AFC             Auto Frequency Correction.
USB_PACK        AirSpy USB bit packing.
DC_REMOVE       DC remove.
DEC             Decimation: 2^dec, range: 0-8.
LOWPASS         Lowpass bandwidth in Hertz.
LP_TRANS        Lowpass transition width (0–1).
SENTENCE_CMD    Call external command with sentence as parameter.
SONDEHUB        Sondehub API URL (https://api.v2.sondehub.org)

## Usage
TODO

## Examples
TODO

## License

This project is licensed under the GNU General Public License
