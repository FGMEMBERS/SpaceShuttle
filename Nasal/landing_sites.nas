
# define all Shuttle landing sites in one central location
# Thorsten Renk 2018


var landing_site_array = [];

var landing_site_entry = {
	new: func (coord, name,  shortname, rwy_pri, rwy_sec, function, index) {
	 	var l = { parents: [landing_site_entry] };
		l.coord = coord;
		l.name = name;
		l.shortname = shortname;
		l.rwy_pri = rwy_pri;
		l.rwy_sec = rwy_sec;
		l.function = function;
		l.index = index;
		l.text_vertical_offset = 0.0;
		return l;
		},

};

var coord1 = geo.Coord.new();
coord1.set_latlon(28.615, -80.695, 0.0);
var ls_entry1 = landing_site_entry.new(coord1, "Kennedy Space Center", "KSC", "15", "33", "regular", 1);
append(landing_site_array, ls_entry1);

var coord2 = geo.Coord.new();
coord2.set_latlon(34.722, -120.567, 0.0);
var ls_entry2 = landing_site_entry.new(coord2, "Vandenberg Air Force Base", "VBG", "12", "30", "regular", 2);
ls_entry2.text_vertical_offset = 6.0;
append(landing_site_array, ls_entry2);

var coord3 = geo.Coord.new();
coord3.set_latlon(34.096, -117.884, 0.0);
var ls_entry3 = landing_site_entry.new(coord3, "Edwards Air Force Base", "EDW", "06", "24", "regular", 3);
ls_entry3.text_vertical_offset = -6.0;
append(landing_site_array, ls_entry3);

var coord4 = geo.Coord.new();
coord4.set_latlon(32.936, -106.416, 0.0);
var ls_entry4 = landing_site_entry.new(coord4, "White Sands Space Harbor", "NOR", "14", "32", "regular", 4);
append(landing_site_array, ls_entry4);

var coord5 = geo.Coord.new();
coord5.set_latlon(41.666, -1.042, 0.0);
var ls_entry5 = landing_site_entry.new(coord5, "Zaragoza Airport", "ZZA", "12", "30", "TAL", 5);
append(landing_site_array, ls_entry5);

var coord6 = geo.Coord.new();
coord6.set_latlon(51.682, -1.79, 0.0);
var ls_entry6 = landing_site_entry.new(coord6, "RAF Fairford", "FFA", "09", "27", "TAL", 6);
append(landing_site_array, ls_entry6);

var coord7 = geo.Coord.new();
coord7.set_latlon(13.337, -16.652, 0.0);
var ls_entry7 = landing_site_entry.new(coord7, "Banjul International Airport", "BYD", "14", "32", "TAL", 7);
append(landing_site_array, ls_entry7);

var coord8 = geo.Coord.new();
coord8.set_latlon(37.178, -5.614, 0.0);
var ls_entry8 = landing_site_entry.new(coord8, "Moron Air Base", "MRN", "02", "20", "TAL", 8);
append(landing_site_array, ls_entry8);

var coord9 = geo.Coord.new();
coord9.set_latlon(43.52, 4.92, 0.0);
var ls_entry9 = landing_site_entry.new(coord9, "Le Tube", "FMI", "15", "33", "TAL", 9);
ls_entry9.text_vertical_offset = -6.0;
append(landing_site_array, ls_entry9);

var coord11 = geo.Coord.new();
coord11.set_latlon(32.363, -64.67, 0.0);
var ls_entry11 = landing_site_entry.new(coord11, "Bermuda", "BER", "12", "30", "ECAL", 11);
append(landing_site_array, ls_entry11);

var coord12 = geo.Coord.new();
coord12.set_latlon(44.875, -63.51, 0.0);
var ls_entry12 = landing_site_entry.new(coord12, "Halifax", "YHZ", "05", "23", "ECAL", 12);
append(landing_site_array, ls_entry12);

