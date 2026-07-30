# 2P Laser Power Control

Both rigs attenuate the excitation beam the same way: a **motorised half-wave plate rotating
against a fixed polarizer**. Rotating the waveplate turns the beam's polarization; the polarizer
passes only the aligned component and dumps the rest. The waveplate **angle** therefore sets how
much power reaches the rig.

Only the vendor and the control software differ between the two rigs.

## Per-rig hardware

| | Sutter | Scientifica |
|---|---|---|
| Rotator | [Thorlabs PRM1Z8](https://www.thorlabs.com/thorproduct.cfm?partnumber=PRM1Z8) motorised precision rotation mount | λ/2 waveplate (690–1200 nm) on a belt-driven mount |
| Actuator | [Thorlabs KDC101](https://www.thorlabs.com/thorproduct.cfm?partnumber=KDC101) K-Cube brushed DC servo controller | 1U rack axis, `COM3` |
| Connection | PRM1Z8 &rarr; KDC101 &rarr; USB &rarr; computer | 1U rack &rarr; motor &rarr; yellow belt &rarr; waveplate |
| Software | Thorlabs Kinesis | LinLab 2, **UMS** tab |
| Manual control | Jog wheel on the KDC101 | LinLab UMS |
| Rejected beam | *(not documented)* | Thorlabs BT600/M beam trap |
| Driver | `Thorlabs_Kinesis_Setup_25822_x64.exe` | `LinLab-2-Setup-1.0.19.177.zip` |
| Hardware page | [Sutter](hardware_sutter.md#power-intensity-controller) | [Scientifica](hardware_scientifica.md#beam-attenuator-laser-power) |

## Sutter rig

Excitation power entering the Sutter enclosure is set by the PRM1Z8, driven by the KDC101. The
KDC101 sits on the bench near the rig so the jog wheel is reachable during alignment.

**Manual — jog wheel on the KDC101.** Rotate the wheel on the front panel to change the mount
angle, and therefore the power, without any software running. This is the fastest way to change
power at the bench and is the method used during alignment.

**Digital — Thorlabs Kinesis.** The Kinesis GUI exposes the same axis for software control,
allowing the mount to be homed and moved to a specific angle rather than adjusted by feel. Use
this when a power setting needs to be returned to reproducibly across sessions, since an absolute
angle can be recorded and re-entered.

The Kinesis installer provides both the application and the USB driver for the KDC101. See:
[Drivers](drivers.md#imaging) and [Sutter rig-specific drivers](setup_sutter.md).

## Scientifica rig

Power is set by a motorised half-wave plate against a fixed polarizer, driven from the 1U rack:

```
LinLab 2 (UMS tab)
  → 1U rack module (COM3)
  → motor
  → yellow belt
  → λ/2 waveplate (690–1200 nm)
  → waveplate rotates, turning the beam's polarization
  → fixed polarizer passes only the aligned component
       ├─ transmitted → to the rig
       └─ rejected    → Thorlabs BT600/M beam trap
```

| Element | Role |
|---|---|
| Motor + yellow belt (driven from the 1U rack, `COM3`) | Rotates the waveplate; this is the actuator |
| **Half-wave plate**, λ/2, 690–1200 nm | Rotates the beam's polarization — the attenuating element |
| **Fixed polarizer**, downstream | Passes only the aligned component; physically removes power |
| Thorlabs **BT600/M** beam trap | Dumps the rejected polarization |
| Thorlabs **CP12** | Structural cage plate — no optical function |

Operated from the **UMS** tab in LinLab 2. See: [Scientifica rig-specific drivers](setup_scientifica.md)
and [DAQ wiring &rarr; Beam attenuator](wiring_scientifica.md#62-beam-attenuator-linlab-ums-tab).

> **`COM3` hazard.** On this rig `COM3` is the beam attenuator, not the stage. The inherited
> Sutter machine data file specifies `motors(1).comPort = 3`; left unchanged, ScanImage would
> open the attenuator and drive it as an XYZ stage. It must be `4`.

## Not integrated with the acquisition software

On **neither rig** is power under ScanImage or Ephus control. For the Sutter rig this is visible
in both configuration files:

- ScanImage [Machine_Data_File.m](config/ScanImage/Machine_Data_File.m): `beamDaqDevices = {}` and
  `beamDaqs(1).chanIDs = []` — no beam DAQ configured
- Ephus [startup file](config/Ephus/ephus_init_matlab2013b_32bit_250kHz_Camera_20250903.m):
  beam modulation fields empty

On the Scientifica rig the attenuator is a motorised axis on a serial port, which ScanImage's
beam system — analog voltage modulation on an AO channel — cannot address at all.

Practical consequences, on both rigs:

- Power is set **before** an acquisition and stays fixed for its duration; it cannot be ramped
  with depth or modulated per-frame from ScanImage
- The power used is **not recorded** in the .tif or .xsg headers — note it in your experiment
  record manually

## Safety

**Before alignment, always reduce power to its lowest setting at 920 nm** to avoid burning optics
in the beam path — via the PRM1Z8 jog wheel on the Sutter rig, or the LinLab UMS tab on the
Scientifica rig.

See: [2P Laser Alignment &rarr; Translational Alignment](alignment.md#translational-alignment-x-y).

## Do not confuse with the beam-split rotation mount

A **separate** rotation mount sits upstream of both rigs: a manual
[Newport ORM RSP-1T](https://www.newport.com/p/RSP-1T), which splits the shared MaiTai beam
between the Scientifica and Sutter rigs. It is not motorised and is not controlled by either
rig's attenuator.

| Mount | Motorised? | Purpose |
|---|---|---|
| Thorlabs PRM1Z8 (Sutter) | Yes — KDC101 | Sets power entering the Sutter enclosure |
| 1U rack waveplate (Scientifica) | Yes — `COM3` | Sets power entering the Scientifica rig |
| Newport ORM RSP-1T | No — manual | Splits the beam between the two rigs |

On the Scientifica rig the RSP-1T is adjusted **frequently**, to rebalance power between the two
rigs.

See: [2P Laser Alignment &rarr; Coarse Alignment Process](alignment.md#coarse-alignment-process-only-if-pollen-grain-not-visible).

## Calibration

The relationship between waveplate angle and power at the sample must be measured with a power
meter, separately for each rig.

See: [2P Laser Power calibration](cal_laser_power.md).
