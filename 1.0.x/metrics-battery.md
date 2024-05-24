# Battery Metrics
---

Support for Battery metrics varies between platforms and is outlined in the following table

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `name` | Name/Model of the battery | Yes | No | No |
| `is_charging` | Whether or not the battery is currently charging | Yes | Yes | Yes |
| `remaining_charge_pct` | Percentage of battery left | Yes | Yes | Yes |
| `remaining_charge_time` | How long the device will last on battery power (in minutes) | Yes | Yes | Yes |
| `time_to_full_charge` | How long until the device will be fully charged (in minutes) | No | Yes | Yes |

The battery data for Lively Wallpaper and Wallpaper Engine is derived from the [BatteryManager](https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager) class, and may return battery data for a device that doens't have a battery. In these cases, `remaining_charge_time` will be set to `-1`. 