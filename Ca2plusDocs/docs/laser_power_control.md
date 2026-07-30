# 2P Laser Power Control

Excitation power entering the Sutter enclosure is set by a **motorized precision rotation mount**
driven by a **brushed DC servo motor controller**. The mount can be driven either by hand, using
the jog wheel on the controller, or digitally from the Thorlabs Kinesis software.

## Hardware

| Component | Model | Role |
|---|---|---|
| Rotation mount | [Thorlabs PRM1Z8](https://www.thorlabs.com/thorproduct.cfm?partnumber=PRM1Z8) | Motorized precision rotation mount; rotation sets beam attenuation |
| Motor controller | [Thorlabs KDC101](https://www.thorlabs.com/thorproduct.cfm?partnumber=KDC101) | K-Cube brushed DC servo motor controller; drives the PRM1Z8 |

**Connection:**

```
PRM1Z8  →  KDC101 (motor cable)  →  USB  →  acquisition computer
```

The KDC101 sits on the bench near the Sutter rig so the jog wheel is reachable during alignment.

See: [Hardware → Power Intensity Controller](hardware.md#power-intensity-controller).

## Control modes

### Manual — jog wheel on the KDC101

Rotate the wheel on the KDC101 front panel to change the mount angle, and therefore the power,
without any software running. This is the fastest way to change power at the bench and is the
method used during alignment.

### Digital — Thorlabs Kinesis software

The Kinesis GUI exposes the same axis for software control, allowing the mount to be homed and
moved to a specific angle rather than adjusted by feel. Use this when a power setting needs to be
returned to reproducibly across sessions, since an absolute angle can be recorded and re-entered.

## Software and driver

- **Thorlabs Kinesis** — `Thorlabs_Kinesis_Setup_25822_x64.exe`
- The same installer provides both the Kinesis application and the USB driver for the KDC101

See: [Drivers](drivers.md#imaging) and
[Rig Setup → Install Thorlabs Kinesis Driver](computer_setup.md#data-acquisition-drivers).

## Not integrated with the acquisition software

Power is **not** under ScanImage or Ephus control on this rig — there is no Pockels cell or beam
modulation path. This is reflected in both configuration files:

- ScanImage [Machine_Data_File.m](config/ScanImage/Machine_Data_File.m): `beamDaqDevices = {}` and
  `beamDaqs(1).chanIDs = []` — no beam DAQ configured
- Ephus [startup file](config/Ephus/ephus_init_matlab2013b_32bit_250kHz_Camera_20250903.m):
  `pockelsBoardID = []` and `pockelsChannelID = []` — Pockels feature disabled

Practical consequences:

- Power is set **before** an acquisition and stays fixed for its duration; it cannot be ramped
  with depth or modulated per-frame from ScanImage
- The power used is **not recorded** in the .tif or .xsg headers — note it in your experiment
  record manually

## Safety

**Before alignment, always reduce power to its lowest setting at 920 nm using the PRM1Z8 jog
wheel** to avoid burning optics in the beam path.

See: [2P Laser Alignment → Translational Alignment](alignment.md#translational-alignment-x-y).

## Do not confuse with the beam-split rotation mount

A **second, separate** rotation mount sits upstream: a manual
[Newport RSP-1T](https://www.newport.com/p/RSP-1T), used during coarse alignment to split the beam
roughly evenly between the Scientifica and Sutter rigs. It is not motorized and is not controlled
by the KDC101.

| Mount | Motorized? | Purpose |
|---|---|---|
| Thorlabs PRM1Z8 | Yes (KDC101) | Sets power entering the Sutter enclosure |
| Newport RSP-1T | No (manual) | Splits beam between the Scientifica and Sutter rigs |

See: [2P Laser Alignment → Coarse Alignment Process](alignment.md#coarse-alignment-process-only-if-pollen-grain-not-visible).

## Calibration

The relationship between mount angle and power at the sample must be measured with a power meter.

See: [2P Laser Power calibration](cal_laser_power.md).
