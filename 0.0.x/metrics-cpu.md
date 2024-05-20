# CPU Metrics

Support for CPU metrics varies between platforms and is outlined in the following table

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `name` | Name/Model of the CPU | Yes | Yes | No |
| `num_logical_cores` | Number of logical cores the CPU has | Yes | Yes | Yes |
| `num_physical_cores` | Number of physical cores the CPU has | Yes | No | No |
| `usage_pct` | Current overall CPU utilisation | Yes | Yes | No |
| `current_clock_speed` | Current clock speed of the CPU in MHz | Yes | No | No |
| `max_clock_speed` | Maximum clock speed of the CPU in MHz | Yes | No | No |
| `voltage` | Current voltage of the CPU | yes | No | No |

The value for `num_logical_cores` is determined by `navigator.hardwareConcurrency` in Wallpaper Engine and Lively Wallpaper which means that this value may not be accurate. 