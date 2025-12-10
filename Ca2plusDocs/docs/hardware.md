# Hardware
- Sutter 2P rig for in vivo 2PCI (2 Photon Calcium Imaging)

## Computer
- [Dell Precision Tower 5810](https://www.dell.com/support/manuals/en-us/precision-t5810-workstation/precision_t5810_om_pub/technical-specifications?guid=guid-cb1a5aa6-1e70-44b9-b690-59507a3a9f31&lang=en-us)
    - Intel Xeon CPU E5-1630 @ 3.70 GHz
    - 32.0 GB RAM
    - NVIDIA NVS 310 Graphics

## Microscope
- [Sutter MOM (Moveable Objective Microscope)](https://www.sutter.com/microscopes/mom)
- Objective moves rather than the stage (stage moves on Scientifica rig)
- dichroic splitter (Di02-R561, Semrock)
- green emission filter (FF03-525/50, Semrock)
- objective: 40 0.8 NA objective (Olympus)

## DAQs
1. [NI USB-6229](https://www.ni.com/en-us/support/model.usb-6229.html) (ID: `Dev2`)
    - Ephus acquire / sound stimulation
2. [NI PCI-6110](https://www.ni.com/en-us/support/model.pci-6110.html) ([BNC-2090A breakout](https://www.ni.com/en-us/support/model.bnc-2090a.html?srsltid=AfmBOopdQvoEFCozmqVA2Lt85ZS6px0Op_LTcsLxxTvu_3GcCVlb8_pU)) (ID: `Dev1`)
    - ScanImage 2P:
        - Galvo Mirrors (Channels: `AO0`,`AO1`)​
        - PMT (Channels: `AI8`, `AI9`)
        - Shutter (Channels: `USER 1`)
        - Trigger output to trigger Ephus sound delivery (Channels: `USER 2`)
            - Path: `PFI13` (Digital I/O PFI terminal block) &rArr; `USER 2` &rArr; BNC cable &rArr; NI USB 6229 &rArr; PFI0/P1.0​ &rArr; PFI10 (terminal block)

## PMT
- Controller: [Sutter PS-2LV](https://www.sutter.com/MICROSCOPES/pmt.html)
- [Hamamatsu H10770PA-40](https://www.hamamatsu.com/jp/en/product/optical-sensors/pmt/pmt-module/current-output-type/H10770PA-40.html)

## Shutter
- Controller: [ThorLabs SC10 Shutter Controller](https://www.thorlabs.com/thorproduct.cfm?partnumber=SC10)

## Galvo / Scan controller
- [Sutter MDR MOM Scan Drive Controller](https://www.sutter.com/microscopes/mom)
- Galvo / Galvo mirrors for laser scanning

## Laser
- MaiTai HP, Newport

## Speaker and Speaker controller
- freefield speaker (ES1, Tucker Davis)
- ED1 speaker driver (Tucker Davis)

## Micromanipulator
- [Sutter ROE-200](https://www.sutter.com/MICROMANIPULATION/mpc365_frame.html)

## Power Intensity Controller
- [ThorLabs Kinesis Motor Controller KDC101](https://www.thorlabs.com/thorproduct.cfm?partnumber=KDC101)
- Rotates [PRM1Z8](https://www.thorlabs.com/thorproduct.cfm?partnumber=PRM1Z8) to adjust laser intensity entering Sutter enclosure

## Temperature control
- FHC DC Temperature controller with heat pad and rectal thermister 
