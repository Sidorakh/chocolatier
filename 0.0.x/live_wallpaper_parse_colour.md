# live_wallpaper_parse_colour()
---
`live_wallpaper_parse_colour(rgb)`

An internal function used to convert both Lively Wallpaper and Wallpaper Engine's colour formats to something GameMaker can use

***You probably don't need to use this***


| Name | Type | Description |
| - | - | - | 
| `rgb` | String | RGB colour, either in `R G B` or `#RRGGBB` format|

Returns: Real

## Usage

This code reads a value several levels deep in the given struct

```gml
var result = live_wallpaper_parse_colour("#442463");
```