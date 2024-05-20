/// @description 
draw_text(4,4,json_stringify(global.live_wallpaper_config));
draw_text(4,20,json_stringify(global.live_wallpaper_types));
//draw_text(4,36,string_join_ext("\n",global.live_wallpaper_special_values));
//draw_text(4,52,json_stringify(global.live_wallpaper_current_media,true));

var str = $"{global.live_wallpaper_current_media.title} ({global.live_wallpaper_media_position.position}/{global.live_wallpaper_media_position.duration})\n{global.live_wallpaper_media_playback_state}";

draw_text(4,52,str);