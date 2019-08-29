/*
this file (main.js) includes some helper code

1) call wwr_start() to begin requests to the server

2) you can call wwr_req_recur("REQUEST", interval) to set recurring requests (such as status updates). Interval is in milliseconds.

3) you can call wwr_req_recur_cancel("REQUEST") to remove a recurring request that was previously set.

4) you can call wwr_req("REQUEST") to send a one-time request.

5) g_wwr_timer_freq can be overridden before calling wwr_star() to increase the timer frequency 
(the default is 100, for 100ms)

6) Responses: 

You should define a function named wwr_onreply:

function wwr_onreply(results) {
  var ar = results.split("\n");
  var x;
  for (x=0;x<ar.length;x++)
  {
    var tok = ar[x].split("\t");
    // tok is a list of parameters, the first being the command
  }
}

See index.html for an example.

Reference:

All interaction with the server is done via 

wwr_req("command;command;command") 
or 
wwr_req_recur("command;command",interval):


(which are internally sent as /_/command;command;command;command to the server)

There can be any reasonable number of commands, separated by semicolons. They will be executed in order, and responses 
may be given, depending on the commands and the server.

The format of the response is a list of lines (separated by \n), and each line
has tokens separated by \t. 

Valid commands:

* numeric values 0-65535 
REAPER command IDs. (todo: support for registered names, too). These typically do not have any response.

* _123456789abcdef... 
REAPER plug-in registered command IDs (also used by ReaScripts and custom actions)

* TRANSPORT
Returns a line including (note that the spaces are here for readability, there
is actually only tabs between fields):
  TRANSPORT \t playstate \t position_seconds \t isRepeatOn \t position_string \t position_string_beats

playstate is 0 for stopped, 1 for playing, 2 for paused, 5 for recording, and 6 for record paused.

isRepeatOn will be nonzero if repeat is enabled.

position_string is always in the project timeline format (time, beats, etc), position_string_beats is always in measures.beats.hundredths format.

* BEATPOS
*
Returns a line:

BEATPOS \t playstate \t position_seconds \t full_beat_position \t measure_cnt \t beats_in_measure \t ts_numerator \t ts_denominator

* NTRACK

Requests track count. Returns a line:

  NTRACK \t value

value is 0 (no tracks, just master track) or greater. 

* TRACK  or   TRACK/index   or TRACK/start-end

Requests information about all tracks, a single track, or a range of tracks.
Note that the indices used are 0 for master, 1 for first user track, etc.

Returns any number of track lines:

  TRACK \t tracknumber \t trackname \t trackflags \t volume \t pan \t last_meter_peak \t last_meter_pos \t width/pan2 \t panmode \t sendcnt \t recvcnt \t hwoutcnt \t color

    tracknumber is 0 for master, 1 for first track, etc.
    trackname is the name of the track, or MASTER
    trackflags includes various bits (test with parseInt(field)&1 etc):
      1: folder
      2: selected
      4: has FX
      8: muted
      16: soloed (32: solo-in-place)
      64: record armed
      128: record monitoring on
      256: record monitoring auto
    volume is track volume, where 0 is -inf, 1 is +0dB, etc. see mkvolstr for dB conversions
    pan is -1..1, where -1 is full left, 0 is centered, 1 is full right
    last_meter_peak and last_meter_pos are integers that are dB*10, so -100 would be -10dB.
    color is in the form of 0xaarrggbb, nonzero if a custom color set
  
* GET/TRACK/x/SEND/y

Gets state for track x hardware output/send y. Returns a line:

SEND \t x \t y \t flags \t volume \t pan \t other_track_index

Use y=-1 for first receive, -2 for second, etc.

other_track_index is -1 if hardware output

flags & 8 is true if send/output muted

* GET/TRACK/index/xxxxxx

Requests information for track "index", via GetSetMediaTrackInfo(). See the REAPER API documentation for which
strings are acceptable, but for example you can query the track record input index for the first track via:

  GET/TRACK/1/I_RECINPUT

The returned string will be:

GET/TRACK/1/I_RECINPUT\t <index>

(if an error occurs you may get nothing back at all, or you might get the GET string back but with no parameter)

String will have newlines/tabs/backslashes encoded as \\n, \\t and \\. 

* SET/TRACK/index/xxxxx/value

Similar to GET/TRACK/index/xxxxx, but sets the value of this item. You probably will want to follow this with a SET/UNDO command, below. This will not give any response.

* SET/TRACK/index/VOL/value

Special case of SET/TRACK/index/xxxx, sets volume for a track via control surface API (meaning it respects automation modes etc). If value starts with + or -, then adjustment is relative (in dB), otherwise adjustment is absolute (1=0dB, etc). If value ends in "g", then ganging is ignored. Does not need SET/UNDO.

* SET/TRACK/index/PAN/value

Special case of SET/TRACK/index/xxxx, sets pan for a track via control surface API. If value starts with + or -, adjustment is relative. Range is always -1..1. If value ends in "g", then ganging is ignored. Does not need SET/UNDO.
*
* SET/TRACK/index/WIDTH/value

Special case of SET/TRACK/index/xxxx, sets width for a track via control surface API. If value starts with + or -, adjustment is relative. Range is always -1..1. If value ends in "g", then ganging is ignored. Does not need SET/UNDO.

* SET/TRACK/index/MUTE/value

Special case of SET/TRACK/index/xxxx, sets mute for track. if value is <0, mute is toggled. Does not need SET/UNDO.

* SET/TRACK/index/SOLO/value

Special case of SET/TRACK/index/xxxx, sets solo for track. if value is <0, solo is toggled. Does not need SET/UNDO.

* SET/TRACK/index/FX/value

Special case of SET/TRACK/index/xxxx, sets fx enabled for track. if value is <0, fx enabled is toggled. Does not need SET/UNDO.

* SET/TRACK/index/RECARM/value

Special case of SET/TRACK/index/xxxx, sets record arm enabled for track. if value is <0, record arm enabled is toggled. Does not need SET/UNDO.

* SET/TRACK/index/RECMON/value

Special case of SET/TRACK/index/xxxx, sets record monitoring for track. if value is <0, record monitoring is cycled, otherwise 1=on, 2=auto. Does not need SET/UNDO.

* SET/TRACK/index/SEL/value

Special case of SET/TRACK/index/xxxx, sets selection for track. if value is <0, selection is toggled. Does not need SET/UNDO.


* SET/UNDO/message

Adds an undo point, useful if you have modified anything that needs it.

* SET/UNDO_BEGIN

Begins an undo block (should always be matched with SET/UNDO_END!)

* SET/UNDO_END/message

Ends an undo block

* SET/REPEAT/val

If val is -1, toggles repeat, 0 disables repeat, 1 enables repeat.

* GET/REPEAT

Returns: 

GET/REPEAT \t val  

where val is 0 or 1.

* SET/TRACK/x/SEND/y/MUTE/value

Sets hardware output/send mute for track x, send y. value can be -1 to toggle.

Use y=-1 for first receive, -2 for second, etc.

* SET/TRACK/x/SEND/y/VOL/value

Sets hardware output/send volume (1.0 = +0dB) for track x, send y. append e to value to treat as "end" (capture), or "E" to treat as an instant edit.

Use y=-1 for first receive, -2 for second, etc.

* SET/TRACK/x/SEND/y/PAN/value

Sets hardware output/send pan (0=center, -1=left) for track x, send y. append e to value to treat as "end" (capture), or "E" to treat as an instant edit.

Use y=-1 for first receive, -2 for second, etc.

* SET/POS/value_in_seconds

Sets edit cursor position (seeking playback) to value_in_seconds

* SET/POS_STR/value_string

Sets edit cursor position (seeking playback) to value_string (format auto-detected)

r1 goes to region ID 1, m1 to marker 1, R1 to first timeline region, M1 to first timeline marker


* LYRICS/trackindex

Returns: 

LYRICS \t trackindex \t beat_position \t lyric \t ...

Retrieves MIDI lyrics for trackindex.

String will have newlines/tabs/backslashes encoded as \\n, \\t and \\. Length is limited to around 16k.

* SET/PROJEXTSTATE/section/key/value

See SetProjExtState() API -- section, key, value should be urlencoded 

* GET/PROJEXTSTATE/section/key

Returns:

PROJEXTSTATE \t section \t key \t string

See: GetProjExtState() API

String will have newlines/tabs/backslashes encoded as \\n, \\t and \\. Length is limited to around 16k.

* GET/EXTSTATE/section/key

Returns:

EXTSTATE \t section \t key \t string

See GetExtState() API 

String will have newlines/tabs/backslashes encoded as \\n, \\t and \\

* SET/EXTSTATE/section/key/value

See SetExtState() API (persist=false) section, key, value should be urlencoded 

* SET/EXTSTATEPERSIST/section/key/value

See SetExtState() API (persist=true) section, key, value should be urlencoded 

* GET/command_id 

command_id can be numeric or _123456789abcdef...  registered ID.

Returns:

CMDSTATE \t command_id \t state

state>0 for on, 0=off, -1=no state


* OSC/oscstring[:value]

Sends an OSC message through the default processing (Default.ReaperOSC) and MIDI-learn/action mappings. oscstring:value will be urldecoded.

* MARKER
* REGION

Returns a list of all markers or regions, in the format of:

MARKER_LIST
MARKER \t name \t ID \t position [\t color]
...
MARKER_LIST_END

REGION_LIST
REGION \t name \t ID \t start-position \t end-position [\t color]
...
REGION_LIST_END

color is in the form of 0xaarrggbb, nonzero if a custom color set

*/

