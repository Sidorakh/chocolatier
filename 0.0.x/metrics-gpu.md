# GPU Metrics

Support for GPU metrics varies between platforms and is outlined in the following table. The Opera GX implementation requires an up-to-date NVidia or AMD GPU. 

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `name` | Name/Model of the GPU | Yes | Yes | No |
| `usage_pct` | Current overall GPU utlilisation | Yes | Yes | No |
| `clock_speed` | Current clock speed of the GPU in MHz | Yes | No | No |
| `fan_speed` | Current fan speed as a percentage of maximum speed (NVidia only) | Yes | No | No |
| `fan_rpm` | Current fan speed in RPM (AMD only) | Yes | No | No |
| `power_usage` | Current power use of the GPU in watts | Yes | No | No |
| `memory_used` | Bytes of GPU memory currently used | Yes | No | No |
| `memory_available` | Bytes of GPU memory currently available | Yes | No | No |
| `memory_total` | Bytes of GPU memory installed | Yes | No | No |