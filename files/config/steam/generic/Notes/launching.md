# Steam
## Wayland Launch Options/Arguments
### Unsorted List
 - `SDL_VIDEODRIVER=wayland`
 - `PROTON_ENABLE_WAYLAND=1`

### Gamescope
 - `PULSE_SINK=out_game gamescope -h 1080 -H 1080 -w 1920 -W 1920 -r 144 -f -- %command%`

### Enable TearFree Equivalent
 - `__GL_SYNC_TO_VBLANK=0 %command%`

### Generic Proton Env Variables
 - `PROTON_ENABLE_FSYNC=1 DXVK_ASYNC=1`
