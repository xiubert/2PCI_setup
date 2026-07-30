# Widefield Epifluorescence Imaging

Single-photon (widefield) epifluorescence Ca<sup>2+</sup> imaging, acquired in **Ephus** via its
built-in `qcam` program.

**Both rigs use the same acquisition path and the same QCam driver**, but a different camera —
so the resolution hardcoded in `qcam.m` and the acquisition settings differ. Per-rig values are
in [Camera and settings per rig](#camera-and-settings-per-rig).

## Purpose

Widefield imaging maps tone-evoked fluorescence responses across the whole cranial window at low
magnification. The resulting tonotopic response maps are used to delineate cortical subfields so
that primary auditory cortex (A1) can be identified and targeted for subsequent 2P imaging in
ScanImage.

Typical order of operations in a session:

1. Acquire widefield tone-evoked maps in Ephus (`qcam` + sound stimulus).
2. Identify the tonotopic gradient/reversal to locate A1.
3. Move to the identified subfield — the objective on the Sutter rig, the stage on the
   Scientifica rig — and switch to 2P acquisition in ScanImage.

See: [pyFluo](code.md#widefield-analysis) for widefield map analysis.

## Camera and settings per rig

| | Sutter | Scientifica |
|---|---|---|
| Camera | QImaging **Retiga 2000R**, FireWire (IEEE 1394) | QImaging **Rolera-XR**, FireWire (IEEE 1394) |
| Sensor | 1600 wide × 1200 high | **696 wide × 520 high** |
| `qcam.m` variant | [qcam_mod_retiga_w1600_h1200.m](config/Ephus/qcam_mod_retiga_w1600_h1200.m) | [qcam_raw_rolera_w696_h520.m](config/Ephus/qcam_raw_rolera_w696_h520.m) |
| Exposure | 20 ms | **38 ms** |
| Spatial bin factor | 8 | **4** |
| Resulting frame | 200 × 150 px | **174 × 130 px** |
| QCam driver | `QCamInstaller-2-0-13-1-64bit.zip` | **same** |
| `namingScheme` default | `'XSG'` | `'XSG'` |

Frame size follows the same rule on both rigs, against each camera's hardcoded sensor size:

```matlab
% Sutter / Retiga 2000R          % Scientifica / Rolera-XR
width  = 1600 / 8 = 200;         width  = 696 / 4 = 174;
height = 1200 / 8 = 150;         height = 520 / 4 = 130;
```

`namingScheme` is **`'XSG'` on both rigs**. It is not saved in `qcam.settings`, so the `.m`
default governs — if a restored `qcam.m` comes up naming files manually, check this line.

## Hardware

### Camera

- QImaging FireWire (IEEE 1394) camera — model per rig, see above
- Connected **directly to the acquisition computer over FireWire** — the image data path does not
  pass through the DAQ
- The camera's **trigger input** is driven by a **QCam board**, which in turn is driven by the
  NI USB-6229 (`Dev2`)

### Signal path

```
Ephus stimulator "Camera trigger" (Dev2 / USB-6229, AO3)
    → QCam board
    → camera trigger input                (frame timing)

camera → FireWire (IEEE 1394) → acquisition computer   (image data)
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
| `Green LED output check` | Analog in | `AI17` | LED output monitor — **Sutter only**, not connected on the Scientifica rig |
| `sound output check` | Analog in | `AI16` | Sound output monitor |

The analog output assignments are the same on both rigs. See:
[Configuration → Ephus startup file](configuration.md#startup-file) for the full channel list,
and [DAQ wiring](wiring_scientifica.md) for the Scientifica rig terminal by terminal.

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

| Setting | Sutter | Scientifica |
|---|---|---|
| Exposure | `20` (ms) | `38` (ms) |
| Spatial bin factor | `8` | `4` |
| External | checked (external trigger mode) | checked |

**Exposure** is entered in milliseconds and must not exceed the trigger ISI — both 20 ms and
38 ms fit within the 50 ms ISI of the 20 Hz train.

**Spatial bin factor** divides the full sensor when `fullview` is enabled:

```matlab
width  = <sensor width>  / binFactor;
height = <sensor height> / binFactor;
```

giving **200 × 150 px** on the Sutter rig and **174 × 130 px** on the Scientifica rig. Binning
trades spatial resolution for signal-to-noise and frame rate, which suits widefield mapping — the
goal is locating subfield boundaries, not resolving individual cells.

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

`qcam.m` **hardcodes the camera resolution**, so **each rig needs the variant matching its own
camera**:

| Rig | Camera | `qcam.m` variant | Resolution |
|---|---|---|---|
| Sutter | Retiga 2000R | [qcam_mod_retiga_w1600_h1200.m](config/Ephus/qcam_mod_retiga_w1600_h1200.m) | 1600 × 1200 |
| Scientifica | Rolera-XR | [qcam_raw_rolera_w696_h520.m](config/Ephus/qcam_raw_rolera_w696_h520.m) | 696 × 520 |

On the rig the file is deployed as:

```
C:/Rig/Ephus 2013b/Programs/qcam/qcam.m
```

i.e. `Ephus 2013b` &rarr; `Programs` &rarr; `qcam` &rarr; `qcam.m` — the same path on both rigs.
The copies above carry descriptive names only so the two can be told apart in this repo;
**rename the rig's variant to `qcam.m` when deploying**.

> **Restore hazard.** Copying Ephus between the two rigs, or restoring from the wrong backup,
> overwrites `qcam.m` with the other camera's resolution and **silently crops or over-runs the
> field of view**. This has already happened once on the Sutter rig. Always confirm the
> resolution after restoring Ephus.

### Changes between the two variants

The two variants are **otherwise identical** — the resolution appears in three code locations,
plus a header changelog entry, and nothing else differs. The example below is the Retiga variant
(the Rolera variant carries 696 / 520 in the same places):

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

- **QCam driver v2.0.13.1, 64-bit** — `QCamInstaller-2-0-13-1-64bit.zip`. **The same driver serves
  both cameras**, on both rigs
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
