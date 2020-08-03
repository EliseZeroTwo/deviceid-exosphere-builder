# DeviceID Exosphere Builder

Dockerized tool to build a custom Exosphere binary that spoofs the DeviceID. This can be used to boot Horizon with Atmosphere in a Nintendo Switch with  transplanted PRODINFO/PRODINFOF partitions

## How to transplant PRODINFO/PRODINFOF and recreate the other EMMC partitions from scratch

### WARNING
**This procedure is only meant to be able to boot the console back into Horizon, after losing the contents of PRODINFO/PRODINFOF partitions. THIS IS NOT MEANT TO UNBAN YOUR CONSOLE. If you try doing that, the most likely outcome is that you will end up with another banned console. Avoid any kind of piracy from now on and DON'T USE the transplanted console online**

### Requirements:
- A working console full EMMC backup (Console A), or that console running latest Hekate
- A console with working hardware, but without a working EMMC backup (Console B)
- [NxNandManager](https://github.com/eliboa/NxNandManager)
- [HackDiskMount](https://files.sshnuke.net/HacDiskMount1055.zip)
- BIS keys for Console A and B
- Docker
- Latest Hekate
- Latest Atmosphere

### Steps
1. Open the EMMC from Console A or its backup with NxNandManager, using Console A BIS keys
1. Write down the DEVICE ID, without the initial `NX-` and the `-0` (or whatever there is) at the end. For instance, if it says: `NX-1122334455667788-0`, your device is: `1122334455667788`
1. Dump and decrypt PRODINFO and PRODINFOF partitions from Console A
1. Close NxNandManager
1. Open the EMMC from Console B with NxNandManager, using Console B BIS keys
1. Restore the decrypted PRODINFO and PRODINFO partitions from Console A into Console B
1. Close NxNandManager
1. Follow [this guide](https://switch.homebrew.guide/usingcfw/manualchoiupgrade.html) to recreate the rest of the EMMC partitions, BOOT0 and BOOT1 on Console B using Console B BIS keys, **UP TO AND INCLUDING, STEP 12. DO NOT ATTEMPT TO BOOT**
1. On the `SYSTEM` partition, delete all the files/folders of the `save` folder **except the one ending in `120`**
1. Put the latest version of Hekate and Atmosphere on your SD
1. Create the custom Exosphere binary that spoofs the DeviceID.

## How to create the custom Exosphere binary 

This tool requires a volume mounted to the `/output` directory of the container, and the `DEVICEID` environment variable, with the DeviceID to spoof.

Either build the docker image locally or use the prebuilt image from Dockerhub, replacing the DEVICEID value with your DeviceID:

```bash
mkdir -p ./output
docker run -ti --rm -e DEVICEID=0x0000000000000000 -v "$PWD"/output:/output pablozaiden/deviceid-exosphere-builder:0.14.1
```

After the build, copy the `output/deviceid_exosphere.bin` file to the `atmosphere` directory of your SD card, and add the following entries to `BCT.ini`:

```ini
[stage2]
exosphere = atmosphere/deviceid_exosphere.bin
```

## Acknowledgements:
- **schmue**, **Jan4V** and **SciresM** for all the patience answering questions and all the info about this and the *full nand transplant* options.