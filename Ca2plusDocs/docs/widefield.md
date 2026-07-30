# Widefield Epifluorescence Imaging

Single-photon (widefield) epifluorescence Ca<sup>2+</sup> imaging on the Sutter rig, acquired in
**Ephus** via its built-in `qcam` program.

## Purpose

Widefield imaging maps tone-evoked fluorescence responses across the whole cranial window at low
magnification. The resulting tonotopic response maps are used to delineate cortical subfields so
that primary auditory cortex (A1) can be identified and targeted for subsequent 2P imaging in
ScanImage.

Typical order of operations in a session:

1. Acquire widefield tone-evoked maps in Ephus (`qcam` + sound stimulus).
2. Identify the tonotopic gradient/reversal to locate A1.
3. Move the objective to the identified subfield and switch to 2P acquisition in ScanImage.

See: [pyFluo](code.md#widefield-analysis) for widefield map analysis.

## Hardware

### Camera

- QImaging Retiga 2000R FireWire (IEEE 1394) camera
- 1600 × 1200 sensor
- Connected **directly to the acquisition computer over FireWire** — the image data path does not
  pass through the DAQ
- The camera's **trigger input** is driven by a **QCam board**, which in turn is driven by the
  NI USB-6229 (`Dev2`)

### Signal path

```
Ephus stimulator "Camera trigger" (Dev2 / USB-6229, AO3)
    → QCam board
    → Retiga 2000R trigger input          (frame timing)

Retiga 2000R → FireWire (IEEE 1394) → acquisition computer   (image data)
```

Frame timing and image data therefore travel on two separate paths: Ephus controls *when* frames
are taken (via the DAQ → QCam board → trigger input), while the frames themselves stream over
FireWire straight into `qcam`.

### Ephus channels used

From [ephus_init_matlab2013b_32bit_250kHz_Camera_20250903.m](config/Ephus/ephus_init_matlab2013b_32bit_250kHz_Camera_20250903.m)
(all on `Dev2` / NI USB-6229):

| Ephus channel | Direction | DAQ channel | Use |
|---|---|---|---|
| `Camera trigger` | Analog out | `AO3` | 5 V TTL trigger to QCam board |
| `Green LED output` | Analog out | `AO0` | Epifluorescence excitation |
| `Blue LED output` | Analog out | `AO2` | Epifluorescence excitation |
| `Sound output` | Analog out | `AO1` | Stimulus to ED1 speaker driver |
| `Green LED output check` | Analog in | `AI17` | LED output monitor |
| `sound output check` | Analog in | `AI16` | Sound output monitor |

See: [Configuration → Ephus startup file](configuration.md#startup-file) for the full channel list.

## Camera trigger pulse (Ephus)

Frames are clocked by a pulse train on the `Camera trigger` stimulus channel. Configure the pulse
in the Ephus pulse editor:

| Parameter | Value | Notes |
|---|---|---|
| ISI | `50` ms | Sets the frame rate: 1 / 50 ms = **20 Hz** |
| Amp [A.U.] | `5000` | Produces the **5 V** TTL the QCam board expects (1000 A.U. per volt) |
| Width | `1` ms | TTL pulse width |
| Delay | `1` ms | Delay to first pulse |
| Number | `400` | Number of pulses in the train |

**Setting `Number`:** it must be **greater than the number of frames required for the trace
length**, so the trigger train never runs out before acquisition ends. The required minimum is
`trace length × 20 Hz`:

- 10 s trace at 20 Hz → 200 frames required → `Number = 400` (current setting) leaves ample margin.

The camera stops on its own once it has collected the number of frames set by **Frames to acquire**
in the `qcam` panel, so surplus trigger pulses are harmless.

## QCam control panel (Ephus)

Settings in the `qcam` program window:

| Setting | Value |
|---|---|
| Exposure | `20` (ms) |
| Spatial bin factor | `8` |
| External | checked (external trigger mode) |

**Exposure** is entered in milliseconds and must not exceed the trigger ISI — 20 ms exposure fits
within the 50 ms ISI of the 20 Hz train.

**Spatial bin factor** divides the full sensor when `fullview` is enabled:

```matlab
width  = 1600 / binFactor;
height = 1200 / binFactor;
```

At `binFactor = 8` this gives a **200 × 150 px** frame (1600/8 × 1200/8). Binning trades spatial
resolution for signal-to-noise and frame rate, which suits widefield mapping — the goal is
locating subfield boundaries, not resolving individual cells.

**External** mode is what couples the camera to Ephus. With `External` checked, `qcam` sets the
camera to `edgeHigh` trigger type and `std` camera mode, so each TTL edge from the QCam board
acquires one frame. With `Preview` or `Start` checked instead, the trigger type is `auto` and the
camera free-runs, ignoring the DAQ.

### Looping

`External` must be re-armed between iterations of a loop. This is automated by the
[qcamExternalReset.m](config/Ephus/qcamExternalReset.m) user function, registered as an
`xsg:save` callback.

See: [Configuration → Custom user functions](configuration.md#custom-user-functions) and
[Operation → Looping](operation.md#looping).

## `qcam.m` modification

`qcam.m` **hardcodes the camera resolution**, so it must be edited to match the sensor of the
camera actually installed. The lab's copy of `qcam.m` was reduced to 696 × 520 for the Scientifica
rig's Rolera-XR camera (see the `CA062712` entry in the file's changelog); the Sutter rig's
Retiga 2000R needs 1600 × 1200.

This matters when restoring Ephus from a backup or from the Scientifica rig — a restore can
overwrite `qcam.m` with the 696 × 520 version and silently crop the Retiga's field of view.

- Rig location: `C:/Rig/Ephus 2013b/Programs/qcam/qcam.m`
- Sutter rig version: [qcam_mod_retiga_w1600_h1200.m](config/Ephus/qcam_mod_retiga_w1600_h1200.m)
  — **rename to `qcam.m` when deploying to the rig**

### Changes from the Rolera-XR version

The resolution appears in three code locations (696 × 520 → 1600 × 1200), plus a header changelog
entry:

**1. Header changelog**

```matlab
%  PC20260730 - configured for Retiga 2000R firewire camera with 1600 x 1200 resolution w/ QCam board for interface w/ DAQ and driver: QCamInstaller-2.0.13.1 x64
```

**2. Property defaults and GUI maxima** (~line 119)

```matlab
'width', 1600, 'Class', 'numeric', 'Gui', 'width', 'Max', 1600, 'Min', 1, 'Config', 7, ...
'height', 1200, 'Class', 'numeric', 'Gui', 'height', 'Max', 1200, 'Min', 1, 'Config', 7, ...
```

**3. Full-view frame size** (~line 725)

```matlab
if fullview
      width = 1600 / binFactor;
      height = 1200 / binFactor;
end
```

**4. Default ROI / full-view reset** (~line 1054)

```matlab
'xOffset', 0, 'yOffset', 0, 'width', 1600, 'height', 1200, 'fullview', 1);
```

**Note:** If the `Max` values in (2) are left at the smaller camera's resolution, the GUI clamps
width/height to that maximum and the frame is cropped rather than full-field.

## Driver

- **QCam driver v2.0.13.1, 64-bit** — `QCamInstaller-2-0-13-1-64bit.zip`
- **Do not install `QCamDriver2005`** — the legacy 2005 driver bundled with older Ephus
  distributions is superseded by QCamInstaller 2.0.13.1 and should not be used

Full install steps, including the `startQCam` smoke test, are in
[Rig Setup → Install QCam Driver](computer_setup.md#software-installation).

See also: [Drivers](drivers.md#imaging).

## Software requirements

- MATLAB **2013b 32-bit** (Ephus 2.1.0) — the `qcammex.mexw32` interface to the QCam API is 32-bit
  only, so widefield acquisition cannot be run from the 64-bit MATLAB used for ScanImage
- Ephus 2.1.0

See: [Software](software.md).
