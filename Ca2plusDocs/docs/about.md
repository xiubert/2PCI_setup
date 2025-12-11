# About This Documentation

## Purpose

This documentation provides comprehensive information for operating and maintaining the Sutter 2P microscopy system for in vivo 2-photon calcium imaging (2PCI). It serves as a reference for:

- System setup and configuration
- Daily operation procedures
- Troubleshooting and maintenance
- Custom software configurations

## System Overview

### Hardware

The rig is built around a **Sutter MOM (Moveable Objective Microscope)**, which features a moveable objective rather than a moveable stage (unlike the Scientifica rig configuration).

**Key Components:**

- Sutter MOM microscope
- Sutter ROE-200 micromanipulator
- Two National Instruments DAQ boards:
    - NI USB-6299 (Dev2) - Ephus acquire/sound stimulation
    - NI PCI-6110 with BNC-2090A breakout (Dev1) - ScanImage 2P
- Hamamatsu PMT (H10770PA-40)
- 2-photon laser system

### Software Stack

- **Ephus**: Data acquisition and stimulus delivery
- **ScanImage**: 2-photon microscopy control
- **MATLAB**: Runtime environment for both systems
- **Custom user functions**: Automated workflows and experiment control

## Documentation Structure

This documentation is organized into several key sections:

### Setup Documentation
- **[Hardware](hardware.md)**: Detailed specifications and wiring diagrams
- **[Software](software.md)**: Software requirements and installation
- **[Drivers](drivers.md)**: Required drivers and compatibility information
- **[Computer Setup](computer_setup.md)**: System configuration and optimization

### Configuration
- **[Configuration](configuration.md)**: Ephus and ScanImage configuration files with detailed parameter explanations

### Operational Procedures
- **[Alignment](alignment.md)**: Step-by-step laser alignment procedures with safety protocols
- **[Calibration Procedures](cal_laser_power.md)**: Laser power and speaker calibration
- **[Pupillometry](pupillometry.md)**: Pupil tracking configuration

### Development
- **[Code](code.md)**: Custom MATLAB functions and user scripts

## Key Features

### Synchronized Acquisition

The system uses two DAQ boards synchronized via:

- Trigger routing: Dev2 &rarr; Dev1 via PFI connections
- Sample clock sharing for precise temporal coordination
- Custom user functions for automated experiment control

### Custom User Functions

The documentation includes several custom MATLAB functions for:

- Saving stimulus pulse details
- Random pulse selection (with/without replacement)
- Camera reset automation
- Pulse train generation

### Safety Protocols

Comprehensive safety information including:

- Laser safety glasses specifications (LG8 for 690nm, LG9 for 920nm)
- Alignment procedures with proper protective equipment
- Power monitoring and control

## Maintenance & Support

**Primary Technical Contact:**

- Rick Ayer, Sutter Instruments
- Email: rick@sutter.com

### Known Issues

- **Herringbone artifact**: Normal for End-On Hamamatsu PMT configuration
- See individual documentation pages for specific troubleshooting

## Contributing

This documentation is maintained as a living document. Updates should include:

- Configuration file changes with date stamps
- New procedures or workflow improvements
- Troubleshooting solutions for common issues
- Hardware or software modifications

## Version History

Last updated: December 11, 2025
