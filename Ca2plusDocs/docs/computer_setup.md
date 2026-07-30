# Computer Setup Guide

Initial setup instructions for the Dell Precision Tower 5810 acquisition computer.

## Prerequisites

1. **Disconnect USB DAQ** - Ensure the USB DAQ is not connected before beginning installation

## Network & System Drivers

2. **Install GlobalProtect** - Required for internet access
3. **Install Dell Support Assist** - Automated driver installation tool
    - See: [drivers.md](drivers.md) for driver details
4. **Disable Sleep/Hibernate** - Prevent interruptions during data acquisition
    - Go to Power Options and disable sleep and hibernate modes

## Hardware Drivers

5. **Install Audio Driver**
    - `Audio_Driver_DDG39_WN32_6.0.1.6111_A06_01.EXE`
6. **Install Chipset Drivers**
    - `Chipset_Driver_8W65V_1.0.0.1024_A00_ZPE.exe`
    - `Chipset_Driver_YV36W_WN32_10.1.2.10_A01.EXE`
7. **Install Dell Security Advisory Update**
    - `Dell-Security-Advisory-Update-DSA-2020-059_1GWG9_WIN64_1.0.0.0_A00_03.EXE`

## Data Acquisition Drivers

8. **Install NI-DAQmx v15.5.0**
    - `NIDAQ1550f1.zip`
    - See: [NI-DAQmx downloads](https://www.ni.com/en/support/downloads/drivers/download.ni-daq-mx.html)
9. **Install Sutter CDM Controller Driver**
    - `SI_CDM_v2_12_36.zip`
    - See: [Installation guide](https://www.sutter.com/hubfs/SOFTWARE/CDM_driver_Install_Guide.pdf?hsLang=en)
10. **Install Thorlabs Kinesis Driver** - For laser power control (KDC101 / PRM1Z8)
    - `Thorlabs_Kinesis_Setup_25822_x64.exe`
    - See: [2P Laser Power control](laser_power_control.md)

## System Optimization

11. **Remove Unnecessary Programs**
    - Uninstall OneDrive and other unnecessary programs
12. **Disable Transparency Effects**
    - System Properties → Performance Settings → Disable transparency

## Software Installation

13. **Install MATLAB 2013b (32-bit)**
14. **Install Ephus**
    - Copy `Ephus 2013b_20250909_qcamFix.zip` from Sharepoint (Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr; `sutter2P_backup`) to `C:/Rig/`
    - Unzip `Ephus 2013b_20260727_sutter.zip`
    - Ephus should be in folder named `C:/Rig/Ephus 2013b`
    - Add `C:/Rig/Ephus 2013b` to MATLAB 2013b path with subfolders
15. **Install QCam Driver** (v2.0.13.1 64-bit)
    - `QCamInstaller-2-0-13-1-64bit.zip`
    - see: Sharepoint: Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr; `sutter2P_backup` &rarr; `drivers`

    **Testing:**

    1. Turn on camera board
    2. Launch Ephus
    3. Add Ephus to MATLAB path
    4. Run `startQCam` to verify installation

16. **Install MATLAB 2015b x64**
17. **Install ScanImage**
    - Copy `Scanimage5-3_20260727_sutter.zip` from Sharepoint (Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr; `sutter2P_backup`) to `C:/Rig/`
    - Unzip `Scanimage5-3_20260727_sutter.zip`
    - ScanImage should be in folder named `C:/Rig/Scanimage5-3`
    - Add `C:/Rig/Scanimage5-3` to MATLAB 2015b path with subfolders

18. **Configure Ephus and Scanimage**
    - see: [Configuration](configuration.md)

## Laser Control Software

Needed to operate the MaiTai — wavelength, shutter, and laser on/off are set from the computer,
not from the laser itself.

19. **Install MaiTai USB communication driver** (Silicon Labs CP210x Virtual COM Port)
    - `maitai_mks_usb_comm_CP210x_VCP_Windows.zip`
    - Unzip and run `CP210x_VCP_Windows/CP210xVCPInstaller_x64.exe`
    - **Install before the GUI** — it creates the virtual COM port the GUI connects through
    - Connect the laser over USB, then confirm the port appears under Device Manager &rarr; Ports (COM & LPT)
        - Note the COM number: `COM3` is already taken by the Sutter MPC200 micromanipulator
          (`motors(1).comPort = 3` in [Machine_Data_File.m](config/ScanImage/Machine_Data_File.m)),
          so the laser will be on a different port
20. **Install MaiTai Customer GUI** (v1.03.01)
    - `MaiTai Customer GUI 1.03.01 (1).zip`
    - Unzip and run `MaiTai Customer GUI SW077-1.03.01/setup.exe`
    - This is a National Instruments distribution (`nidist.id`), so it may also install the
      LabVIEW Run-Time Engine
    - See: [Software &rarr; MaiTai laser control](software.md#maitai-laser-control)


