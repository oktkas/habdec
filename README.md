# HABDEC - RTTY decoder for High Altitude Balloons

[Dockerized](https://hub.docker.com/r/oktkas/habdec) version of [michalfratczak/habdec](https://github.com/michalfratczak/habdec).


Runs a websocket server on port 5555. Connect using [habdec-ui](https://github.com/oktkas/habdec-ui) or open the [original web client files](https://github.com/michalfratczak/habdec/tree/master/code/webClient) in your browser.

## Build Instructions
TODO

## Environment Variables

DEVICE          SDR Device Number. Using 0 (first device). Use -1 to list devices.
SAMPLING_RATE   Sampling Rate, set to 2.024e6 (Hz) as supported by device.
NO_EXIT         Constantly retry on missing device instead of exit. Set to 1 (enabled).
PORT            Command Port. Set to 127.0.0.1:5555.
STATION         HABHUB station callsign. Currently empty (disables HABHUB upload).
LATLON          Station GPS location (decimal). Currently empty.
ALT             Station altitude in meters. Currently empty.
FREQ            Frequency in MHz. Set to 434.69.
PPM             Frequency correction in PPM. Set to 0.
GAIN            Gain. Currently empty (automatic/default).
PRINT           Live print received chars. Set to 1 (enabled).
RTTY            RTTY: baud bits stops. Set to 300 8 2.
BIAST           Bias-T. Set to 0 (disabled).
BIAS_T          Bias-T. Set to 0 (disabled).
AFC             Auto Frequency Correction. Set to 1 (enabled).
USB_PACK        AirSpy USB bit packing. Set to 0 (disabled).
DC_REMOVE       DC remove. Set to 0 (disabled).
DEC             Decimation: 2^dec, range: 0-8. Set to 0 (no decimation).
LOWPASS         Lowpass bandwidth in Hertz. Currently empty.
LP_TRANS        Lowpass transition width (0–1). Currently empty.
SENTENCE_CMD    Call external command with sentence as parameter. Currently empty.
SONDEHUB        Sondehub API URL. Set to https://api.v2.sondehub.org

## Usage
TODO

## Examples
TODO

## License

This project is licensed under the GNU General Public License
