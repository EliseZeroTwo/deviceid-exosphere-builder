# DeviceID Exosphere Builder

Dockerized tool to build a custom Exosphere binary that spoofs the DeviceID

## How to use

The tool requires a volume mounted to the `/output` directory of the container, and the `DEVICEID` environment variable, with the DeviceID used to spoof.

Either build the docker image locally or use the prebuild image from Dockerhub, replacing the DEVICEID value with your DeviceID:

```bash
mkdir -p ./output
docker run -ti --rm -e DEVICEID=0x0000000000000000 -v "$PWD"/output:/output pablozaiden/deviceid-exosphere-builder:0.14.1
```

After the build, copy the `output/deviceid_exosphere.bin` file to the `atmosphere` directory of your SD card, and add the following entries to `BCT.ini`:

```ìni
[stage2]
exosphere = atmosphere/deviceid_exosphere.bin
```

## Thanks to:
- **schmue**, **Jan4V** and **SciresM** for all the patience answering questions and all the info about this and the *full nand transplant* options.