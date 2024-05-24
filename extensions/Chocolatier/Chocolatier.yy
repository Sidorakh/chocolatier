{
  "$GMExtension":"",
  "%Name":"Chocolatier",
  "androidactivityinject":"",
  "androidclassname":"",
  "androidcodeinjection":"",
  "androidinject":"",
  "androidmanifestinject":"",
  "androidPermissions":[],
  "androidProps":false,
  "androidsourcedir":"",
  "author":"",
  "classname":"",
  "copyToTargets":17179869280,
  "description":"",
  "exportToGame":true,
  "extensionVersion":"0.0.1",
  "files":[
    {"$GMExtensionFile":"","%Name":"","constants":[],"copyToTargets":32,"filename":"wallpaper.js","final":"","functions":[
        {"$GMExtensionFunction":"","%Name":"chocolatier_get_current_config","argCount":0,"args":[],"documentation":"","externalName":"chocolatier_get_current_config","help":"desktop_candy_get_current_config()","hidden":false,"kind":5,"name":"chocolatier_get_current_config","resourceType":"GMExtensionFunction","resourceVersion":"2.0","returnType":1,},
        {"$GMExtensionFunction":"","%Name":"chocolatier_get_initial_metrics","argCount":0,"args":[],"documentation":"","externalName":"chocolatier_get_initial_metrics","help":"chocolatier_get_initial_metrics","hidden":false,"kind":5,"name":"chocolatier_get_initial_metrics","resourceType":"GMExtensionFunction","resourceVersion":"2.0","returnType":1,},
      ],"init":"","kind":5,"name":"","order":[],"origname":"","ProxyFiles":[],"resourceType":"GMExtensionFile","resourceVersion":"2.0","uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject":"",
  "hasConvertedCodeInjection":true,
  "helpfile":"",
  "HTML5CodeInjection":"<GM_HTML5_PreHead>\r\n    <script>\r\n        (()=>{\r\n            const set = function(obj, path, value) {\r\n                let i;\r\n                path = path.split('.');\r\n                for (i = 0; i < path.length - 1; i++) {\r\n                    if (obj[path[i]] == undefined) {\r\n                        obj[path[i]] = {};\r\n                    }\r\n                    obj = obj[path[i]];\r\n                }\r\n                obj[path[i]] = value;\r\n            }\r\n            window.__initial_wallpaper_options = {};\r\n\r\n\r\n            // Lively Wallpaper\r\n            window.__lively_init = {\r\n                initial_metrics: '',\r\n                initial_current_track: '',\r\n                initial_playback_changed: '',\r\n            }\r\n            window.livelyPropertyListener = function(path,value) {\r\n                set(__initial_wallpaper_options,path,value)\r\n            }\r\n            window.__lively_init.initial_lively_system_metrics = \"\";\r\n            window.livelySystemInformation = function(data){\r\n                window.__lively_init.initial_metrics = data;\r\n            }\r\n            window.livelyCurrentTrack = function(data){\r\n                console.log(data);\r\n                window.__lively_init.initial_current_track = data;\r\n            }\r\n            window.livelyWallpaperPlaybackChanged = function(data) {\r\n                window.__lively_init.initial_playback_changed = data;\r\n            }\r\n            window.livelyAudioListener = function(data){\r\n                // this won't need recording\r\n            }\r\n            \r\n            // Wallpaper Engine\r\n            window.__wpengine_init = {\r\n                initial_media_status: null,\r\n                initial_media: null,\r\n                initial_thumbnail: null,\r\n                initial_playback_state: null,\r\n                initial_media_position: null,\r\n            }\r\n\r\n            window.wallpaperPropertyListener = {\r\n                applyUserProperties(properties){\r\n                    for (const key of Object.keys(properties)) {\r\n                        set(window.__initial_wallpaper_options,key,value);\r\n                    }\r\n                }\r\n            }\r\n            try {\r\n                window.wallpaperRegisterMediaStatusListener(event=>{window.__wpengine_init.initial_media_status = event;});\r\n                window.wallpaperRegisterMediaPropertiesListener(event=>{window.__wpengine_init.initial_media = event;});\r\n                window.wallpaperRegisterMediaThumbnailListener(event=>{window.__wpengine_init.initial_thumbnail = event;});\r\n                window.wallpaperRegisterMediaPlaybackListener(event=>{window.__wpengine_init.initial_playback_state = event;});\r\n                window.wallpaperRegisterMediaTimelineListener(event=>{window.__wpengine_init.initial_media_position = event;});\r\n            } catch(e) {\r\n\r\n            }\r\n\r\n            // And a small hacky fix for GameMaker HTML5 / Wallpaper Engine\r\n            const ac = new AudioContext();\r\n            window.AudioContext = ac.constructor;\r\n        })();\r\n    </script>\r\n</GM_HTML5_PreHead>",
  "html5Props":true,
  "IncludedResources":[],
  "installdir":"",
  "iosCocoaPodDependencies":"",
  "iosCocoaPods":"",
  "ioscodeinjection":"",
  "iosdelegatename":"",
  "iosplistinject":"",
  "iosProps":false,
  "iosSystemFrameworkEntries":[],
  "iosThirdPartyFrameworkEntries":[],
  "license":"",
  "maccompilerflags":"",
  "maclinkerflags":"",
  "macsourcedir":"",
  "name":"Chocolatier",
  "options":[
    {"$GMExtensionOption":"","%Name":"__extOptLabel","defaultValue":"Filenames","description":"","displayName":"","exportToINI":false,"extensionId":null,"guid":"98911a64-f14b-4660-b4f2-2fafaf7eb9ab","hidden":false,"listItems":[],"name":"__extOptLabel","optType":5,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"config_file","defaultValue":"config.json","description":"Wallpaper config JSON file","displayName":"Config filename","exportToINI":true,"extensionId":null,"guid":"e99eb865-37b1-42cb-9b5e-9ff55c9c9141","hidden":false,"listItems":[],"name":"config_file","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"thumbnail","defaultValue":"chocolatier.png","description":"","displayName":"Thumbnail","exportToINI":false,"extensionId":null,"guid":"e5aaaf20-58f7-4bd5-bc1f-ef27c931fff7","hidden":false,"listItems":[],"name":"thumbnail","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"__extOptLabel1","defaultValue":"Wallpaper Information","description":"","displayName":"","exportToINI":false,"extensionId":null,"guid":"3a87f157-1f2b-4ebb-b45e-dc9eb35810e1","hidden":false,"listItems":[],"name":"__extOptLabel1","optType":5,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"author","defaultValue":"","description":"","displayName":"Author","exportToINI":false,"extensionId":null,"guid":"6094931c-1744-4725-b023-0e717c87c8da","hidden":false,"listItems":[],"name":"author","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"version","defaultValue":"0","description":"","displayName":"Version","exportToINI":false,"extensionId":null,"guid":"f7e335c5-6ebb-4cec-b691-dc8f4658a653","hidden":false,"listItems":[],"name":"version","optType":1,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"title","defaultValue":"","description":"","displayName":"Title","exportToINI":false,"extensionId":null,"guid":"d16da663-1682-4dc3-aecd-54bdf9c2dfcd","hidden":false,"listItems":[],"name":"title","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"description","defaultValue":"","description":"","displayName":"Description","exportToINI":false,"extensionId":null,"guid":"ddb08143-1295-4772-8465-9d5e634e36e1","hidden":false,"listItems":[],"name":"description","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"license","defaultValue":"","description":"","displayName":"License","exportToINI":false,"extensionId":null,"guid":"5a112ee9-ba83-419e-92e8-5a360c9aeffe","hidden":false,"listItems":[],"name":"license","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
    {"$GMExtensionOption":"","%Name":"tags","defaultValue":"","description":"A comma separated list of tags","displayName":"Tags","exportToINI":false,"extensionId":null,"guid":"c1941842-94ff-4a87-a046-e99f680c4e95","hidden":false,"listItems":[],"name":"tags","optType":2,"resourceType":"GMExtensionOption","resourceVersion":"2.0",},
  ],
  "optionsFile":"options.json",
  "packageId":"",
  "parent":{
    "name":"Chocolatier",
    "path":"folders/Extensions/Chocolatier.yy",
  },
  "productId":"",
  "resourceType":"GMExtension",
  "resourceVersion":"2.0",
  "sourcedir":"",
  "supportedTargets":-1,
  "tvosclassname":null,
  "tvosCocoaPodDependencies":"",
  "tvosCocoaPods":"",
  "tvoscodeinjection":"",
  "tvosdelegatename":null,
  "tvosmaccompilerflags":"",
  "tvosmaclinkerflags":"",
  "tvosplistinject":"",
  "tvosProps":false,
  "tvosSystemFrameworkEntries":[],
  "tvosThirdPartyFrameworkEntries":[],
}