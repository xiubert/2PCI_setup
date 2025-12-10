# Hardware on Sutter 2P rig for in vivo 2PCI (2 Photon Calcium Imaging)

## Computer:

## Microscope:
- Sutter MOM (Moveable Objective Microscope): https://www.sutter.com/microscopes/mom
- Objective moves rather than the stage (stage moves on Scientifica rig)

## Micromanipulator:
- Sutter ROE-200

## DAQs:
1. NI USB-6299 (ID: `Dev2`)
    - Ephus acquire / sound stimulation
2. NI PCI-6110 (BNC-2090A breakout) (ID: `Dev1`)
    - ScanImage 2P:
        - Galvo Mirrors (Channels: `AO0`,`AO1`)​
        - PMT (Channels: `AI8`, `AI9`)
        - Shutter (Channels: `USER 1`)
        - Trigger output to trigger Ephus sound delivery (Channels: `USER 2`)
            - Path: `PFI13` (Digital I/O PFI terminal block) &rArr; `USER 2` &rArr; BNC cable &rArr; NI USB 6229 &rArr; PFI0/P1.0​ &rArr; PFI10 (terminal block)