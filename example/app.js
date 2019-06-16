// Example app for com.kosso.swifTi 
// Kosso June 2019.


var col_on = '#ffffff';
var col_off = '#000000';
var colors = [{"colorId":0,"hexString":"#000000","rgb":{"r":0,"g":0,"b":0},"hsl":{"h":0,"s":0,"l":0},"name":"Black"},{"colorId":1,"hexString":"#800000","rgb":{"r":128,"g":0,"b":0},"hsl":{"h":0,"s":100,"l":25},"name":"Maroon"},{"colorId":2,"hexString":"#008000","rgb":{"r":0,"g":128,"b":0},"hsl":{"h":120,"s":100,"l":25},"name":"Green"},{"colorId":3,"hexString":"#808000","rgb":{"r":128,"g":128,"b":0},"hsl":{"h":60,"s":100,"l":25},"name":"Olive"},{"colorId":4,"hexString":"#000080","rgb":{"r":0,"g":0,"b":128},"hsl":{"h":240,"s":100,"l":25},"name":"Navy"},{"colorId":5,"hexString":"#800080","rgb":{"r":128,"g":0,"b":128},"hsl":{"h":300,"s":100,"l":25},"name":"Purple"},{"colorId":6,"hexString":"#008080","rgb":{"r":0,"g":128,"b":128},"hsl":{"h":180,"s":100,"l":25},"name":"Teal"},{"colorId":7,"hexString":"#c0c0c0","rgb":{"r":192,"g":192,"b":192},"hsl":{"h":0,"s":0,"l":75},"name":"Silver"},{"colorId":8,"hexString":"#808080","rgb":{"r":128,"g":128,"b":128},"hsl":{"h":0,"s":0,"l":50},"name":"Grey"},{"colorId":9,"hexString":"#ff0000","rgb":{"r":255,"g":0,"b":0},"hsl":{"h":0,"s":100,"l":50},"name":"Red"},{"colorId":10,"hexString":"#00ff00","rgb":{"r":0,"g":255,"b":0},"hsl":{"h":120,"s":100,"l":50},"name":"Lime"},{"colorId":11,"hexString":"#ffff00","rgb":{"r":255,"g":255,"b":0},"hsl":{"h":60,"s":100,"l":50},"name":"Yellow"},{"colorId":12,"hexString":"#0000ff","rgb":{"r":0,"g":0,"b":255},"hsl":{"h":240,"s":100,"l":50},"name":"Blue"},{"colorId":13,"hexString":"#ff00ff","rgb":{"r":255,"g":0,"b":255},"hsl":{"h":300,"s":100,"l":50},"name":"Fuchsia"},{"colorId":14,"hexString":"#00ffff","rgb":{"r":0,"g":255,"b":255},"hsl":{"h":180,"s":100,"l":50},"name":"Aqua"},{"colorId":15,"hexString":"#ffffff","rgb":{"r":255,"g":255,"b":255},"hsl":{"h":0,"s":0,"l":100},"name":"White"}];
var cells = [];
var cellindex = 15; // white default

var dw = getDeviceWidth();

var win = Ti.UI.createWindow({
    top:40,
    backgroundColor: '#333',
    tintColor:'white',
    extendSafeArea:true
});


var scrollView = Ti.UI.createScrollView({
    top:20,
    left:0,
    right:0,
    zIndex:1,
    backgroundColor:'transparent',
    bottom:0,
    contentHeight:Ti.UI.SIZE,
    scrollType:'vertical',
    layout:'vertical'
});

win.add(scrollView);


var label = Ti.UI.createLabel({
	text:'SwifTi Testing',
	textAlign:'center',
	top:0,
	width:Ti.UI.SIZE,
	height:Ti.UI.SIZE,
	color:'white',
	font:{fontSize:20}
});
scrollView.add(label);



var label4 = Ti.UI.createLabel({
	text:'click below to toggle microphone listener',
	textAlign:'center',
	top:10,
	width:Ti.UI.SIZE,
	height:Ti.UI.SIZE,
	color:'#ccc',
	font:{fontSize:10}
});
scrollView.add(label4);

// Here comes the actual module tests!!!!!!!! >>> woo! ....

