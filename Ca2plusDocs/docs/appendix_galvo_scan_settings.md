# Appendix — Galvo scan settings

Why the two rigs reach the same 5 Hz acquisition at different zoom factors, and how to choose or
repair frame-scan settings on the LinScanner (galvo-galvo) system.

**Both rigs acquire at 5 Hz by default, at 256 × 256.** The Sutter rig does this at **1x** zoom.
The Scientifica rig's galvos cannot sustain it at 1x, and run at **1.5x**.

## The constraint

On a galvo-galvo system the fast (X / line) galvo must physically complete one sweep every **line
period**. Drive it too fast and it lags the commanded waveform in a position-dependent way, so a
single bidirectional **Scan Phase** value can no longer correct the whole line. The result is the
**comb / split artifact** at the line turnarounds, and Auto Adjust returns a *wandering* phase
value instead of a stable one.

**Rule of thumb: keep the line period ≳ 1 ms at 1x zoom.**

### Governing relationships

```
Line Period  = (Pixels/Line × Pixel Dwell) / Fill Fraction
Frame Rate   = 1 / (Lines/Frame × Line Period)
Pixel Dwell  = Pixel Bin Factor / Sampling Rate      (e.g. 8 / 5 MHz = 1.6 µs)
```

**Pixels/Line sets the line period; Lines/Frame multiplies it.** So to go faster *without*
overdriving the galvo, reduce **Lines/Frame (Y)** or shrink the field of view — never shorten the
line period by cutting Pixels/Line.

Zoom does **not** change the line period. It reduces the scan *amplitude* the fast galvo must
sweep, which lowers peak velocity and turnaround acceleration — that is what brings a short line
period back inside the galvo's limits.

## Why the Scientifica rig runs at 1.5x

At 256 × 256 the line period is ~781 µs. On the Scientifica rig that overdrives the fast galvo at
1x and produces the comb artifact. Zooming in fixes it without changing sampling or frame rate.

**Galvo stress proxy** (scan amplitude ÷ line period; higher is harder on the galvo):

| Config | Zoom | Line period | Proxy | Status |
|---|---|---|---|---|
| 512² survey | 1x | 1.56 ms | 0.64 | safe (confirmed) |
| Functional | 2x | 0.781 ms | 0.64 | safe (confirmed) |
| **Functional** | **1.5x** | **0.781 ms** | **0.85** | **verified working — the default** |
| Original | 1x | 0.781 ms | 1.28 | comb artifact (confirmed broken) |

**1.5x is the default because it maximises recording area while staying clear of the artifact** —
about 33% more field width (~1.8× the area) than 2x, for the same frame rate. It is a thinner
margin than 2x, so **2x is kept as a conservative fallback** if the galvo's behaviour changes,
e.g. after a service or an environmental change.

Frame rate is ~5 Hz at either zoom, since zoom does not change the line period. The choice is
purely field of view versus galvo margin.

> **MROI is Premium-gated in ScanImage 5.3**, so arbitrary ROIs are not available — **zoom is the
> field-of-view tool.** Speed comes from a smaller field, not a shorter line period.

## If the comb artifact reappears

1. Click **Auto Adjust** on **Scan Phase (µs)**. This should resolve the artifact across the whole
   field of view.
2. Confirm the phase **settles to a single stable value** that corrects edge-to-edge, rather than
   wandering.
3. If it still persists, temporarily switch to **unidirectional** scanning as a diagnostic. If the
   smear vanishes, it is a bidirectional-phase problem tied to galvo tracking — the line period is
   still too aggressive, so fall back to **2x**.

## Getting 10 Hz

The 10 Hz configurations **halve Lines/Frame to 128**, keeping Pixels/Line at 256. This doubles
the frame rate without touching the line period, so it costs nothing in galvo margin — it simply
scans half as many lines. Pixels are no longer square: the field is full width but half height.

Used for spontaneous cell recordings.

## Checklist for any config change

1. Set Zoom, Pixels/Line, Lines/Frame, Dwell, Fill Fraction.
2. Confirm ScanImage's **reported line period is ≳ 1 ms** (at 1x especially).
3. Let ScanImage's **reported frame rate** be the arbiter — frame flyback (0.115 ms) and scanfield
   flyto (1.0 ms) shave a little off the ideal `1 / (lines × line period)` arithmetic.
4. Re-run **Auto Adjust** on Scan Phase after the change, and confirm it settles.

## Other operating points

Recorded for reference; neither is the default on either rig.

**Survey / anatomy — 512 × 512 at 1x, ~1.25 Hz.** Full field, slow, isotropic, 1.56 ms line
period. Use for morphology and slow z-stacks; too slow for functional imaging. A practical
workflow is a 512² reference image at 1x, then zoom in for functional acquisition.

**Full 1x field at 5 Hz.** Only if the whole 1x field is a hard requirement. Hold the line period
at ~1.56 ms and cut to 128 lines — either 128 × 128 with a 6.4 µs dwell (isotropic, half the
resolution, more signal per pixel) or 512 × 128 with the standard 1.6 µs dwell (4:1 anisotropic).
Both are usually more awkward downstream than simply zooming in.

## Configuration files

See [Configuration &rarr; ScanImage user settings](configuration.md#user-settings-and-configuration-files).
