# Troubleshooting

General recovery steps when the rig stops talking to its hardware — Ephus or ScanImage failing to
find a DAQ, a serial device refusing to open, or the widefield camera not responding.

**Work through these in order.** They escalate from cheapest to most disruptive, and a restart
often hides the actual cause, so leave it until last.

For problems with a known specific cause, skip ahead to
[Symptoms with a documented fix](#symptoms-with-a-documented-fix).

## 1. Refresh the DAQs in NI MAX

Open **NI MAX** (Measurement & Automation Explorer) and refresh **Devices and Interfaces**.

Both rigs use the same two boards, and **both are referenced by name** in the configuration files:

| Device | Model | Used by |
|---|---|---|
| `Dev1` | NI PCI-6110 (BNC-2090A breakout) | ScanImage — galvos, PMTs, shutter |
| `Dev2` | NI USB-6229 | Ephus — sound, LEDs, camera trigger |

**Confirm the names are still `Dev1` and `Dev2` after the refresh.** If a board re-enumerates
under a different name, nothing will work even though the hardware is present — the Ephus startup
file addresses the board as `/dev2/...` and by `acqBoardIDs` / `stimBoardIDs`, and the ScanImage
machine data file as `deviceNameAcq = 'Dev1'`. Rename the device back in NI MAX rather than
editing the configs.

A **self-test** in NI MAX confirms the board itself is healthy.

See: [Configuration](configuration.md), [Drivers](drivers.md#imaging) (NI-DAQmx v15.5.0).

## 2. Disconnect and reconnect the USB DAQ

Only the **USB-6229 (`Dev2`)** is external — the PCI-6110 (`Dev1`) is an internal card and cannot
be reseated this way.

So this step only addresses **Ephus-side** faults: sound output, LED drivers, the camera trigger.
If the symptom is on the ScanImage side (galvos, PMTs), this will not help.

After reconnecting, **repeat step 1** and confirm the board still enumerates as `Dev2`.

## 3. Close other programs holding COM ports

Serial devices are opened **exclusively** — whichever program gets there first keeps the port, and
everything else fails to connect. Close anything that might be holding one.

| Rig | Program | Ports it can hold |
|---|---|---|
| Scientifica | **LinLab 2** | `COM3` beam attenuator, `COM4` XYZ stage, `COM5` condenser |
| Both | **MaiTai Customer GUI** | the laser's CP210x virtual COM port |
| Both | Camera / other vendor UIs | whatever they were configured for |

**On the Scientifica rig this is the common one.** LinLab 2 holds its ports exclusively, so
ScanImage cannot open the stage on `COM4` while LinLab is running — and LinLab cannot open the
attenuator on `COM3` while ScanImage holds it. Close whichever one you are not using.

If a MATLAB attempt already failed, it may have left a stale handle on the port. In MATLAB:

```matlab
delete(instrfind); clear s
```

Ports can also **renumber** after being unplugged into a different USB socket. If a device is
simply gone rather than busy, re-identify it and pin the number in
Device Manager &rarr; Port Settings &rarr; Advanced &rarr; COM Port Number.

See: [Sutter COM ports](setup_sutter.md#com-port-assignments) ·
[Scientifica COM ports](setup_scientifica.md#com-port-assignments) ·
[Re-identifying the ports](wiring_scientifica.md#61-how-to-re-identify-the-ports)

## 4. QCam / Ephus — power-cycle the camera and QCam board

If the fault is the widefield camera:

1. Turn the **camera** off and back on.
2. Turn the **QCam board** off and back on.
3. **Turn the camera board on before launching Ephus** — Ephus expects it to be present at
   startup.
4. Verify with `startQCam` in MATLAB 2013b.

The QCam board is what receives the 5 V TTL camera trigger from `Dev2` `AO3`, so a board that is
off or wedged shows up as a camera that never captures frames even though Ephus reports no error.

See: [Widefield Epifluorescence](widefield.md) ·
[Rig Setup &rarr; QCam testing](computer_setup.md#software-installation)

## 5. Restart the computer

Last resort. It clears stale driver state, orphaned serial handles and locked ports in one go —
which is also why it hides the cause. If a restart is needed regularly, note what was running
beforehand and work back through steps 1–4.

---

## Symptoms with a documented fix

| Symptom | Cause | Where |
|---|---|---|
| Herringbone pattern in the image (Sutter) | Normal for the End-On Hamamatsu PMT; strength is periodic in gain | [Hardware &rarr; Herringbone artifact](hardware_sutter.md#herringbone-artifact) |
| Comb / split artifact across the image | Fast galvo overdriven; scan phase wandering | [Appendix &rarr; If the comb artifact reappears](appendix_galvo_scan_settings.md#if-the-comb-artifact-reappears) |
| Widefield frame cropped or the wrong size | Wrong `qcam.m` for the installed camera | [Widefield &rarr; qcam.m modification](widefield.md#qcamm-modification) |
| Camera stops capturing between loop iterations | `External` needs re-arming each iteration | [Widefield &rarr; Looping](widefield.md#looping) |
| ScanImage drives the beam attenuator instead of the stage (Scientifica) | `motors(1).comPort` left at `3`; must be `4` | [Configuration &rarr; Per-rig differences](configuration.md#per-rig-differences) |
| Machine unrecoverable, or software state badly broken | — | [Disk backups (VHD)](vhd_backup.md) |
