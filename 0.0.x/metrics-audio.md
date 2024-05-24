# Audio Metrics

Support for Audio metrics varies between platforms

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `freq_resolution` | The frequency resolution | Yes | No | No |
| `spectrum_amplitude` | Audio data returned by Opera GX | Yes | No | No | 
| `levels` | Audio data returned by Lively and Wallpaper Engine | No | Yes | Yes |


Important notes: This metric functions differently between Opera GX, Lively Wallpaper, and Wallpaper Engine. 
 - [Opera GX's documentation on audio data](https://manual.gamemaker.io/beta/en/#t=GameMaker_Language%2FGML_Reference%2FLive_Wallpapers%2Fwallpaper_set_subscriptions.htm%23h)
 - [An example on creating an audio visualiser for Opera GX's live wallpaper system](https://help.gamemaker.io/hc/en-us/articles/15176025039901-How-To-Use-System-Metrics-In-Live-Wallpapers#:~:text=wallpapers%20come%20alive!-,Audio%20Visualiser,-Here%20is%20a)
 - [Lively Wallpaper's documentation on audio data](https://github.com/rocksdanister/lively/wiki/Web-Guide-V-:-System-Data#--audio)
 - [Wallpaper Engine's documentation on audio data](https://docs.wallpaperengine.io/en/web/audio/visualizer.html#creating-an-audio-listener)

When running in Wallpaper Engine, the `levels` field will contain an array of 128 numbers usually (but not always) between 0 and 1. The first 64 entries represent audio in the left ear, the last 64 entries represent audio in the right ear. 

When running in Lively Wallpaper, the `levels` field will contain an array of 128 numbers usually (but not always) between 0 and 1, this does not appear to be sorted between left and right ears at all. 

When running in Opera GX, the `freq_resolution` will be set to a `number` (default is 10), and `spectrum_amplitude` will be an array with a variable amount of numbers. Check the [documentation](https://manual.gamemaker.io/beta/en/#t=GameMaker_Language%2FGML_Reference%2FLive_Wallpapers%2Fwallpaper_set_subscriptions.htm%23h) for more information. 