# Audio Metrics

Support for Audio metrics varies between platforms

| Field | Description | Opera GX | Lively Wallpaper | Wallpaper Engine |
| - | - | - | - | - | 
| `freq_resolution` | The frequency resolution | Yes | No | No |
| `spectrum_amplitude` | Audio data returned by Opera GX | Yes | No | No | 
| `levels` | Audio data returned by Lively and Wallpaper Engine | No | Yes | Yes |


Important notes: This field functions differently between Opera GX and Lively/Wallpaper Engine. Lively Wallpaper and Wallpaper Engine will return an array stored in `levels`, containing 128 values usually between 0 and 1, but not always. 
 - [Lively Wallpaper's documentation on audio data](https://github.com/rocksdanister/lively/wiki/Web-Guide-V-:-System-Data#--audio)
 - [Wallpaper Engine's documentation on audio data](https://docs.wallpaperengine.io/en/web/audio/visualizer.html#creating-an-audio-listener)

Opera GX's handling of audio metrics is very different to Lively and Wallpaper Engine, instead returning `freq_resolution` and the `spectrum_amplitude` array that is of variable size. Make sure to check the relevant documentation for how to process this:
 - [Opera GX](https://manual.gamemaker.io/beta/en/#t=GameMaker_Language%2FGML_Reference%2FLive_Wallpapers%2Fwallpaper_set_subscriptions.htm%23h)
 - [An example on creating an audio visualiser for Opera GX's live wallpaper system](https://help.gamemaker.io/hc/en-us/articles/15176025039901-How-To-Use-System-Metrics-In-Live-Wallpapers#:~:text=wallpapers%20come%20alive!-,Audio%20Visualiser,-Here%20is%20a)

 