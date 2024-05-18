# global.live_wallpaper_callback
---
`global.live_wallpaper_callback`

A global variable that the user should replace with a function, to be called whenever the configuration updates

| Name | Type | Description |
| - | - | - | 
| `config` | Struct | The current wallpaper config |

Returns: Nothing

## Usage

```gml
function scr_handle_wallpaper_config_change(config) {
    if (config[$ "display"]) {
        ...
    }
}

global.live_wallpaper_callback = scr_handle_wallpaper_config_change;
```