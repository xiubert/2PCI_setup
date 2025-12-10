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
- For 2P laser alignment at 920nm: LG9 (orange lens):
    - Wavelength coverage: 610-695nm AND >740-1070nm (covers 920nm)
    - Optical Density (OD): 7+ at 920nm
    - Visible Light Transmission (VLT): 44%
    - EN 207 Rating: D LB6 + IRM LB7 in the >740-1070nm range
    - **LG8 series does NOT cover 920nm**

## Coarse Alignment Process

### Prerequisites:
- Wear LG8 safety glasses during alignment
- **Ensure bolts to table are secure**

### Steps
1. Set laser wavelength to 920nm
2. Adjust [Optic Rotation Mount (Newport RSP-1T)](https://www.newport.com/p/RSP-1T) so that power meters for both Scientifica and Sutter read about 50% (even split between 2 rigs)
3. Slightly loosen post bolt of barrel at first split and twist such that both meters are at max for 50% split
4. Tighten down barrel post bolt
5. Ensure beam passes uninterrupted through shutter to 90deg mirrors
6. **Adjusting 90deg mirrors: ignore the screw on the corner (middle screw at 90deg angle)**
    - Top screw: up / down
    - Bottom screw: left / right

### Key Points
- **Last stage at which beam is focal dot**: The horizontal enclosure (not the one labeled MOM) before the galvos (see [tutorial video](https://www.youtube.com/watch?v=hwCFtQ3WHoo&t=452)) — beam expands after that
- **After laser reaches objective**: For further alignment, adjust mirror closer to the laser (further from objective) for more angular movement

## Fine Alignment Using Pollen Grains

### Initial Setup
1. Select a spikey pollen grain at 40X (via pollen grain slide) as your alignment target
2. Navigate to the **top surface** of the pollen grain
3. Enable the crosshair (right-click on image)
4. Display the histogram

### Histogram Settings
- **Left edge of histogram bar**: Position at peak (should be near zero)
- **Right edge**: Balance for good background noise contrast

### Alignment Check
1. Focus through the pollen grain from top to bottom
2. Monitor whether the pollen grain remains centered on the crosshair
   - **If centered throughout**: Laser is properly aligned ✓
   - **If drifts off center**: Adjustment needed → Use the mirror **closest to the laser**

### Beam Walking (if intensity drops)
If you experience intensity loss, "walk the beam" back:
- Adjust **one direction on the first mirror**
- Compensate in the **opposite direction on the second mirror**
  - Example: Right on first mirror → Left on second mirror
- This keeps the beam **parallel** while translating it laterally

**Why walk the beam?**
- Adjusting only one mirror changes the beam **angle**
- Adjusting both mirrors together translates the beam **position** without changing angle
- Proper alignment ensures the beam only moves in **Z (focus)**, not X-Y, when focusing

### Goal
The beam should remain stationary in X-Y position while scanning through the Z-axis (focus).

# Log
- 12/9/2025