var swifti = require('com.kosso.swifti');
console.log('loaded: ', swifti);
// console.log('swifti.example(): ', swifti.example());
// console.log('swifti.exampleProp: ', swifti.exampleProp);
// swifti.exampleProp = 'stop brexit';
// console.log('after setting swifti.exampleProp: ', swifti.exampleProp);


// Here's our test view, built with Swift in the module...
// It will contain some other tests UIView stuff while learning...
var vu = swifti.createView({
    height:280,
    top:10,
    left:20,
    width:dw - 40,
    bottom:10,
    borderRadius:10,
    borderColor:'#777'        
});

// Proxy method tests 
// vu.helloproxy();
// vu._setBackgroundColor('transparent');
// vu._setWaveformColor('#ff0000');
// vu._setWaveformColor('#ff0000');
// vu._setPrimaryLineWidth(3.0)
// vu._setSecondaryLineWidth(2.0)



vu.addEventListener('click', function(e){
    console.log('vu was clicked: ', vu.isRunning());

    if(vu.isRunning()){
        vu.stopSiriWave();

        // test debugging... 
        var buffer = vu._getBuffer();
        console.log(buffer);
        console.log('buffer length: ', buffer.length);
    } else {
        vu.startSiriWave();
    }
});

scrollView.add(vu);

vu.addSiriWave();
// vu.startSiriWave();


var label2 = Ti.UI.createLabel({
	text:'change amplitude',
	textAlign:'center',
	top:0,
	width:Ti.UI.SIZE,
	height:Ti.UI.SIZE,
	color:'#ccc',
	font:{fontSize:10}
});
scrollView.add(label2);

var slider_amp = Ti.UI.createSlider({
    top:10,
    left:40,
    right:40,
    value:0.5,
    min: 0,
    max: 1    
});
slider_amp.addEventListener('change', function(e) {
        // console.log( e.value );
        vu._setAmplitude(e.value);
});
scrollView.add(slider_amp);



var label3 = Ti.UI.createLabel({
	text:'change waveform colour',
	textAlign:'center',
	top:10,
	width:Ti.UI.SIZE,
	height:Ti.UI.SIZE,
	color:'#ccc',
	font:{fontSize:10}
});
scrollView.add(label3);



var dh = getDeviceWidth();

var wh = dw;
if(dh < wh){
    wh = dh;
}
wh = wh - 40;
// Demo colour picker
var picker = Ti.UI.createView({
    top:10,
    width:wh,
    height:(wh / 8) * 2,
    left: 20,
    backgroundColor:'#555',
    layout:'horizontal'
});

for(var i = 0; i < 16; i++){
    var cell = Ti.UI.createView({
        width:(wh / 8),
        height:(wh / 8),
        top:0,
        left:0,
        backgroundColor:colors[i].hexString
    });

    cell.info = colors[i];
    
    if(colors[i].hexString === col_on){
        cell.borderColor = 'white';
        cell.borderWidth = 2;
        console.log('set default colour: ' + colors[i].name);
    }

    cell.addEventListener('click', function(e){
        console.log(e.source.info.hexString);
        cells[cellindex].borderWidth = 0;
        cells[e.source.info.colorId].borderWidth = 2;
        cells[e.source.info.colorId].borderColor = 'white';
        cellindex = e.source.info.colorId;
        col_on = e.source.info.hexString;

        // test set waveform colour 
        vu._setWaveformColor(col_on);

    });
    cells.push(cell);
    picker.add(cells[cells.length -1]);
}
scrollView.add(picker);



var v = Ti.UI.createView({
    height:60
});
scrollView.add(v);



win.open();




function getDeviceWidth(){
    if(Ti.Platform.osname==='android'){
        return Math.round(Ti.Platform.displayCaps.platformWidth / Ti.Platform.displayCaps.logicalDensityFactor);
    }
    return Ti.Platform.displayCaps.platformWidth;
}

function getDeviceHeight(){
    if(Ti.Platform.osname==='android'){
        return Math.round(Ti.Platform.displayCaps.platformHeight / Ti.Platform.displayCaps.logicalDensityFactor);
    }
    return Ti.Platform.displayCaps.platformHeight;
}
