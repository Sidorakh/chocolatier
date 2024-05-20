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

// Global options

const options = {...__initial_wallpaper_options};
const metrics = {
    cpu: {
        name: "",
        usage_pct: -1,
        num_logical_cores: navigator.hardwareConcurrency || -1,
        num_physical_cores: -1,
        num_physical_cores: -1,

    },
    gpu: {
        name: "",
        usage_pct: -1,
    },
    ram: {
        name: '',
        memory_used: -1,
        memory_available: -1,
        memory_total: -1,
    },
    battery: {
        name: '',
        is_charging: true,
        remaining_charge: -1,
        remaining_time: -1,
        time_to_full_charge: -1,

    },
    networking: {
        name: "",
        down: -1,
        up: -1,
    },
    audio: {},

};


// Lively Wallpaper

window.livelyPropertyListener = function(path,value) {
    set(options,path,value);
    update_wallpaper_config();
}

window.livelySystemInformation = function(data){
    const json = JSON.parse(data);
    // All the data Lively exposes for CPU and GPU
    metrics.cpu.name = json.NameCpu;
    metrics.cpu.usage_pct = json.CurrentCpu;
    metrics.gpu.name = json.NameGpu;
    metrics.gpu.usage_pct = json.CurrentGpu3d;
    // Converted to bytes, matches GameMaker
    // and stringified to run through int64 back in GM - keeps precision
    metrics.ram.memory_available = `${json.CurrentRamAvail * 1024}`;
    metrics.ram.memory_total = `${json.RamTotal * 1024}`;
    metrics.ram.memory_used = `${(json.RamTotal - json.CurrentRamAvail) * 1024}`;
    metrics.networking.name = json.NameNetCard;
    // Converted to bytes, matches Opera GX
    metrics.networking.down = json.CurrentNetDown * 8;
    metrics.networking.up = json.CurrentNetUp * 8;
    update_system_metrics();
}

if (__lively_init.initial_metrics != "") {
    livelySystemInformation(__lively_init.initial_metrics);
}


// audio levels listener
window.livelyAudioListener = function(audio) {
    // TODO: maybe put something here
}

// on wallpaper pause and unpause
window.livelyWallpaperPlaybackChanged = function(data) {
    const evt = JSON.parse(data);
    gml_Script_gmcallback_handle_lively_playback_state_change(evt.isPaused);
}
if (__lively_init.initial_playback_changed != '') {
    window.livelyWallpaperPlaybackChanged(__lively_init.initial_playback_changed);
}
/**
 * @typedef NowPlaying
 * @prop {string} AlbumArtist
 * @prop {string} AlbumTitle
 * @prop {number} AlbumTrackCount
 * @prop {string} Artist
 * @prop {string[]} Genres
 * @prop {string} PlaybackType
 * @prop {string} Subtitle
 * @prop {string} Thumbnail
 * @prop {string} Title
 * @prop {number} TrackNumber
 */

window.livelyCurrentTrack = function(data) {
    /** @type {null | NowPlaying} */
    console.log(`Current track`);
    console.log(data);
    const event = JSON.parse(data);
    if (event != null) {
        // pass it to GM here - maybe leave out the thumbnail - not like we can use it anyway
        update_system_current_media({
            title: event.Title,
            artist: event.Artist,
            subtitle: event.Subtitle,
            album_title: event.AlbumTitle,
            album_artist: event.AlbumArtist,
            genres: event.Genres.join(',') || '',
            content_type: event.PlaybackType,
            track_number: event.TrackNumber,
            album_track_count: event.AlbumTrackCount
        })
    } else {
        update_system_current_media({
            title: '',
            artist: '',
            subtitle: '',
            album_title: '',
            album_artist: '',
            genres: '',
            content_type: '',
            track_number: -1,
            album_track_count: -1,
        });
    }

}

if (window.__lively_init.initial_current_track != '') {
    window.livelyCurrentTrack(window.__lively_init.initial_current_track);
}


// Wallpaper Engine

/**
 * @typedef EventMediaStatus
 * @prop {boolean} enabled
 */

function wallpaper_media_status_listener(/** @type {EventMediaStatus} */ event) {
    if (event.enabled) {
        // it's on!
    } else {
        // it's off!
    }
}

try {
    window.wallpaperRegisterMediaStatusListener(wallpaper_media_status_listener);
    if (window.__wpengine_init.initial_media_status != null) {
        window.wallpaper_media_status_listener(window.__wpengine_init.initial_media_status);
    }
} catch(e) {
    // not wallpaper engine
}

/**
 * @typedef EventMediaProperties
 * @prop {string} title
 * @prop {string} artist
 * @prop {string} subTitle
 * @prop {string} albumTitle
 * @prop {string} albumArtist
 * @prop {string?} genres
 * @prop {'music' | 'video' | 'image'} contentType
 */
function wallpaper_media_properties_listener(/** @type {EventMediaProperties} */ event) {
    // handle media
    // docs: https://docs.wallpaperengine.io/en/web/audio/media.html#mediapropertieslistener
    if (event) {
        const data = {
            title: event.title,
            artist: event.artist,
            subtitle: event.subTitle,
            album_title: event.albumTitle,
            album_artist: event.albumArtist,
            genres: event.genres ?? '',
            content_type: event.contentType,
            track_number: -1,
            album_track_count: -1,
        };
        update_system_current_media(data);
    }
}