var coord13 = geo.Coord.new();
coord13.set_latlon(34.272, -77.896, 0.0);
var ls_entry13 = landing_site_entry.new(coord13, "Wilmington", "ILM", "06", "24", "ECAL", 13);
append(landing_site_array, ls_entry13);

var coord14 = geo.Coord.new();
coord14.set_latlon(39.454, -74.568, 0.0);
var ls_entry14 = landing_site_entry.new(coord14, "Atlantic City", "ACY", "13", "31", "ECAL", 14);
append(landing_site_array, ls_entry14);

var coord15 = geo.Coord.new();
coord15.set_latlon(33.675, -78.926, 0.0);
var ls_entry15 = landing_site_entry.new(coord15, "Myrtle Beach", "MYR", "18", "36", "ECAL", 15);
append(landing_site_array, ls_entry15);


var coord16 = geo.Coord.new();
coord16.set_latlon(48.947, -54.560, 0.0);
var ls_entry16 = landing_site_entry.new(coord16, "Gander", "YQX", "03", "21", "ECAL", 16);
append(landing_site_array, ls_entry16);

var coord17 = geo.Coord.new();
coord17.set_latlon(43.0742, -70.820, 0.0);
var ls_entry17 = landing_site_entry.new(coord17, "Pease", "PSM", "16", "34", "ECAL", 17);
append(landing_site_array, ls_entry17);

var coord18 = geo.Coord.new();
coord18.set_latlon(36.81, -76.012, 0.0);
var ls_entry18 = landing_site_entry.new(coord18, "Oceana NAS", "NTU", "05", "23", "ECAL", 18);
append(landing_site_array, ls_entry18);

var coord30 = geo.Coord.new();
coord30.set_latlon(-27.165, -109.415, 0.0);
var ls_entry30 = landing_site_entry.new(coord30, "Easter Island", "IPC", "10", "28", "TAL", 30);
append(landing_site_array, ls_entry30);

var coord31 = geo.Coord.new();
coord31.set_latlon(-7.313, 72.411, 0.0);
var ls_entry31 = landing_site_entry.new(coord31, "Diego Garcia", "JDG", "13", "31", "emergency", 31);
append(landing_site_array, ls_entry31);

var coord33 = geo.Coord.new();
coord33.set_latlon(21.307, -157.929, 0.0);
var ls_entry33 = landing_site_entry.new(coord33, "Honolulu", "HNL", "08", "26", "emergency", 33);
append(landing_site_array, ls_entry33);

var coord34 = geo.Coord.new();
coord34.set_latlon(63.985, -22.618, 0.0);
var ls_entry34 = landing_site_entry.new(coord34, "Keflavik", "IKF", "10", "28", "emergency", 34);
append(landing_site_array, ls_entry34);

var coord35 = geo.Coord.new();
coord35.set_latlon(13.584, 144.934, 0.0);
var ls_entry35 = landing_site_entry.new(coord35, "Andersen Air Force Base", "UAM", "06", "24", "emergency", 35);
append(landing_site_array, ls_entry35);

var coord36 = geo.Coord.new();
coord36.set_latlon(16.73, -22.94, 0.0);
var ls_entry36 = landing_site_entry.new(coord36, "Amilcar Cabral", "CVS", "01", "19", "emergency", 36);
append(landing_site_array, ls_entry36);

var coord37 = geo.Coord.new();
coord37.set_latlon(-7.97, -14.39, 0.0);
var ls_entry37 = landing_site_entry.new(coord37, "Ascension", "HAW", "13", "31", "emergency", 37);
append(landing_site_array, ls_entry37);

var coord38 = geo.Coord.new();
coord38.set_latlon(19.282, 166.63, 0.0);
var ls_entry38 = landing_site_entry.new(coord38, "Wake Island", "WAK", "10", "28", "emergency", 38);
append(landing_site_array, ls_entry38);

var coord39 = geo.Coord.new();
coord39.set_latlon(38.761, -27.09, 0.0);
var ls_entry39 = landing_site_entry.new(coord39, "Lajes Air Base", "LAJ", "15", "33", "emergency", 39);
append(landing_site_array, ls_entry39);
