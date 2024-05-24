# live_wallpaper_magic_set()
---
`live_wallpaper_magic_set(obj,path,value)`

An internal function used to modify wallpaper configuration in-place. 

***You probably don't need to use this***


| Name | Type | Description |
| - | - | - | 
| `obj` | Struct | Object to modify |
| `path` | Array.String | Target path to set |
| `value` | Any | Value to insert |

Returns: Nothing

## Usage

This code sets a value several levels deep in the given struct

```gml
live_wallpaper_magic_set(config,["display","colour","value"],c_red);
```