try {
    window.wallpaperRegisterMediaPropertiesListener(wallpaper_media_properties_listener);
    if (__wpengine_init.initial_media != null) {
        wallpaper_media_properties_listener(window.__wpengine_init.initial_media);
    }
} catch(e) {
    // not wallpaper engine
}

/**
 * @typedef EventThumbnail
 * @prop {string} thumbnail
 * @prop {string} primaryColor
 * @prop {string} secondaryColor
 * @prop {string} teritaryColor
 * @prop {string} textColor
 * @prop {string} highContrastColor
 */

function wallpaper_media_thumbnail_listener(/** @type {EventThumbnail} */ event) {
    // handle thumbnail
    // docs: https://docs.wallpaperengine.io/en/web/audio/media.html#mediathumbnaillistener
}

try {
    window.wallpaperRegisterMediaThumbnailListener(wallpaper_media_thumbnail_listener);
    if (__wpengine_init.initial_thumbnail != null) {
        wallpaper_media_thumbnail_listener(window.__wpengine_init.initial_thumbnail);
    }
} catch(e) {
    // not wallpaper engine
}

/**
 * @typedef EventMediaPlayback
 * @prop {number} state
 */

function wallpaper_media_playback_listener(/** @type {EventMediaPlayback} */ event) {
    // handle media playback states
    // docs: https://docs.wallpaperengine.io/en/web/audio/media.html#mediaplaybacklistener
    if (event.state == window.wallpaperMediaIntegration.PLAYBACK_PLAYING) {
        gml_Script_gmcallback_current_playback_state('','','playing');
    } else if (event.state == window.wallpaperMediaIntegration.PLAYBACK_PAUSED) {
        gml_Script_gmcallback_current_playback_state('','','paused');
    } else if (event.state == window.wallpaperMediaIntegration.PLAYBACK_STOPPED) {
        gml_Script_gmcallback_current_playback_state('','','stopped');
    }
}

try {
    window.wallpaperRegisterMediaPlaybackListener(wallpaper_media_playback_listener);
    if (__wpengine_init.initial_playback_state != null) {
        wallpaper_media_playback_listener(window.__wpengine_init.initial_playback_state);
    }
} catch(e) {
    // not wallpaper engine
}


/**
 * @typedef EventMediaTimeline
 * @prop {number} position
 * @prop {number} duration
 */
function wallpaper_media_timeline_listener(/** @type {EventMediaTimeline} */ event) {
    if (event) {
        gml_Script_gmcallback_current_media_position(null,null,JSON.stringify({
            position: event.position,
            duration: event.duration,
        }))
    }
}

try {
    window.wallpaperRegisterMediaTimelineListener(wallpaper_media_timeline_listener);
    if (__wpengine_init.initial_media_position) {
        wallpaper_media_timeline_listener(window.__wpengine_init.initial_media_position);
    }
} catch(e) {
    // not wallpaper engine
}


window.wallpaperPropertyListener = {
    applyUserProperties: function(properties) {
        const keys = Object.keys(properties);
        console.log(keys);
        for (const key of keys) {
            if (properties[key].type != 'group') {
                set(options,key,properties[key].value)
            }
        }
        update_wallpaper_config();
    }

}



// Unviersal
/*
title: event.title,
            artist: event.artist,
            subtitle: event.subTitle,
            album_title: event.albumTitle,
            album_artist: event.albumArtist,
            genres: event.genres ?? '',
            content_type: event.contentType,
            track_number: -1,
*/
/**
 * @typedef CurrentMediaData
 * @prop {string} title
 * @prop {string} artist
 * @prop {string} subtitle
 * @prop {string} album_title
 * @prop {string} album_artist
 * @prop {string} genres
 * @prop {string} content_type
 * @prop {number} track_number
 * @prop {number} album_track_count
 */

function update_system_current_media(/** @type {CurrentMediaData} */ media) {
    window.gml_Script_gmcallback_current_media(null,null,JSON.stringify(media));

}

navigator.getBattery().then(/** @type {BatteryManager} */ battery=>{
    function update_charging_info() {
        metrics.battery.is_charging = battery.charging;
        update_system_metrics();
    }
    function update_level_info() {
        metrics.battery.remaining_charge = battery.level;
        update_system_metrics();
    }
    function update_discharge_info() {
        metrics.battery.remaining_time = Math.floor(battery.dischargingTime/60);
        if (battery.dischargingTime == Infinity) {
            metrics.battery.remaining_time = -1;
        }
        update_system_metrics();
    }
    function update_charge_info() {
        metrics.battery.time_to_full_charge = Math.floor(battery.chargingTime/60);
        if (battery.chargingTime == Infinity) {
            metrics.battery.time_to_full_charge = -1;
        }
        update_system_metrics();
    }
    function update_battery_info() {
        update_charging_info();
        update_level_info();
        update_discharge_info();
        // above required to match GX
        update_charge_info();
        // and time til full charge for good measure
    }
    update_battery_info();
});


function update_wallpaper_config() {
    gml_Script_gmcallback_set_wallpaper_config(null,null,JSON.stringify(options));
}

function update_system_metrics(){
    gml_Script_gmcallback_handle_system_metrics(null,null,JSON.stringify(metrics));
}


// the functions called from GameMaker
function chocolatier_get_current_config() {
    return JSON.stringify(options);
}

function chocolatier_get_initial_metrics() {
    return JSON.stringify(metrics);
}