function initxmlhttp() {
  var xmlhttp=false;
/*@cc_on @*/
/*@if (@_jscript_version >= 5)
// JScript gives us Conditional compilation, we can cope with old IE versions.
// and security blocked creation of the objects.
 try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {
  try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); } catch (E) {
   xmlhttp = false;
  }
 }
@end @*/
  if (!xmlhttp && typeof XMLHttpRequest!='undefined') { 
    try { xmlhttp = new XMLHttpRequest(); } catch (e) { xmlhttp=false; } 
  }
  if (!xmlhttp && window.createRequest) { try { xmlhttp = window.createRequest(); } catch (e) { xmlhttp=false; } }
  return xmlhttp;
}


var g_wwr_timer_freq=100;
var g_wwr_req_list = "", g_wwr_req_list2 = "";
var g_wwr_req_recur = new Array(), g_wwr_req = null, g_wwr_timer = null, g_wwr_timer2 = null;
var g_wwr_errcnt = 0;

function wwr_run_update()
{
  g_wwr_timer = null;
  if (!g_wwr_req) g_wwr_req = initxmlhttp();
  if (!g_wwr_req) { alert("no xml http support"); return; }

  // populate any periodic requests
  var d = (new Date).getTime();
  for (var x=0;x<g_wwr_req_recur.length;x++) {
    if (g_wwr_req_recur[x][2] < d) {
      g_wwr_req_recur[x][2] = d + g_wwr_req_recur[x][1];
      g_wwr_req_list2 += g_wwr_req_recur[x][0] + ";";
    }
  }
  g_wwr_req_list += g_wwr_req_list2;
  g_wwr_req_list2 = "";

  if (g_wwr_req_list != "") {
    g_wwr_req.open("GET","/_/" + g_wwr_req_list,true);
    g_wwr_req.onreadystatechange=function() {
      if (g_wwr_req.readyState==4) {
        if (g_wwr_timer2) { clearTimeout(g_wwr_timer2); g_wwr_timer2=null; }
        if (g_wwr_req.responseText != "") {
          g_wwr_errcnt=0;
          wwr_onreply(g_wwr_req.responseText,d);
        } else if (g_wwr_req.getResponseHeader("Server") == null) {
          if (g_wwr_errcnt < 8) g_wwr_errcnt++;
        }
        if (g_wwr_errcnt > 2) g_wwr_timer = window.setTimeout(wwr_run_update, 100<<(g_wwr_errcnt-3));
        else wwr_run_update();
      }
    };

    if (g_wwr_timer2) clearTimeout(g_wwr_timer2); 
    g_wwr_timer2 = window.setTimeout(function() {
      g_wwr_timer2=null;
      if (g_wwr_req.readyState!=0 && g_wwr_req.readyState!=4) {
         if (g_wwr_timer) { clearTimeout(g_wwr_timer); g_wwr_timer=null; }
         g_wwr_req.abort();
         if (g_wwr_errcnt < 8) g_wwr_errcnt++;

         if (g_wwr_errcnt > 2) g_wwr_timer = window.setTimeout(wwr_run_update, 100<<(g_wwr_errcnt-3));
         else wwr_run_update();
      }
    },3000);
    
    g_wwr_req_list = "";
    g_wwr_req.send(null);
  } else {
    g_wwr_timer = window.setTimeout(wwr_run_update,g_wwr_timer_freq);
  }
}


function wwr_start() { wwr_run_update(); }
function wwr_req(name) { g_wwr_req_list += name + ";"; }
function wwr_req_recur(name, interval) { g_wwr_req_recur.push([name,interval,0]); }
function wwr_req_recur_cancel(name) { 
  var i;
  for (i=0; i < g_wwr_req_recur.length; ++i) {
    if (g_wwr_req_recur[i] && g_wwr_req_recur[i][0] === name) {
      g_wwr_req_recur.splice(i,1);
      break;
    }
  }
}

function mkvolstr(vol) {
  var v = parseFloat(vol);
  if (v < 0.00000002980232) return "-inf dB";
  v = Math.log(v)*8.68588963806;
  return v.toFixed(2) + " dB";
}

function mkpanstr(pan) {
  if (Math.abs(pan) < 0.001) return "center";
  if (pan > 0) return (pan*100).toFixed(0) + "%R";
  return (pan*-100).toFixed(0) + "%L";
}

function simple_unescape(v) {
  return String(v).replace(/\\t/g,"\t").replace(/\\n/g,"\n").replace(/\\\\/g,"\\");
}
