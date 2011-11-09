/* Insert Sound Icon */
var mp3path = "/mp3/";
var mp3files = new Array(

);

this.addScript("playsound", 
""
+ "function playsound(sndfile)\n"
+ "{\n"
+ "    var folderPath = /.*\\//i.exec(this.URL);\n"
+ "    sndfile = folderPath + sndfile;\n"
+ "    var args = {\n"
+ "        URL: sndfile,\n"
+ "        mimeType: \"audio/mp3\",\n"
+ "        doc: this,\n"
+ "        settings: {\n"
+ "            players: app.media.getPlayers(\"audio/mp3\"),\n"
+ "            windowType: app.media.windowType.floating,\n"
+ "            floating: {height: 72, width: 128},\n"
+ "            data: app.media.getURLData(sndfile, \"audio/mp3\"),\n"
+ "            showUI: true\n"
+ "        },\n"
+ "\n"
+ "    };\n"
+ "    var settings = app.media.getURLSettings(args);\n"
+ "    args.settings = settings;\n"
+ "    app.media.openPlayer(args);\n"
+ "}\n"
);

// getPageBox, the default is "Crop"
//var aPage = this.getPageBox();
var w = 30; //width of each icon
//var widthPage = aPage[2] - aPage[0];

/*
  Import icons into the document. This uses the file named sound.pdf
*/
this.importIcon("sound", "snd.pdf",0);

//var folderPath = /.*\//i.exec(this.URL);
var i = 0;

for (var nPage = 0; nPage <= this.numPages; nPage++){

    for(; i < mp3files.length; i++){

        if(mp3files[i] < nPage){
            i++;
        }
        if(mp3files[i] >= nPage){
            break;
        }
    }

    if(i >= mp3files.length){
        break;
    }
    if(mp3files[i] > nPage){
        continue;
    }

    console.println("i=" + i);
    console.println("nPage=" + nPage);

    var sndfile = mp3path + mp3files[i] + ".mp3";

    // Create the fieds;
    var snd = this.addField("sound" + i, "button", nPage, [70,70, 70 + w, 70 + w]);
    snd.buttonPosition = position.iconOnly;
    snd.highlight = highlight.p;
    snd.buttonSetIcon(this.getIcon("sound"),0);
    snd.setAction("MouseUp","playsound(\"" + sndfile + "\")");
    snd.display = display.noPrint;

}
