# Media information


Support for Media Information varies between platforms. It's currently unavailable in Opera GX, but is available in both Lively Wallpaper and Wallpaper Engine

## Current Media
`global.live_wallpaper_current_media`

The media currently playing in the users OS as a struct stored in `global.live_wallpaper_current_media` 

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `title` | Title of the currently playing track | No | No | No |
| `artist` | Artist of the currently playing track | No | No | No | 
| `subtitle` | Subtitle of the currently playing track | No | Yes | Yes |
| `album_title` | Title of the current tracks album | No | Yes | Yes |
| `album_artist` | Artist of the current tracks album | No | Yes | Yes | 
| `genres` | Genres of the current track | No | Yes | Yes |
| `content_type` | Type of content being played | No | Yes | Yes |
| `track_number` | Track number of the current track in its album | No | Yes | No |
| `album_number_tracks` | Number of tracks in this tracks album | No | Yes | No |


 ## Media Position
`global.live_wallpaper_current_media_position`
Current position and duration of the content being played. This is only available in Wallpaper Engine as a struct stored in `global.live_wallpaper_current_media_position`

| Field | Type | Description | 
| - | - | - |
| `position` | Real | Position in the track the user is at, in seconds |
| `duration` | Real | Length of the current track, in seconds |


## Media Playback State
`global.live_wallpaper_media_playback_state`

If the media is currently playing, paused, or stopped. Stored as a string in `global.live_wallpaper_media_playback_state`

Values: `"playing"`,`"paused"`,`"stopped"`