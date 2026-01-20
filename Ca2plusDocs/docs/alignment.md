# Aligning 2P laser to Sutter 2P rig

![Sutter 2P Rig](tz_2p.jpeg)

- Best person to contact: Rick Ayer of Sutter Instruments: rick@sutter.com
- Herringbone artifact normal for End-On [Hammamatsu PMT H10770PA-40](https://www.hamamatsu.com/us/en/product/optical-sensors/pmt/pmt-module/current-output-type/H10770PA-40.html)

## References
- [Sutter 2P Alignment Tutorial Video](https://www.youtube.com/watch?v=hwCFtQ3WHoo&t=452)

## Safety
- [Safety glasses (Thorlabs)](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=762)
- For 2P laser alignment at 690nm: LG8 (green lens):
    - **LG8 series does NOT cover 920nm**
        - Wavelength coverage: Only 630-695nm (stops at 695nm)
        - Does not provide protection at 920nm ❌
    - Higher OD (5+ vs 3+) provides better protection during alignment
    - Still has reasonable VLT (24%) for seeing your alignment
    - The slightly reduced visibility compared to LG9 is worth the extra 2 OD levels of protection
- For 2P laser alignment at 920 nm: LG9 (orange lens):
    - Wavelength coverage: 610-695nm AND >740-1070nm (covers 920nm)
    - Optical Density (OD): 7+ at 920nm
    - Visible Light Transmission (VLT): 44%
    - EN 207 Rating: D LB6 + IRM LB7 in the >740-1070nm range
    - **LG8 series does NOT cover 920nm**

## Key Points
- **Last stage at which beam is focal dot**: The horizontal enclosure (not the one labeled MOM) before the galvos (see [tutorial video](https://www.youtube.com/watch?v=hwCFtQ3WHoo&t=452)) — beam expands after that
- **After laser reaches objective**: 
    1. For [angular alignment](#angular-alignment-z): adjust mirror closer to the laser (further from objective) at 920 nm and try to align pollen across Z-axis.
    2. For [Translational alignment](#Translational-alignment-x-y) in center of objective use crosshair objective adapter (in alignment case). Either a) walk beam ([see Beam Walking](#option-a-beam-walking)) or b) adjust mirror(s) closest to objective ([see Option B](#option-b-adjust-mirror-closest-to-objective))


## Fine Alignment Using Pollen Grains

### Initial Setup
- Use LG9 orange lens safety glasses
1. Select a spikey pollen grain at 40X (via pollen grain slide) as your alignment target with epifluorescence (LED + QCam)
2. Navigate to the **top surface** of the pollen grain under 2P with both green and red channels enabled
3. Enable the crosshair in ScanImage (right-click on image)
4. Display the histogram (right-click on image)
    - Histogram Settings
        - **Left edge of histogram bar**: Position at peak (should be near zero)
        - **Right edge**: Balance for good background noise contrast

### Alignment Check
1. Focus through the pollen grain from top to bottom through Z-axis
2. Monitor whether the pollen grain remains centered on the crosshair
   - **If centered through Z-axis**: Laser angle is properly aligned and reaches sample at a reasonably orthogonal orientation ✓
   - **If drifts off center through Z-axis**: Angular adjustment needed → Use the mirror **closest to the laser** ([see angular alignment](#angular-alignment-z))
3. Monitor whether the brightness of the pollen grain changes if it is moved around X-Y with objective (on Sutter) or stage (on Scientifica Rig)
   - **If brightness consistent about X-Y axes**: Laser is centered in the objective ✓
   - **If brightness changes about X-Y axes**: Translational adjustment needed → see [Translational alignment](#Translational-alignment-x-y)

### Angular alignment (Z)
- Done at 920 nm (Use LG9 orange lens safety glasses)
- **Goal**: The beam should remain stationary in X-Y position while scanning through the Z-axis (focus).
- **If drifts off center through Z-axis**: Make slight adjustments using the mirror **closest to the laser** 



### Translational alignment (X-Y)
- **CRITICAL**: First use PRM1Z8 (controlled via jog wheel near Sutter Rig) to adjust power to lowest setting at 920 nm to avoid burning anything in the beam path
- Done at 690 nm (Use LG8 green lens safety glasses)
- Requires crosshair objective adapter in alignment case (want beam to fill around center of the cross hair projected from adapter to white paper)

#### OPTION A: Beam Walking
If you experience intensity loss, "walk the beam":
- Adjust **one direction on the first mirror**
- Compensate in the **opposite direction on the second mirror**
  - Example: Right on first mirror → Left on second mirror
- This keeps the beam **parallel** while translating it laterally

**Why walk the beam?**
- Adjusting only one mirror changes the beam **angle**
- Adjusting both mirrors together translates the beam **position** without changing angle
- Proper alignment ensures the beam only moves in **Z (focus)**, not X-Y, when focusing

#### OPTION B: Adjust mirror closest to objective
- Assumes laser angle is aligned, thus mirror closest to the objective should allow translational changes about X-Y without drastic changes to laser angle
- Adjust mirror closest to objective such that laser fills center of cross hair through crosshair objective
- May need to make subtle re-adjustments to the laser angle (see above)


## Coarse Alignment Process (ONLY IF POLLEN GRAIN NOT VISIBLE)

### Prerequisites:
- Wear LG8 safety glasses during alignment
- **Ensure bolts to table are secure**

### Steps
1. Set laser wavelength to 920 nm (use LG9 orange lens safety glasses)
2. Adjust [Optic Rotation Mount (Newport RSP-1T)](https://www.newport.com/p/RSP-1T) so that power meters for both Scientifica and Sutter read about 50% (even split between 2 rigs)
3. Slightly loosen post bolt of barrel at first split and twist such that both meters are at max for 50% split
4. Tighten down barrel post bolt
5. Ensure beam passes uninterrupted through shutter to 90&deg; mirrors
6. **Adjusting 90&deg; mirrors: ignore the screw on the corner (middle screw at 90&deg; angle)**
    - Top screw: up / down
    - Bottom screw: left / right

# Log
- 1/20/2025
