# live_wallpaper_config_update()
---
`live_wallpaper_config_update(rgb)`

An internal function that attempts to call `global.live_wallpaper_callback` if it's been set. 

***You probably don't need to use this***

Returns: Nothing

## Usage

This code tries to call `global.live_wallpaper_callback` using this function. 

```gml
live_wallpaper_config_update();
```