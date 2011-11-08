/* Insert Sound Icon */
var mp3path = "/g6.mp3/";
var maxPage = 527;
var mp3files = new Array(
"002","003","004","005","006","007","008","009","010","011","018","019","020","021","024","026","028","029","030","031","032","033","034","035","036","037","038","042","044","045","046","047","048","049","050","051","052","056","058","059","060","061","062","063","064","065","066","067","068","069","070","074","076","077","078","079","080","081","082","092","094","096","097","098","099","100","101","102","103","104","105","106","107","108","112","114","115","116","117","118","119","120","124","126","127","128","129","130","131","132","136","138","139","140","141","142","143","144","145","146","155","156","158","159","160","161","164","166","168","169","170","171","172","173","174","178","180","181","182","183","184","185","186","190","192","193","194","195","196","197","198","208","210","212","213","214","215","216","217","218","222","224","225","227","228","229","230","234","236","237","238","239","240","241","242","246","248","249","250","251","252","253","254","258","260","261","262","263","264","274","276","278","279","280","281","282","283","284","285","286","287","288","289","290","294","296","297","298","300","301","302","303","304","305","306","310","312","313","314","315","316","320","322","323","324","325","326","335","336","338","339","340","341","344","346","348","349","350","351","352","353","354","355","356","357","358","362","364","365","366","367","368","369","370","374","376","377","378","379","380","381","382","383","384","394","396","398","399","400","401","402","403","404","405","406","410","412","413","414","415","416","417","418","422","424","425","426","427","428","429","430","434","436","437","438","439","440","441","442","443","444","445","446","447","448","456","457","458","460","461","462","463","465","466","467","468","469","470","471","473","474","475","476","477","478","479","481","482","483","484","485","486","487","489","490","491","492","493","495","496","497","498","499","501"

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
this.importIcon("sound", "snd.pdf",1);

//var folderPath = /.*\//i.exec(this.URL);
var i = 0;

for (var nPage = basePage; nPage <= maxPage; nPage++){

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
