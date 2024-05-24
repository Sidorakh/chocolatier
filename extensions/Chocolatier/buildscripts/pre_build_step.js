const fs = require('fs');
const path = require('path');

const fname = process.env.YYEXTOPT_Chocolatier_config_file;

/** 
 * @typedef {Object} GXOption
 * @prop {string} name
 * @prop {string} label
 */

/**
 * @typedef GXOptionRange
 * @prop {string} name
 * @prop {string} label
 * @prop {"range"} type
 * @prop {number} value
 * @prop {number} min
 * @prop {number} max
 * @prop {number} step
 */
/**
 * @typedef GXOptionBoolean
 * @prop {string} name
 * @prop {string} label
 * @prop {"boolean"} type
 * @prop {boolean} value;
 */
/**
 * @typedef GXOptionString
 * @prop {string} name
 * @prop {string} label
 * @prop {"string"} type
 * @prop {string} value
 */
/**
 * @typedef GXOptionColor
 * @prop {"color"} type
 * @prop {string} name
 * @prop {string} label
 * @prop {string} value
 */
/**
 * @typedef GXOptionSelect
 * @prop {"select"} type
 * @prop {string} name
 * @prop {string} label
 * @prop {string[]} options
 * @prop {string} value
 * @prop {string} description
 */
/**
 * @typedef {GXOptionRange | GXOptionBoolean | GXOptionString | GXOptionColor | GXOptionSelect} GXOption
 */

/**
 * @typedef GXSection
 * @prop {"section"} type
 * @prop {string} name
 * @prop {string} label
 * @prop {(GXSection | GXOption)[]} children
 */

console.log(`Loading config from datafiles/${fname}`);

const config = require(path.join(process.env.YYprojectDir,'datafiles',fname));

const lively_fields = [];
const wpengine_fields = [];
walk_base_config(config,lively_fields,wpengine_fields,'');


const lively_info = {
    AppVersion: process.env.YYEXTOPT_Chocolatier_version,
    Title: process.env.YYEXTOPT_Chocolatier_title,
    Thumbnail: '',
    Desc: process.env.YYEXTOPT_Chocolatier_description,
    Author: process.env.YYEXTOPT_Chocolatier_author,
    License: process.env.YYEXTOPT_Chocolatier_license,
    FileName: "index.html",
    Arguments: "--system-information --system-nowplaying --pause-event true --audio",
    IsAbsolutePath: false,
};

const wpengine_info = {
    contentrating: process.env.YYEXTOPT_Chocolatier_content_rating,
    description: process.env.YYEXTOPT_Chocolatier_description,
    file: 'index.html',
    general: {
        properties:{},
        supportsaudioprocessing:true,
    },
    preview: '',
    tags: process.env.YYEXTOPT_Chocolatier_tags.split(','),
    title: process.env.YYEXTOPT_Chocolatier_title,
    type: 'web',
    version: process.env.YYEXTOPT_Chocolatier_version,
}

// Set up thumbnails (if they exist)
if (process.env.YYEXTOPT_Chocolatier_thumbnail != "") {
    const thumb = path.join(process.env.YYprojectDir,'datafiles',process.env.YYEXTOPT_Chocolatier_thumbnail);
    if (fs.existsSync(thumb)) {
        fs.copyFileSync(thumb,path.join(process.env.YYoutputFolder,process.env.YYEXTOPT_Chocolatier_thumbnail));
        lively_info.Thumbnail = process.env.YYEXTOPT_Chocolatier_thumbnail;
        wpengine_info.preview = process.env.YYEXTOPT_Chocolatier_thumbnail;
        
    }
}

// Add config to Lively Wallpaper
const lively = {};
for (const field of lively_fields) {
    const key = field._key;
    delete field._key;
    lively[key] = field;

}

// Add config to Wallpaper Engine
let i=0;
for (const field of wpengine_fields) {
    const key = field._key;
    delete field._key;
    field.index = i;
    field.order = i + 100;
    wpengine_info.general.properties[key] = field;
    i += 1;
}

fs.writeFileSync(path.join(process.env.YYoutputFolder,'LivelyProperties.json'),JSON.stringify(lively,null,4));
fs.writeFileSync(path.join(process.env.YYoutputFolder,'LivelyInfo.json'),JSON.stringify(lively_info,null,4));
fs.writeFileSync(path.join(process.env.YYoutputFolder,'project.json'),JSON.stringify(wpengine_info,null,4));

function lively_write_section(/** @type {GXSection} */ section,key_path) {
    return {
        _key: key_path,
        type: 'label',
        value: section.label,
    };
}

