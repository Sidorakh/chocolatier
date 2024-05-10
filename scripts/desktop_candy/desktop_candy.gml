/// @description Loads config from the JSON file set in extension options
function live_wallpaper_set_config() {
	var fname = extension_get_option_value("DesktopCandy","config_file");
	//show_message(fname);
	var buff = buffer_load(fname);
	var str = buffer_read(buff,buffer_text);
	var json = json_parse(str,undefined,true);
	live_wallpaper_json_walk(json,[]);
	
	
	buffer_delete(buff);
	try {
		wallpaper_set_config(json);
	} catch(e) {
		// this means we're in Lively or Wallpaper Engine
		gmcallback_set_wallpaper_config(desktop_candy_get_current_config());
	}
}


global.live_wallpaper_config = {};
global.live_wallpaper_types = {};
global.live_wallpaper_special_values = [];

global.live_wallpaper_callback = undefined;

function live_wallpaper_magic_set(obj,path,value) {
	var i=0;
	for (var i=0;i<array_length(path) - 1;i++) {
		if (obj[$ path[i]] == undefined) {
			obj[$ path[i]] = {};
		}
		obj = obj[$ path[i]]
	}
	obj[$ path[i]] = value;
}

function live_wallpaper_magic_get(obj,path) {
	var i=0;
	for (var i=0;i<array_length(path)-1;i++) {
		if (obj[$ path[i]] == undefined) {
			return undefined;
		}
		obj = obj[$ path[i]];
	}
	return obj[$ path[i]];
}

function live_wallpaper_json_walk(json,path = []) {
	
	for (var i=0;i<array_length(json);i++) {
		var child = json[i];
		var newpath = [];
		array_copy(newpath,0,path,0,array_length(path));
		newpath[array_length(newpath)] = child.name;
		
		var name = child.name;
		if (child.type == "section") {
			live_wallpaper_json_walk(child.children,newpath);
		}
		if (child.type == "colour" || child.type == "color") {
			var c = live_wallpaper_parse_colour(child.value);
			child.value = c;
			live_wallpaper_magic_set(global.live_wallpaper_config,newpath,c);
			live_wallpaper_magic_set(global.live_wallpaper_types,newpath,"color");
			array_push(global.live_wallpaper_special_values,newpath);
		}
		if (child.type == "range") {
			live_wallpaper_magic_set(global.live_wallpaper_config,newpath,child.value);	
			live_wallpaper_magic_set(global.live_wallpaper_types,newpath,"range");
			array_push(global.live_wallpaper_special_values,newpath);
		}
		if (child.type == "boolean") {
			live_wallpaper_magic_set(global.live_wallpaper_config,newpath,child.value);	
			live_wallpaper_magic_set(global.live_wallpaper_types,newpath,"boolean");
			array_push(global.live_wallpaper_special_values,newpath);
		}
		if (child.type == "string") {
			live_wallpaper_magic_set(global.live_wallpaper_config,newpath,child.value);	
			live_wallpaper_magic_set(global.live_wallpaper_types,newpath,"string");
			array_push(global.live_wallpaper_special_values,newpath);
		}
		if (child.type == "select") {
			live_wallpaper_magic_set(global.live_wallpaper_config,newpath,child.value);	
			live_wallpaper_magic_set(global.live_wallpaper_types,newpath,child.options);
			array_push(global.live_wallpaper_special_values,newpath);
		}
	}
}

function gmcallback_set_wallpaper_config(str){
	//show_debug_message(str);
	var data = json_parse(str);
	for (var i=0;i<array_length(global.live_wallpaper_special_values);i++) {
		var path = global.live_wallpaper_special_values[i];
		var type = live_wallpaper_magic_get(global.live_wallpaper_types,path);
		var value = live_wallpaper_magic_get(data,path);
		if (value == undefined) continue;
		if (is_array(type)) {
			// dropdown
			live_wallpaper_magic_set(global.live_wallpaper_config,path,type[value]);
			
		} else if (type == "color") {
			// colour
			live_wallpaper_magic_set(global.live_wallpaper_config,path,"color: " + value);
		} else {
			// nothign else needs special handling.. probably
			live_wallpaper_magic_set(global.live_wallpaper_config,path,value);
		}
	}
	//global.live_wallpaper_config = data;
	
	live_wallpaper_config_update();
}
function live_wallpaper_handle_config_gx(config) {
	global.live_wallpaper_config = config;
	live_wallpaper_config_update();
}

function live_wallpaper_parse_colour(rgb) {
	if (is_string(rgb)) {
		if (string_starts_with(rgb,"#")) {
			// Lively / CSS colour
			var r = string_copy(rgb,2,2);
			var g = string_copy(rgb,4,2);
			var b = string_copy(rgb,6,2);
			var bgr = "0x" + r + g + b;
			return real(bgr);
		} else {
			// Wallpper Engines crap
			var c = string_split(rgb," ");
			var bgr = "0x" + c[2] + c[1] + c[0];
			return real(bgr);
			
			
			
		}
	} else {	// It's probably a colour already
		return rgb;	
	}
}

function live_wallpaper_config_update() {
	if (is_callable(global.live_wallpaper_callback)) {
		global.live_wallpaper_callback(global.live_wallpaper_config);
	}
}
