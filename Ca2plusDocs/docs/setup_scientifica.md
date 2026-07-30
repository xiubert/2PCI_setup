# Rig-specific drivers — Scientifica rig

Drivers and archives unique to the **Scientifica** rig. The common install sequence is in
[Rig Setup](computer_setup.md); these are installed at its step 5.

## Computer

Dell Precision T3600

**Install Dell Support Assist first** so it can pull the correct drivers for this model.

> The specific Dell driver filenames for the T3600 are not yet recorded here — the list on the
> [Sutter page](setup_sutter.md#computer) is for the T5810 and does **not** apply.

## Motion control and beam attenuator — LinLab 2

Operates all three motorised axes in the 1U rack: the beam attenuator, the XYZ stage, and the
condenser focus. They appear as virtual COM ports (FTDI USB-serial), one LinLab 2 tab per device.

- `LinLab-2-Setup-1.0.19.177.zip` &rarr; `LinLab 2 Setup - 1.0.19.177.exe`
- See: [2P Laser Power control](laser_power_control.md#scientifica-rig)

## COM port assignments

| COM | Device | LinLab 2 tab | Used by ScanImage? |
|---|---|---|---|
| `COM3` | **Beam attenuator** | **UMS** (single axis, shown as Z) | No — LinLab only |
| `COM4` | XYZ stage | SliceScope — X, Y, Z | **Yes** — `motors(1).comPort = 4` |
| `COM5` | Condenser focus | SliceScope — C | No — not configured |

> **`COM3` hazard.** The inherited Sutter machine data file specifies `motors(1).comPort = 3`,
> which on this rig is the **beam attenuator**. Left unchanged, ScanImage would open the
> attenuator and drive it as an XYZ stage. It must be `4`.

**Pin the port numbers** in Device Manager → Port Settings → Advanced → COM Port Number once
identified — they have drifted across reinstalls before. Ports can also renumber after
unplug/replug into a different USB socket. Re-identification procedure:
[DAQ wiring &rarr; How to re-identify the ports](wiring_scientifica.md#61-how-to-re-identify-the-ports).

**LinLab holds its ports exclusively** — close LinLab 2 before MATLAB or ScanImage needs a port,
and vice versa.

## Software archives

| Software | Archive |
|---|---|
| Ephus | `Ephus 2013b_working_win10_20260730.zip` |
| ScanImage | `Scanimage5-3_working_win10_20260730.zip` |

> The Sharepoint location for these archives is not yet recorded.

## Camera

`qcam.m` must be the **Rolera-XR** variant (696 × 520) — `qcam_raw_rolera_w696_h520.m`, renamed
to `qcam.m`. See: [Widefield Epifluorescence](widefield.md#qcamm-modification).
