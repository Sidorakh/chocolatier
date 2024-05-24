/// @description Loads config from the JSON file set in extension options
function live_wallpaper_setup() {
	var fname = extension_get_option_value("Chocolatier","config_file");
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
		gmcallback_set_wallpaper_config(chocolatier_get_current_config());
		gmcallback_handle_system_metrics(chocolatier_get_initial_metrics());
	}
}

global.live_wallpaper_config = {};
global.live_wallpaper_types = {};
global.live_wallpaper_special_values = [];

global.live_wallpaper_callback = undefined;
global.live_wallpaper_paused = false;
global.live_wallpaper_current_media = {
	title: "",
	artist: "",
	subtitle: "",
	album_title: "",
	album_artist: "",
	genres: "",
	content_type: "",
	thumbnail: "",
	track_number: -1,
	album_track_count: -1,
}

global.live_wallpaper_media_position = {
	position: -1,
	duration: -1,
}

global.live_wallpaper_media_playback_state = "playing";

function live_wallpaper_magic_set(obj,path,value) {
	var i=0;
	for (i=0;i<array_length(path) - 1;i++) {
		if (obj[$ path[i]] == undefined) {
			obj[$ path[i]] = {};
		}
		obj = obj[$ path[i]]
	}
	obj[$ path[i]] = value;
}

