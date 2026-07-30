# Software

## OS
- WINDOWS 10 (21H2 x64)

## Network
- Globus (for data backup): `globusconnectpersonal-latest.exe`
- Global Protect (for connecting to PittNet): `WIN-GlobalProtect64-6.2.7.msi`

## Matlab
- [Downloads](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)
- For Ephus 2.1.0: Matlab 2013b 32bit
- For ScanImage 5.3.1 / 2017: Matlab 2015b x64

## Ephus
- Use: Widefield imaging and sound stimulus delivery
- Version: 2.1.0
- Widefield acquisition uses the built-in `qcam` program (32-bit `qcammex.mexw32` interface to the QCam API, hence MATLAB 2013b 32-bit)
- See: [Widefield Epifluorescence](widefield.md)

## MaiTai laser control
- Use: laser on/off, shutter, wavelength, and status monitoring
- The MaiTai has **no front-panel controls** for these &mdash; the GUI is how the laser is operated
- Software: `MaiTai Customer GUI 1.03.01 (1).zip` &rarr; `MaiTai Customer GUI SW077-1.03.01/setup.exe` (Spectra-Physics part no. SW077)
- Driver: `maitai_mks_usb_comm_CP210x_VCP_Windows.zip` &rarr; `CP210xVCPInstaller_x64.exe` (Silicon Labs CP210x Virtual COM Port)
- The GUI talks to the laser over a virtual COM port created by the CP210x driver, so **install the driver first**
- See: [Drivers &rarr; Laser](drivers.md#laser) and [Rig Setup &rarr; Laser Control Software](computer_setup.md#laser-control-software)

## ScanImage
- Use: 2P
- Version: 5.3.1 / 2017
- [Docs](https://archive.scanimage.org/SI2017/index.html)
- Docs also at: Sharepoint (Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr; `sutter_2P_rigConfig_PAC` &rarr; `scanimage_5-3-1_2017_docs.zip`)
