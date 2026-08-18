# Hardware — Scientifica rig

Components of the **Scientifica** 2P rig for in vivo 2PCI (2 Photon Calcium Imaging), migrated
to Windows 10 in July 2026.

For the other rig, see [Hardware — Sutter rig](hardware_sutter.md).

## Computer
- Dell Precision T3600

## Microscope
- Scientifica **S-Scope-II** (serial 004257)
- Stage moves rather than the objective (objective moves on the Sutter rig)

## DAQs

Same board complement and the same trigger topology as the Sutter rig.

1. [NI USB-6229](https://www.ni.com/en-us/support/model.usb-6229.html) (ID: `Dev2`)
    - Ephus acquire / sound stimulation / LED drivers / QCam trigger
2. [NI PCI-6110](https://www.ni.com/en-us/support/model.pci-6110.html) ([BNC-2090A breakout](https://www.ni.com/en-us/support/model.bnc-2090a.html)) (ID: `Dev1`)
    - ScanImage 2P: galvos, PMTs, shutter, 2P trigger out

Full terminal-by-terminal wiring, signal chains and diagram:
[DAQ wiring — Scientifica rig](wiring_scientifica.md).

## Widefield epifluorescence camera
- QImaging **Rolera-XR** (696 &times; 520), FireWire (IEEE 1394)
- Image data connects **directly to the computer** via FireWire
- Camera trigger input driven by a QCam board, which is driven by the NI USB-6229 (`Dev2`, `AO3`)
- See: [Widefield Epifluorescence](widefield.md)

## PMT
- Scientifica **2PIMS-PMT-20**
- Controller: Scientifica 2PIMS-8000
- Different PMT from the Sutter rig, so the
  [herringbone artifact](hardware_sutter.md#herringbone-artifact) documented there does **not**
  apply here — an artifact on this rig has another cause

## Galvo / Scan controller
- Scientifica **GALVO-CONT**
- Galvo / galvo mirrors for laser scanning

## Laser
- MaiTai HP, Newport — **shared with the Sutter rig**, split by a manual
  [Newport ORM RSP-1T](https://www.newport.com/p/RSP-1T) rotation mount
- The RSP-1T is adjusted **frequently**, to rebalance power between the two rigs

## Beam attenuator (laser power)
- Motorised half-wave plate working against a fixed polarizer
- Driven from the **1U rack** on `COM3`, operated from the **LinLab 2 UMS** tab
- See: [2P Laser Power control](laser_power_control.md)

## 1U rack — motorised axes

The Scientifica 1U rack presents its motorised devices as virtual COM ports (FTDI USB-serial),
one LinLab 2 tab per device.

| COM | Device | LinLab 2 tab | Used by ScanImage? |
|---|---|---|---|
| `COM3` | Beam attenuator | **UMS** (single axis, shown as Z) | No — LinLab only |
| `COM4` | XYZ stage | SliceScope — X, Y, Z | **Yes** — `motors(1).comPort = 4` |
| `COM5` | Condenser focus | SliceScope — C | No — not configured |

> **`COM3` hazard.** The inherited Sutter machine data file specifies `motors(1).comPort = 3`,
> which on this rig is the **beam attenuator**, not the stage. Left unchanged, ScanImage would
> open the attenuator and drive it as an XYZ stage. It must be `4`.

The condenser is a transmitted-light illumination optic and is **unused** on this in vivo rig —
a remnant of an earlier in vitro patch-clamp configuration. Detail and the port
re-identification procedure: [DAQ wiring](wiring_scientifica.md#6-serial-motion-control-devices-linlab-2).

## Speaker and Speaker controller
- freefield speaker (ES1, Tucker Davis)
- ED1 speaker driver (Tucker Davis)
- **Separate speaker from the Sutter rig** — must be calibrated independently, and cannot use
  the same stimulus files. See: [Speaker calibration](cal_speaker.md).
