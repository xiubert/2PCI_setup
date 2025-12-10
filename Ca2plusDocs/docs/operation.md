# Operation

## Ephus
- **Ephus should be configured to save the xsg file**. This can be loaded as a mat file that contains the state of Ephus during the acquisition. It contains a structure called header which contains the pulse info and gain along with the actual stimulus trace​

### Configuration hotswitches
- Save configuration settings for program windows regarding recording and stimulation settings
- See: 
    - Programs &rarr; hotswitch
    - Programs &rarr; hotswitch: hs_config

- Located in `C:/Rig/Ephus 2013b/hotswitches`


### Looping
1. Programs &rarr; LoopGui
2. Set number of iterations
3. Set interval time between iterations
4. Ensure stimulator and acquirer are set to external and use PFI9 for triggering

## ScanImage

### Looping (cycles)

Cycles allow multiple iterations with defined delays between acquisitions. Cycles are saved in: `C:\Rig\Scanimage5-3\cycles`

**Setup procedure:**

1. View &rarr; **Cycle Controls** to open cycle configuration (CYCLE-MODE CONTROLS)
2. Check **Cycle mode on**
3. Load existing cycle or save new cycle configuration

**Configuring iterations:**

Multiple iterations can exist for each cycle, with each iteration preceded by a defined **Iteration Delay**.

**Example: 1 cycle with 4 iterations, each with 120s delay**

1. Click **>>** for cycle iteration data
2. **Cycles done:** displays `X of 1`
3. Add **4 iterations**
4. Enter `131` in **Iteration delay** field and press Enter
    - Calculation: Frame collection time (~11s for 50 frames at 5 Hz) + desired delay (120s) = 131s total
5. Check **Restore original cfg**
6. Check **Auto-reset iteration/count**
7. Click **CYCLE** to begin cycle

**Note:** There is a timing delay of ~97-99ms (occasionally up to 700ms) between the ScanImage acquisition start message (e.g., "Starting '1 x zoom 5 Hz' at 6/13/2018 12:33:16.136") and the `acquisitionStarted` timestamp in the `digtrig_stim` user function.
