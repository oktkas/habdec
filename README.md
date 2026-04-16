# HABDEC - RTTY decoder for High Altitude Balloons

[Dockerized](https://hub.docker.com/r/oktkas/habdec) version of [michalfratczak/habdec](https://github.com/michalfratczak/habdec).

Runs a WebSocket server on port 5555. Connect using [habdec-ui](https://github.com/oktkas/habdec-ui) or the [original web client](https://github.com/michalfratczak/habdec/tree/master/code/webClient).

## Usage

Copy `docker-compose.yml`, edit the environment variables to match your setup, then:

```bash
docker compose up -d
```

The UI will be available at `http://localhost:8080`. To use an external hostname with HTTPS/WSS, put a reverse proxy in front of habdec-ui and set `HABDEC_SERVER_URL=wss://your-hostname`.

## Environment Variables

| Variable | Description |
| --- | --- |
| `DEVICE` | SDR device index. Use `-1` to list available devices. |
| `SAMPLING_RATE` | Sampling rate in Hz (e.g. `2.024e6`) |
| `NO_EXIT` | Set to `1` to keep retrying if the device is missing |
| `PORT` | WebSocket listen address (default: `0.0.0.0:5555`) |
| `STATION` | Your amateur callsign. Required to enable SondeHub upload. |
| `LATLON` | Station position as decimal degrees (e.g. `50.1 14.4`) |
| `ALT` | Station altitude in meters |
| `FREQ` | Receive frequency in MHz |
| `PPM` | Frequency correction in PPM |
| `GAIN` | SDR gain. Leave empty for automatic. |
| `BIAST` / `BIAS_T` | Bias-T power (enable for active antennas) |
| `RTTY` | RTTY parameters: `<baud> <bits> <stops>` (e.g. `300 7 2`) |
| `AFC` | Auto frequency correction (`0`/`1`) |
| `DEC` | Decimation exponent: actual factor is `2^DEC`, range 0–8 |
| `LOWPASS` | Lowpass filter bandwidth in Hz |
| `LP_TRANS` | Lowpass transition width (0–1) |
| `USB_PACK` | AirSpy USB bit packing (`0`/`1`) |
| `DC_REMOVE` | DC spike removal (`0`/`1`) |
| `PRINT` | Print decoded characters to stdout (`0`/`1`) |
| `SENTENCE_CMD` | Shell command called with each decoded sentence as argument |
| `SONDEHUB` | SondeHub API URL (default: `https://api.v2.sondehub.org`) |

## Build & Publish

Requires Docker with buildx and QEMU support (Docker Desktop includes this by default).

Set up the builder once:

```bash
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```

Build and push a multi-arch image (amd64, arm64, armv7):

```bash
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 \
  --cache-from type=registry,ref=oktkas/habdec:buildcache \
  --cache-to   type=registry,ref=oktkas/habdec:buildcache,mode=max \
  -t oktkas/habdec:testing --push .
```

Promote to latest once verified:

```bash
docker buildx imagetools create -t oktkas/habdec:latest oktkas/habdec:testing
```

## License

This project is licensed under the GNU General Public License.
