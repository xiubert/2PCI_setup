# Drivers
- required to interface with recording hardware

Drivers marked **Sutter** or **Scientifica** are rig-specific; the rest are installed on both.
Per-rig lists: [Sutter](setup_sutter.md) · [Scientifica](setup_scientifica.md).

## Imaging
1. [NI-DAQmx](https://www.ni.com/en/support/downloads/drivers/download.ni-daq-mx.html): interface for the USB-6229 (Ephus) and NI PCI-6110 (ScanImage) DAQs
    - **v15.5.0**: `NIDAQ1550f1.zip​`
2. QCam driver for widefield camera (Retiga 2000R):
    - **v2.0.13.1 (x64)**: `QCamInstaller-2-0-13-1-64bit.zip`
    - **Do not install `QCamDriver2005`** (legacy driver, superseded by the above)
    - See: [Widefield Epifluorescence &rarr; Driver](widefield.md#driver)

3. Sutter CDM Controller Driver — **Sutter only** (MPC200 / ROE-200 micromanipulator):
    - [`SI_CDM_v2_12_36.zip`](https://www.sutter.com/hubfs/SOFTWARE/SI_CDM_v2_12_36.zip?hsLang=en)
    - [Installation guide](https://www.sutter.com/hubfs/SOFTWARE/CDM_driver_Install_Guide.pdf?hsLang=en)

4. Driver for laser power adjustment — **Sutter only** ([Thorlabs Kinesis](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=10285) controller of PRM1Z8)
    - `Thorlabs_Kinesis_Setup_25822_x64.exe`
    - Provides both the Kinesis application and the USB driver for the KDC101
    - See: [2P Laser Power control](laser_power_control.md#sutter-rig)

5. LinLab 2 — **Scientifica only** (1U rack: beam attenuator, XYZ stage, condenser)
    - `LinLab-2-Setup-1.0.19.177.zip`
    - See: [2P Laser Power control](laser_power_control.md#scientifica-rig)


## Laser
- Required to control the MaiTai. The laser has **no front-panel controls** for wavelength, shutter, or laser on/off &mdash; these are set from the computer via the MaiTai GUI.

1. MaiTai USB communication driver (Silicon Labs CP210x USB-to-UART Virtual COM Port):
    - `maitai_mks_usb_comm_CP210x_VCP_Windows.zip`
    - Unzips to `CP210x_VCP_Windows/`; run `CP210xVCPInstaller_x64.exe` on Windows 10 x64
    - Makes the laser enumerate as a virtual COM port, which the MaiTai GUI connects to
    - **Install this before the GUI**

2. MaiTai control GUI:
    - `MaiTai Customer GUI 1.03.01 (1).zip` (unzips to `MaiTai Customer GUI SW077-1.03.01/`)
    - Run `setup.exe`
    - See: [Software &rarr; MaiTai laser control](software.md#maitai-laser-control)


## Computer
- Driver sources: [Dell Precision T5810 Drivers & Downloads](https://www.dell.com/support/product-details/en-us/product/precision-t5810-workstation/drivers)
    - `DellSupportAssistinstaller.exe`

- See: [computer_setup.md](computer_setup.md) (**first install Dell Support Assist to install relevant drivers**)
    - `Audio_Driver_DDG39_WN32_6.0.1.6111_A06_01.EXE`
    - `Chipset_Driver_8W65V_1.0.0.1024_A00_ZPE.exe`
    - `Chipset_Driver_YV36W_WN32_10.1.2.10_A01.EXE`

- `Dell-Security-Advisory-Update-DSA-2020-059_1GWG9_WIN64_1.0.0.0_A00_03.EXE`