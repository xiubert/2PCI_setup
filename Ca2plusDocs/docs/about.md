# About This Documentation

## Purpose

This documentation provides comprehensive information for operating and maintaining the lab's two 2P microscopy systems for in vivo 2-photon calcium imaging (2PCI) — the **Sutter** rig and the **Scientifica** rig. It serves as a reference for system setup, daily operation, troubleshooting, and custom software configurations.

## System Overview

Both rigs run the same software stack and share the same MaiTai laser, split between them by a
manual Newport ORM RSP-1T rotation mount. They differ in microscope, computer, camera, and
laser-power hardware.

### Shared between the rigs

- Two National Instruments DAQ boards each, same topology:
    - NI USB-6229 (Dev2) - Ephus acquire/sound stimulation
    - NI PCI-6110 with BNC-2090A breakout (Dev1) - ScanImage 2P
- MaiTai HP laser (Newport) for 2-photon excitation — **one laser, split between both rigs**
- Tucker Davis ES1 freefield speaker with ED1 driver (one per rig, calibrated separately)
- Beam attenuation by a motorised half-wave plate against a fixed polarizer

### Sutter rig

Built around a **Sutter MOM (Moveable Objective Microscope)**, which features a moveable objective rather than a moveable stage.

- Sutter MOM microscope with 40× 0.8 NA objective (Olympus)
- Hamamatsu H10770PA-40 PMT with Sutter PS-2LV controller
- QImaging Retiga 2000R FireWire camera (1600 × 1200) for widefield epifluorescence imaging
- Sutter ROE-200 micromanipulator
- ThorLabs KDC101 motor controller with PRM1Z8 rotation mount for laser power control (manual jog wheel or Thorlabs Kinesis software)
- Dell Precision Tower 5810 workstation (Windows 10)

### Scientifica rig

Built around a **Scientifica S-Scope-II**, on which the stage moves rather than the objective.

- Scientifica S-Scope-II microscope
- Scientifica 2PIMS-PMT-20 PMT with 2PIMS-8000 controller
- Scientifica GALVO-CONT galvo / scan controller
- QImaging Rolera-XR FireWire camera (696 × 520) for widefield epifluorescence imaging
- 1U rack with three motorised axes on virtual COM ports — beam attenuator, XYZ stage, condenser — operated from LinLab 2
- Dell Precision T3600 workstation (Windows 10)

### Software Stack

- **Operating System**: Windows 10 (21H2 x64)
- **Ephus 2.1.0**: Widefield imaging and sound stimulus delivery (MATLAB 2013b 32-bit)
- **ScanImage 5.3.1 (2017)**: 2-photon microscopy control (MATLAB 2015b x64)
- **Custom user functions**: Automated workflows and experiment control
- **Acquisition specs (2P)**: 145×145 μm images at 256×256 pixels, 5 Hz effective frame rate
- **Acquisition specs (widefield)**: camera triggered at 20 Hz (50 ms ISI) on both rigs — 20 ms exposure on the Sutter rig, 38 ms on the Scientifica rig
- **Laser power software**: Thorlabs Kinesis (Sutter) / LinLab 2 (Scientifica)

## Key Features

### Synchronized Dual-DAQ Acquisition

The system synchronizes two DAQ boards for coordinated 2P imaging and stimulus delivery:

- Trigger routing from ScanImage (Dev1/PFI13) to Ephus (Dev2/PFI0) via USER2 BNC connection
- Sample clock sharing for precise temporal coordination
- Custom user functions respond to ScanImage events (`acqModeArmed`, `acqModeDone`, `acqAbort`)

### Custom User Functions

**Ephus user functions:**

- Save stimulus pulse details to .mat files
- Random pulse selection (with/without replacement)
- Automatic QCam reset for looping acquisitions

**ScanImage user functions:**

- `digtrig_stimPulse_train`: Triggers Ephus stimulus with configurable delay
- `digtrig_stimPulse_train_withCam`: Version with pupillometry camera support

### Safety Protocols

- **Laser safety glasses**: LG8 (630-695nm) for 690nm alignment, LG9 (610-695nm + >740-1070nm) for 920nm
- Proper alignment procedures with protective equipment
- Power monitoring and control via motorized rotation mount

## Known Issues

- **Herringbone artifact**: Normal for End-On Hamamatsu PMT (H10770PA-40) configuration
- **Timing delay**: ~97-99ms (occasionally up to 700ms) between ScanImage acquisition start and `acquisitionStarted` timestamp in user function

## Maintenance & Support

**Primary Technical Contact:**
- Rick Ayer, Sutter Instruments
- Email: rick@sutter.com

## Contributing

This documentation is maintained as a living document. Updates should include:

- Configuration file changes with date stamps
- New procedures or workflow improvements
- Troubleshooting solutions for common issues
- Hardware or software modifications

---

**Last updated:** December 11, 2025
