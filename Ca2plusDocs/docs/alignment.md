# Aligning 2P Laser to Sutter 2P Rig

![Sutter 2P Rig](tz_2p.jpeg)

- Best person to contact: Rick Ayer of Sutter Instruments: rick@sutter.com
- Herringbone artifact is normal for End-On [Hamamatsu PMT H10770PA-40](https://www.hamamatsu.com/us/en/product/optical-sensors/pmt/pmt-module/current-output-type/H10770PA-40.html)

## References
- [Sutter 2P Alignment Tutorial Video](https://www.youtube.com/watch?v=hwCFtQ3WHoo&t=452)

## Safety
- [Safety glasses (Thorlabs)](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=762)
- For 2P laser alignment at 690 nm: LG8 (green lens):
    - **LG8 series does NOT cover 920 nm**
        - Wavelength coverage: Only 630-695 nm (stops at 695 nm)
        - Does not provide protection at 920 nm ❌
    - Higher OD (5+ vs 3+) provides better protection during alignment
    - Still has reasonable VLT (24%) for seeing your alignment
    - The slightly reduced visibility compared to LG9 is worth the extra 2 OD levels of protection
- For 2P laser alignment at 920 nm: LG9 (orange lens):
    - Wavelength coverage: 610-695 nm AND >740-1070 nm (covers 920 nm)
    - Optical Density (OD): 7+ at 920 nm
    - Visible Light Transmission (VLT): 44%
    - EN 207 Rating: D LB6 + IRM LB7 in the >740-1070 nm range
    - **LG8 series does NOT cover 920 nm**

## Key Points
- **Last stage at which beam is a focal dot**: The horizontal enclosure (not the one labeled MOM) before the galvos (see [tutorial video](https://www.youtube.com/watch?v=hwCFtQ3WHoo&t=452)) — beam expands after that point
- **Adjusting 90° mirrors: ignore the screw on the corner (middle screw at 90° angle)**
    - Top screw: up/down
    - Bottom screw: left/right
- **After laser reaches objective**: 
    1. For [angular alignment](#angular-alignment-z): Adjust the mirror closer to the laser (further from objective) at 920 nm and align pollen across the Z-axis.
    2. For [translational alignment](#translational-alignment-x-y) in center of objective: Use crosshair objective adapter (in alignment case). Either a) adjust mirror(s) closest to objective ([see Option A](#option-a-adjust-mirror-closest-to-objective)) or b) walk the beam ([see Beam Walking](#option-b-beam-walking)) 
    3. Re-check angular alignment after translational alignment and make any subtle changes if needed.


## Fine Alignment Using Pollen Grains

### Initial Setup
- Use LG9 orange lens safety glasses
1. Select a spiky pollen grain at 40X (via pollen grain slide) as your alignment target with epifluorescence (LED + QCam)
2. Navigate to the **top surface** of the pollen grain under 2P with both green and red channels enabled
3. Enable the crosshair in ScanImage (right-click on image)
4. Display the histogram (right-click on image)
    - Histogram Settings
        - **Left edge of histogram bar**: Position at peak (should be near zero)
        - **Right edge**: Balance for good background noise contrast

### Alignment Check
1. Focus through the pollen grain from top to bottom along the Z-axis
2. Monitor whether the pollen grain remains centered on the crosshair
    - **If centered through Z-axis**: Laser angle is properly aligned and reaches sample at a reasonably orthogonal orientation ✓
    - **If drifts off center through Z-axis**: Angular adjustment needed → Use the mirror **closest to the laser** ([see angular alignment](#angular-alignment-z))
3. Monitor whether the brightness of the pollen grain changes when it is moved around X-Y with the objective (on Sutter) or stage (on Scientifica Rig)
    - **If brightness consistent across X-Y axes**: Laser is centered in the objective ✓
    - **If brightness changes across X-Y axes**: Translational adjustment needed → see [Translational alignment](#translational-alignment-x-y)

### Angular Alignment (Z)
- Done at 920 nm (Use LG9 orange lens safety glasses)
- **Goal**: The beam should remain stationary in X-Y position while scanning through the Z-axis (focus). This will ensure pollen grain remains focused through the Z-axis.
- **If pollen grain drifts off center through Z-axis**: Make slight adjustments using the mirror **closest to the laser** 

### Translational Alignment (X-Y)
- **CRITICAL**: First use PRM1Z8 (controlled via jog wheel near Sutter Rig) to adjust power to the lowest setting at 920 nm to avoid burning anything in the beam path
- Done at 690 nm (Use LG8 green lens safety glasses)
- Requires crosshair objective adapter in alignment case (want beam to fill the center of the crosshair projected from adapter onto white paper)

#### OPTION A: Adjust Mirror Closest to Objective
- Assumes laser angle is aligned, thus the mirror closest to the objective should allow translational changes along X-Y axes without drastic changes to laser angle
- Adjust mirror closest to objective so that laser fills the center of the crosshair through crosshair objective
- May need to make subtle re-adjustments to the laser angle (see above)

#### OPTION B: Beam Walking

If you experience intensity loss, "walk the beam":

- Adjust **one direction on the first mirror**
- Compensate in the **opposite direction on the second mirror**
  - Example: Right on first mirror → Left on second mirror
- This keeps the beam **parallel** while translating it laterally

**Why walk the beam?**

- Adjusting only one mirror changes the beam **angle**
- Adjusting both mirrors together translates the beam **position** without changing angle
- Proper alignment ensures the beam only moves in **Z (focus)**, not X-Y, when focusing


## Coarse Alignment Process (ONLY IF POLLEN GRAIN NOT VISIBLE)

### Prerequisites
- Wear LG9 safety glasses during alignment
- **Ensure bolts to table are secure**

### Steps
1. Set laser wavelength to 920 nm (use LG9 orange lens safety glasses)
2. Adjust [Optic Rotation Mount (Newport RSP-1T)](https://www.newport.com/p/RSP-1T) so that power meters for both Scientifica and Sutter read approximately 50% (even split between 2 rigs)
3. Slightly loosen post bolt of barrel at first split and twist until both meters are at maximum for 50% split
4. Tighten down barrel post bolt
5. Ensure beam passes uninterrupted through shutter to 90° mirrors


## Log
- 1/20/2025