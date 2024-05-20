# Getting Started

## Installation and basic usage

1. Download the latest .yymp from [Releases](https://github.com/Sidorakh/chocolatier/releases)
2. Open your GameMaker project (or create a new one) and drag the .yymp file into the IDE (or go to the Tools menu and select Import Local Package)
3. Ensure you at least import the Chocolatier folder in "Extensions" (optionally, you can import everything for a basic wallpaper example)
4. Create your initial wallpaper configuration following the strucutre set out by [the documentation for GX Live Wallpapers](https://manual.gamemaker.io/beta/en/GameMaker_Language/GML_Reference/Live_Wallpapers/wallpaper_set_config.htm) and save it as an included file. Optionally, you can also use my [Chocolatier Configuration Buidler](https://tools.sidorakh.net/chocolatier) which will allow you to build Opera GX and Chocolatier-compatible config files
5. Open Chocolatier, and ensure that the config filename is correct (this should match the included file you created in step 4), as well as all the other details/
6. Ensure `live_wallpaper_setup();` is called when your wallpaper starts up - this sets up api's for Opera GX, Lively, and Wallpaper Engine
7. Ensure you add a `Wallpaper Config` event and run `live_wallpaper_handle_config_gx(wallpaper_config);` in it to handle Opera GX configuration updates
8. You can now access the configuration in the struct `global.live_wallpaper_config`. You can set `gloal.live_wallpaper_callback` to a function or method, which will be called whenever the configuration updates

## Chocolatier Configuration

Chocolatier includes some options in the extension to set metadat for both Lively Wallpaper and Wallpaper Engine, unforutnately this can't easily be replicated from Opera GX. 

| Option | Type | Description |
| - | - | - |
| Config Filename | String | Filename that the default configuration is stored in (Default: `config.json`) |
| Thumbnail | String | Filename of included file that the thumbnail/preview image is stored in. If this field is left blank or the file doens't exist, it won't cause issues, it just won't be set in the final build. (Default: `wallpaper-thumbnail.png`) |
| Author | String | Authors name | 
| Version | Number | Wallpaper version |
| Title | String | Wallpaper name/title |
| Description | String | Short description fo the wallpaper |
| License | String | License the wallpaper is released under | 
| Tags | String | A comma separated list of tags for this wallpaper |


## Important notes

To get around GameMaker issues with Wallpaper Engine overwriting the `AudioContext` class, the `AudioContext` class gets reset in code injected by my extension. This injected code also handles some initial configuration. If you need to modify this behaviour at all or need to use a custom HTML file for your wallpaper, it's all stored in the HTML5 Extension properties and also listed here. 


Code used to get around Wallpaper Engine overwriting `AudioContext`
```js
const ac = new AudioContext();
window.AudioContext = ac.constructor;
```

Code used to set up initial listeners for Wallpaper Engine and Lively Wallpaper (these get overwritten later by code in the `wallpaper.js` function - this is intentional)

```js
const mymagicsetfn = function(obj, path, value) {
    let i;
    path = path.split('.');
    for (i = 0; i < path.length - 1; i++) {
        if (obj[path[i]] == undefined) {
            obj[path[i]] = {};
        }
        obj = obj[path[i]];
    }
    obj[path[i]] = value;
}
window.__initial_wallpaper_options = {};
window.livelyPropertyListener = function(path,value) {
    mymagicsetfn(__initial_wallpaper_options,path,value)
}
window.wallpaperPropertyListener = {
    applyUserProperties(properties) {
        for (const keys of Object.keys(properties)) {
            mymagicsetfn(window.__initial_wallpaper_options,path,value);
        }
    }
}
```
