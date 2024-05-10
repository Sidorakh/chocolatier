function set(obj, path, value) {
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

const options = {};
console.log(window.__initial_wallpaper_options);

window.livelyPropertyListener = function(path,value) {
    set(options,path,value);
    gml_Script_gmcallback_set_wallpaper_config(null,null,JSON.stringify(options));
}

window.wallpaperPropertyListener = {
    applyUserProperties: function(properties) {
        console.log(properties);
        const keys = Object.keys(properties);
        console.log(keys);
        for (const key of keys) {
            if (properties[key].type != 'group') {
                set(options,key,properties[key].value)
            }
        }
        console.log(JSON.stringify(options));
        gml_Script_gmcallback_set_wallpaper_config(null,null,JSON.stringify(options));
    }

}

function desktop_candy_get_current_config() {
    return JSON.stringify(options);
}