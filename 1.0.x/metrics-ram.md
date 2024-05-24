# RAM Metrics

Support for RAM metrics varies between platforms and is outlined in the following table. 

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `name` | Name/Model of the RAM | Yes | No | No |
| `memory_available` | Bytes of RAM currently available | Yes | Yes | No |
| `memory_used` | Bytes of RAM currently in use | Yes | Yes | No |
| `memory_total` | Total bytes of RAM installed in the system | Yes | Yes | No |


Important notes: The `name` field appears to return a hardware descriptor for the RAM rather than a model name. Separate sticks are not detected, the RAM returned by Opera GX and Lively are totals across the whole system. 