function wpengine_write_section(/** @type {GXSection} */ section, key_path) {
    return {
        _key: key_path,
        type: "group",
        text: section.label,
        value: '',
    }
}

function lively_write_slider(/** @type {GXOptionRange} */ option,key_path) {
    return {
        _key: key_path,
        type: 'slider',
        help: '',
        text: option.label,
        value: option.value,
        min: option.min,
        max: option.max,
        step: option.step,
    }
}

function wpengine_write_slider(/** @type {GXOptionRange} */ option, key_path) {
    return {
        _key: key_path,
        type: 'slider',
        fraction: true, //Math.floor(option.step) == option.step,
        min: option.min,
        max: option.max,
        precision: `${option.step}`.length, // that's a best guess
        step: option.step,
        text: option.label,
        value: option.value,
    }
}

function lively_write_checkbox(/** @type {GXOptionBoolean} */ option, key_path) {
    return {
        _key: key_path,
        type: 'checkbox',
        text: option.label,
        value: option.value,
    }
}

function wpengine_write_checkbox(/** @type {GXOptionBoolean} */ option, key_path) {
    return {
        _key: key_path,
        type: 'bool',
        text: option.label,
        value: option.value,
    }
}

function lively_write_textbox(/** @type {GXOptionString} */ option, key_path) {
    return {
        _key: key_path,
        type: 'textbox',
        text: option.label,
        value: option.value,
    }
}

function wpengine_write_textbox(/** @type {GXOptionString} */ option, key_path) {
    return {
        _key: key_path,
        type: 'textinput',
        text: option.label,
        value: option.value,
    }

}

function lively_write_color(/** @type {GXOptionColor} */ option, key_path) {
    return {
        _key: key_path,
        type: 'color',
        text: option.label,
        value: option.value,
    }
}

function wpengine_write_color(/** @type {GXOptionColor} */ option, key_path) {
    const rgb = option.value.slice(1);
    const r = rgb.slice(0,2);
    const g = rgb.slice(2,2);
    const b = rgb.slice(4,2);

    const color = `${parseInt(r,16)/255} ${parseInt(g,16)/255} ${parseInt(b,16)/255}`;

    return {
        _key: key_path,
        type: 'color',
        text: option.label,
        value: color,
    }
}


function lively_write_dropdown(/** @type {GXOptionSelect} */ option, key_path) {
    return {
        _key: key_path,
        type: 'dropdown',
        text: option.label,
        value: option.options.indexOf(option.value),
        items: option.options,
    }
}

function wpengine_write_dropdown(/** @type {GXOptionSelect} */ option, key_path) {
    return {
        _key: key_path,
        type: 'combo',
        options: option.options.map((v,i)=>({label: v, value: `${i}`})),
        value: `${option.options.indexOf(option.value)}`,
    }
}


function walk_base_config(/** @type {(GXSection | GXOption)[]} */ base,/** @type {Array} */ lively,/** @type {Array} */ wpengine,/** @type {string} */ mypath) {
    for (const option of base) {
        const key_path = (mypath === '' ? '' : mypath + '.') + option.name;
        if (option.type == 'section') {
            // it's a section!
            lively.push(lively_write_section(option,key_path));
            wpengine.push(wpengine_write_section(option,key_path));
            // insert WPEngine here later
            walk_base_config(option.children,lively,wpengine,key_path);
        }
        if (option.type == 'range') {
            lively.push(lively_write_slider(option,key_path));
            wpengine.push(wpengine_write_slider(option,key_path));
        }
        if (option.type == 'boolean') {
            lively.push(lively_write_checkbox(option,key_path));
            wpengine.push(wpengine_write_checkbox(option,key_path));
        }
        if (option.type == 'string' || option.type == 'multiline_string') {
            lively.push(lively_write_textbox(option,key_path));
            wpengine.push(wpengine_write_textbox(option,key_path));
        }
        if (option.type == 'color' || option.type == 'colour') {
            if (typeof(option.value) === 'number') {
                const bgr = option.value;
                const rgb = ((bgr & 0xFF) << 16) | ( bgr & 0xFF00) | (bgr >> 16);
                const colour = rgb.toString(16)
                option.value = `#${colour}`;
            }
            lively.push(lively_write_color(option,key_path));
            wpengine.push(wpengine_write_color(option,key_path));
        }
        if (option.type == 'select') {
            lively.push(lively_write_dropdown(option,key_path));
            wpengine.push(wpengine_write_dropdown(option,key_path));
        }
    }
}