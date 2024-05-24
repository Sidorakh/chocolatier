# live_wallpaper_magic_get()
---
`live_wallpaper_magic_get(obj,path)`

An internal function used to read from a struct several levels deep. 

***You probably don't need to use this***


| Name | Type | Description |
| - | - | - | 
| `obj` | Struct | Object to modify |
| `path` | Array.String | Target path to read |

Returns: Any

## Usage

This code reads a value several levels deep in the given struct

```gml
var result = live_wallpaper_magic_get(config,["display","colour","value"]);
```