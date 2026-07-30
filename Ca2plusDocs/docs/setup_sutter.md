# Rig-specific drivers — Sutter rig

Drivers and archives unique to the **Sutter** rig. The common install sequence is in
[Rig Setup](computer_setup.md); these are installed at its step 5.

## Computer

[Dell Precision Tower 5810](https://www.dell.com/support/product-details/en-us/product/precision-t5810-workstation/drivers)

- Intel Xeon CPU E5-1630 @ 3.70 GHz, 32.0 GB RAM, NVIDIA NVS 310

**Install Dell Support Assist first** so it can pull the correct drivers, then:

- `Audio_Driver_DDG39_WN32_6.0.1.6111_A06_01.EXE`
- `Chipset_Driver_8W65V_1.0.0.1024_A00_ZPE.exe`
- `Chipset_Driver_YV36W_WN32_10.1.2.10_A01.EXE`
- `Dell-Security-Advisory-Update-DSA-2020-059_1GWG9_WIN64_1.0.0.0_A00_03.EXE`

## Motion control — Sutter CDM Controller Driver

For the Sutter MPC200 / ROE-200 micromanipulator.

- [`SI_CDM_v2_12_36.zip`](https://www.sutter.com/hubfs/SOFTWARE/SI_CDM_v2_12_36.zip?hsLang=en)
- [Installation guide](https://www.sutter.com/hubfs/SOFTWARE/CDM_driver_Install_Guide.pdf?hsLang=en)

## Laser power — Thorlabs Kinesis

For the KDC101 / PRM1Z8 motorised waveplate rotator.

- `Thorlabs_Kinesis_Setup_25822_x64.exe`
- Provides both the Kinesis application and the USB driver for the KDC101
- See: [2P Laser Power control](laser_power_control.md#sutter-rig)

## COM port assignments

| COM | Device |
|---|---|
| `COM3` | Sutter MPC200 micromanipulator — `motors(1).comPort = 3` |

## Software archives

From Sharepoint: Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr;
`sutter2P_backup`

| Software | Archive |
|---|---|
| Ephus | `Ephus 2013b_20260727_sutter.zip` |
| ScanImage | `Scanimage5-3_20260727_sutter.zip` |

## Camera

`qcam.m` must be the **Retiga 2000R** variant (1600 × 1200) —
[qcam_mod_retiga_w1600_h1200.m](config/Ephus/qcam_mod_retiga_w1600_h1200.m), renamed to `qcam.m`.
See: [Widefield Epifluorescence](widefield.md#qcamm-modification).
