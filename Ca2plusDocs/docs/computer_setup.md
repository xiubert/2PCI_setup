# Rig Setup

Install sequence for an acquisition computer after reinstalling Windows. **These steps are the
same on both rigs.** The drivers that differ are listed on each rig's own page, and are installed
at step 5 below:

- [Sutter — rig-specific drivers](setup_sutter.md)
- [Scientifica — rig-specific drivers](setup_scientifica.md)

## Prerequisites

1. **Disconnect USB DAQ** - Ensure the USB DAQ is not connected before beginning installation

## Network & System

2. **Install GlobalProtect** - Required for internet access
3. **Install Dell Support Assist** - Automated driver installation tool
    - Install this **first**, so it can pull the correct drivers for the machine
    - See: [drivers.md](drivers.md) for driver details
4. **Disable Sleep/Hibernate** - Prevent interruptions during data acquisition
    - Go to Power Options and disable sleep and hibernate modes

## Rig-specific drivers

5. **Install the drivers for this rig** — Dell model drivers, plus the motion/attenuator drivers
   unique to the rig
    - Sutter: [setup_sutter.md](setup_sutter.md)
    - Scientifica: [setup_scientifica.md](setup_scientifica.md)

## Data Acquisition Drivers

6. **Install NI-DAQmx v15.5.0**
    - `NIDAQ1550f1.zip`
    - Serves the NI USB-6229 (`Dev2`, Ephus) and NI PCI-6110 (`Dev1`, ScanImage) on both rigs
    - See: [NI-DAQmx downloads](https://www.ni.com/en/support/downloads/drivers/download.ni-daq-mx.html)

## System Optimization

7. **Remove Unnecessary Programs**
    - Uninstall OneDrive and other unnecessary programs
8. **Disable Transparency Effects**
    - System Properties → Performance Settings → Disable transparency

## Software Installation

Both rigs run the same versions; only the archive filenames differ, and those are listed on the
rig-specific pages.

9. **Install MATLAB 2013b (32-bit)**
10. **Install Ephus**
    - Copy this rig's Ephus archive from Sharepoint to `C:/Rig/` and unzip
    - Ephus should end up in a folder named `C:/Rig/Ephus 2013b`
    - Add `C:/Rig/Ephus 2013b` to the MATLAB 2013b path, with subfolders
    - **Confirm `qcam.m` matches this rig's camera** — see
      [Widefield &rarr; qcam.m modification](widefield.md#qcamm-modification)
11. **Install QCam Driver** (v2.0.13.1 64-bit)
    - `QCamInstaller-2-0-13-1-64bit.zip` — the same driver on both rigs
    - see: Sharepoint: Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr; `sutter2P_backup` &rarr; `drivers`
    - **Do not install `QCamDriver2005`** (legacy, superseded)

    **Testing:**

    1. Turn on camera board
    2. Launch Ephus
    3. Add Ephus to MATLAB path
    4. Run `startQCam` to verify installation

12. **Install MATLAB 2015b x64**
13. **Install ScanImage**
    - Copy this rig's ScanImage archive from Sharepoint to `C:/Rig/` and unzip
    - ScanImage should end up in a folder named `C:/Rig/Scanimage5-3`
    - Add `C:/Rig/Scanimage5-3` to the MATLAB 2015b path, with subfolders

14. **Configure Ephus and Scanimage**
    - see: [Configuration](configuration.md)
    - **Check `motors(1).comPort`** — it differs between the rigs, and the wrong value on the
      Scientifica rig drives the beam attenuator as a stage. See
      [Configuration &rarr; Per-rig differences](configuration.md#per-rig-differences)

## Laser Control Software

Needed to operate the MaiTai — wavelength, shutter, and laser on/off are set from the computer,
not from the laser itself. The laser is shared between the rigs, so this is only needed on the
computer used to control it.

15. **Install MaiTai USB communication driver** (Silicon Labs CP210x Virtual COM Port)
    - `maitai_mks_usb_comm_CP210x_VCP_Windows.zip`
    - Unzip and run `CP210x_VCP_Windows/CP210xVCPInstaller_x64.exe`
    - **Install before the GUI** — it creates the virtual COM port the GUI connects through
    - Connect the laser over USB, then confirm the port appears under Device Manager &rarr; Ports (COM & LPT)
        - Note the COM number, and check it does not collide with a port already in use on the
          rig (see the rig-specific pages for what is already assigned)
16. **Install MaiTai Customer GUI** (v1.03.01)
    - `MaiTai Customer GUI 1.03.01 (1).zip`
    - Unzip and run `MaiTai Customer GUI SW077-1.03.01/setup.exe`
    - This is a National Instruments distribution (`nidist.id`), so it may also install the
      LabVIEW Run-Time Engine
    - See: [Software &rarr; MaiTai laser control](software.md#maitai-laser-control)