function live_wallpaper_magic_get(obj,path) {
	var i=0;
	for (i=0;i<array_length(path)-1;i++) {
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
			live_wallpaper_magic_set(global.live_wallpaper_config,path,live_wallpaper_parse_colour(value));
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
			// Wallpaper Engines crap
			var c = string_split(rgb," ");
			var r = ceil(real(c[2]) * 255);
			var g = ceil(real(c[2]) * 255);
			var b = ceil(real(c[2]) * 255);
			
			var colour = make_color_rgb(r,g,b)
			return real(colour);
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

/// Metrics - will only get all of these with Opera GX
/// Best attempts are made for fetching at least some
/// system metrics with both Lively and Wallpaper Engine


global.live_wallpaper_metrics = {
	cpu: {
		name: "",
		num_logical_cores: -1,
		num_physical_cores: -1,
		usage_pct: -1,
		current_clock_speed: -1,
		max_clock_speed: -1,
		voltage: -1,
	},
	gpu: {
		name: "",
		usage_pct: -1,
		clock_speed: -1,
		fan_speed: [],
		fan_rpm: -1,
		power_usage: -1,
		temperature: -1,
		memory_used: -1,
		memory_available: -1,
		memory_total: -1,
	},
	ram: {
		name: "",
		memory_available: -1,
		memory_used: -1,
		memory_total: -1,
	},
	networking: {
		name: "",
		bandwidth: -1,
		send_bps: -1,
		received_bps: -1,
	},
	battery: {
		name: "",
		is_charging: false,
		remaining_charge_pct: -1,
		remaining_charge_time: -1,
		time_to_full_charge: -1,
	},
	storage: [],
	audio: {
		freq_resolution: -1,
		spectrum_amplitude: [],
		levels: [],
	}
};

function live_wallpaper_handle_metrics_gx(data) {
	if (data[$ "cpu"] != undefined && array_length(data[$ "cpu"]) > 0) {
		var cpu = data.cpu[0];
		var metric = global.live_wallpaper_metrics.cpu;
		// Yes. This horror show is necessary. Don't blame me, blame GameMaker/Opera GX
		// They made this necessary
		metric.name = cpu[$ "name"] ?? metric.name;
		metric.num_logical_cores = cpu[$ "num_logical_cores"] ?? metric.num_logical_cores;
		metric.num_physical_cores = cpu[$ "num_physical_cores"] ?? metric.num_physical_cores;
		metric.usage_pct = cpu[$ "usage_pct"] ?? metric.usage_pct;
		metric.current_clock_speed = cpu[$ "current_clock_speed_MHz"] ?? metric.current_clock_speed;
		metric.max_clock_speed = cpu[$ "max_clock_speed_MHz"] ?? metric.max_clock_speed;
		metric.voltage = cpu[$ "voltage_V"] ?? metric.voltage;
	}
	if (data[$ "gpu"] != undefined && array_length(data[$ "gpu"]) > 0) {
		var gpu = data.gpu[0];
		var metric = global.live_wallpaper_metrics.gpu;
		metric.name = gpu[$ "name"] ?? metric.name;
		metric.usage_pct = gpu[$ "usage_pct"] ?? metric.usage_pct;
		metric.clock_speed = gpu[$ "clock_speed_MHz"] ?? metric.clock_speed;
		metric.fan_speed = gpu[$ "fan_speed_pct"] ?? metric.fan_speed;
		if (gpu[$ "fan_speed_rpm"] != undefined) {
			metric.fan_rpm = gpu[$ "fan_speed_rpm"][0];
		}
		metric.power_usage = gpu[$ "power_usage_W"] ?? metric.power_usage;
		metric.temperature = gpu[$ "temperature_C"] ?? metric.temperature;
		metric.memory_used = int64(gpu[$ "memory_used_bytes"] ?? metric.memory_used);
		metric.memory_available = int64(gpu[$ "memory_available_bytes"] ?? metric.memory_available);
		metric.memory_total = int64(gpu[$ "memory_total_bytes"] ?? metric.memory_total);
	}
	if (data[$ "battery"] != undefined && array_length(data[$ "battery"]) > 0) {
		var battery = data.battery[0];
		var metric = global.live_wallpaper_metrics.battery;
		metric.name = battery[$ "name"] ?? metric.name;
		metric.is_charging = battery[$ "is_charging"] ?? metric.is_charging;
		metric.remaining_charge_pct = battery[$ "remaining_charge_pct"] ?? metric.remaining_charge_pct;
		metric.remaining_charge_time = battery[$ "remaining_charge_time_min"] ?? metric.remaining_charge_time;
	}
	if (data[$ "ram"] != undefined && array_length(data[$ "ram"]) > 0) {
		var ram = data.ram[0];
		var metric = global.live_wallpaper_metrics.ram;
		metric.name = ram[$ "name"] ?? metric.name;
		metric.memory_available = int64(ram[$ "available_bytes"] ?? metric.memory_available);
		metric.memory_used = int64(ram[$ "used_bytes"] ?? metric.memory_used);
		metric.memory_total = int64(ram[$ "total_bytes"] ?? metric.memory_total);
		
	}
	if (data[$ "networking"] != undefined && array_length(data[$ "networking"]) > 0) {
		var networking = data.networking[0];
		var metric = global.live_wallpaper_metrics.networking;
		metric.bandwidth = networking[$ "bandwidth_bps"] ?? metric.bandwidth;
		metric.send_bps = networking[$ "send_bps"] ?? metric.send_bps;
		metric.received_bps = networking[$ "received_bps"] ?? metric.received_bps;
	}
	if (data[$ "disk"] != undefined && array_length(data[$ "disk"]) > 0) {
		var metric = global.live_wallpaper_metrics.storage;
		for (var i=0;i<array_length(data.disk);i++) {
			var disk = {
				name: data.disk[i].name ?? "",
				available_bytes: int64(data.disk[i][$ "available_bytes"] ?? 0),
				total_bytes: int64(data.disk[i][$ "total_bytes"] ?? 0),
				used_bytes: int64(data.disk[i][$ "used_bytes"] ?? 0)
			};
			var index = -1;
			for (var j=0;j<array_length(metric);j++) {
				var mydisk = metric[j];
				if (mydisk.name == disk.name) {
					index = j;
					break;
				}
			}
			if (index != -1) {
				metric[index].name = disk[$ "name"] ?? metric[index].name;
				metric[index].available_bytes = disk[$ "available_bytes"] ?? metric[index].available_bytes;
				metric[index].total_bytes = disk[$ "total_bytes"] ?? metric[index].total_bytes;
				metric[index].used_bytes = disk[$ "used_bytes"] ?? metric[index].used_bytes;
			} else {
				var newdisk = {
					name: disk[$ "name"] ?? "",
					available_bytes: disk[$ "available_bytes"] ?? 0,
					total_bytes: disk[$ "total_bytes"] ?? 1,
					used_bytes: disk[$ "used_bytes"] ?? 0,
				}
				array_push(metric,newdisk);	
				
			}
		}
	}
	if (data[$ "audio"] != undefined && array_length(data[$ "audio"]) > 0) {
		var metric = global.live_wallpaper_metrics.audio;
		var audio = data.audio;
		if (audio[$ ""]) {
		
		}
	}
}


function gmcallback_handle_system_metrics(data) {
	var json = json_parse(data);
	var metrics = global.live_wallpaper_metrics;
	// CPU
	metrics.cpu.name = json.cpu.name;
	metrics.cpu.num_logical_cores = json.cpu.num_logical_cores;
	metrics.cpu.num_physical_cores = json.cpu.num_physical_cores;
	metrics.cpu.usage_pct = json.cpu.usage_pct;
	
	// GPU
	metrics.gpu.name = json.gpu.name;
	metrics.gpu.usage_pct = json.gpu.usage_pct;
	
	// RAM
	metrics.ram.name = json.ram.name;
	metrics.ram.memory_used = json.ram.memory_used;
	metrics.ram.memory_available = json.ram.memory_available;
	metrics.ram.memory_total = json.ram.memory_total;
	
	// networking
	metrics.networking.name = json.networking.name;
	metrics.networking.send_bps = json.networking.up;
	metrics.networking.received_bps = json.networking.down;
	
	// battery
	metrics.battery.name = json.battery.name;
	metrics.battery.is_charging = json.battery.is_charging;
	metrics.battery.remaining_charge_pct = json.battery.remaining_charge;
	metrics.battery.remaining_charge_time = json.battery.remaining_time;
	metrics.battery.time_to_full_charge = json.battery.time_to_full_charge;
	
	
}

function gmcallback_handle_lively_playback_state_change(paused) {
	if (paused) {
		global.live_wallpaper_paused = true;
	} else {
		global.live_wallpaper_paused = false;
	}
}

function gmcallback_current_media(data) {
	var media = json_parse(data);
	show_debug_message(media)
	var cm = global.live_wallpaper_current_media;
	cm.title = media.title;
	cm.artist = media.artist;
	cm.subtitle = media.subtitle;
	cm.album_title = media.album_title;
	cm.album_artist = media.album_artist;
	cm.genres = media.genres;
	cm.content_type = media.content_type;
	cm.track_number = media.track_number;
	cm.album_track_count = media.album_track_count;
}

function gmcallback_current_media_position(data) {
	var media = json_parse(data);
	global.live_wallpaper_media_position.duration = media.duration;
	global.live_wallpaper_media_position.position = media.position;
}

function gmcallback_current_playback_state(state) {
	global.live_wallpaper_media_playback_state = state;
}

function gmcallback_system_audio_data(data) {
	global.live_wallpaper_metrics.audio.levels = json_parse(data);
}

// quick and dirty wrap of wallpaper_set_subscriptions to not error on HTML5

#macro wallpaper_set_subscription_real wallpaper_set_subscriptions
#macro wallpaper_set_subscriptions live_wallpaper_set_subscriptions

function live_wallpaper_set_subscriptions(subscriptions) {
	try {
		wallpaper_set_subscription_real(subscriptions);
	} catch(e) {
		// lolnope
	}
}

