# Disk backups (VHD)

Full-disk images of each rig's acquisition computer. Restoring one returns the hard disk to the
exact state it was in when the image was made — Windows, drivers, MATLAB, Ephus, ScanImage and
all rig configuration together.

This is the fast alternative to rebuilding a machine step by step; see
[Rig Setup](computer_setup.md) for the from-scratch install.

## Tool

[Disk2vhd](https://learn.microsoft.com/en-us/sysinternals/downloads/disk2vhd) (Sysinternals).

### Options used

| Option | Setting |
|---|---|
| Prepare for use in Virtual PC | **Checked** |
| Use Volume Shadow Copy | **Checked** |
| Use Vhdx | **Unchecked** |

- **Use Volume Shadow Copy** allows the image to be taken while Windows is running, from a
  consistent snapshot.
- **Use Vhdx must be left unchecked** — this produces the older `.VHD` format rather than
  `.VHDX`. All the images below are `.VHD`.

## Scope

These are **full disk backups**: every partition on the disk holding the `C:` drive, not the `C:`
volume alone. The system and boot partitions are therefore included, which is what allows a
restored disk to boot.

## Images

### Scientifica rig

Sharepoint: Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr;
`scientifica2P_backup` &rarr; `VHD backup`

| Image | State captured |
|---|---|
| `ANDERSON-PC_DISK0.VHD` | Windows 7, **before** the Windows 10 upgrade |
| `scientifica_rig_C_disk_win10_20260729.VHD` | Windows 10, 2026-07-29 |

### Sutter rig

Sharepoint: Tzounopoulos Lab (2024) &rarr; `Documents` &rarr; `data` &rarr; `PAC` &rarr;
`sutter2P_backup` &rarr; `vhd_backup`

| Image | State captured |
|---|---|
| `sutter_C_disk_win10_20260729.VHD` | Windows 10, 2026-07-29 |

## Restoring

Writing an image back restores the hard disk to the state at which the VHD was made. Anything
changed on the rig since that date — configuration edits, new user functions, acquired data still
on the machine — is lost, so capture what you need before restoring.

The Windows 7 Scientifica image predates the Windows 10 upgrade and is kept as a record of the
original rig; restoring it would undo that upgrade.
