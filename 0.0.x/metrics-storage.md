# Storage Metrics
---

Support for Storage metrics is only available on Opera GX at this time. `global.live_wallpaper_metrics.storage` is an array of structs representing each attached storage device, with the following structure

| Field | Type | Description |
| - | - | - |
| `name` | String | Name of the disk |
| `available_bytes` | Int64 | Storage available on the disk in bytes |
| `total_bytes` | Int64 | Total storage on the disk in bytes |
| `used_bytes` | Int64 | Storage used on the disk in bytes |

Important note: Devices such as empty DVD drives may show 0 total bytes - make sure to verify their size before performing any operations