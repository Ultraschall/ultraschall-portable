-- written by Meo Mespotine mespotine.de 2nd of June 2018
-- for the ultraschall.fm-project

-- requires Reaper 5.80 and SWS 2.9.7

-- This script shows altered integer and double-float-settings for all config-variables available in Reaper, that can be used by
-- the SWS-functions SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar() and SNM_SetDoubleConfigVar()
-- where you pass the variable-name as parameter "varname".
-- This script also shows bitwise-representation of the variable's-value, so you can work easily with bitfields.

-- To use this script, just copy the variable-names from the following commentsection, which contains the available 
-- variables for Reaper 5.80 and start the script or click NO in the MessageBox after starting the script.

-- Change settings in the preferences/project-settings/render-dialog-window to see, which variable 
-- contains which value for which setting. There are also some other Reaper-settings, that can be accessed
-- that way. Just experiment and see, what you can change. The names of the variables are a hint to, what can be
-- accessed.

-- Feel free to document the variable-settings(some seem to be identically named, as settings in reaper.ini) ;)
-- Keep in mind, some of the variables are bitmask-variables and contain the values for several 
-- checkboxes(e.g. in the preferences-dialog).

-- IMPORANT! This script has an issue with float-variables, when the float is set as an integer, it's changes will not be shown.
--           For instance, when setting projmaxlen (maximum project-length) in Project Settings, it will not update, if you 
--           set the value to 1.000, but it will update it, when you set it to 1.001(triggering the float-section of the value).
--           So when reverse-engineering floats, keep in mind to set the float-part of the value, or it will not show up!

--[[
__numcpu
acidimport
actionmenu
adjreclat
adjrecmanlat
adjrecmanlatin
allstereopairs
altpeaks
altpeaksopathlist
altpeakspath
alwaysallowkb
aot
applyfxtail
audioasync
audiocloseinactive
audioclosestop
audioprshift
audiothreadpr
autoclosetrackwnds
automute
automuteflags
automuteval
autonbworkerthreads
autoreturntime
autoreturntime_action
autosaveint
autosavemode
autoxfade
copyimpmedia
cpuallowed
csurfrate
ctrlcopyitem
cueitems
custommenu
defautomode
defenvs
deffadelen
deffadeshape
defhwvol
defpitchcfg
defrenderpath
defsavepath
defsendflag
defsendvol
defsplitxfadelen
deftrackrecflags
deftrackrecinput
deftrackvol
defvzoom
defxfadeshape
disabledxscan
disk_peakmmap2
disk_rdblksex
disk_rdmodeex
disk_rdsizeex
disk_wrblks
disk_wrblks2
disk_wrmode
disk_wrsize
diskcheck
diskcheckmb
edit_fontsize
env_autoadd
env_deffoc
env_ol_minh
env_options
env_reduce
envattach
envclicksegmode
envlanes
envtranstime
envtrimadjmode
envwritepasschg
errnowarn
fadeeditflags
fadeeditlink
fadeeditpostsel
fadeeditpresel
feedbackmode
fullscreenRectB
fullscreenRectL
fullscreenRectR
fullscreenRectT
fxdenorm
fxfloat_focus
fxresize
g_config_project
g_markerlist_updcnt
griddot
gridinbg
gridinbg2
groupdispmode
guidelines2
handzoom
help
hwfadex
hwoutfx_bypass
ide_colors
insertmtrack
isFullscreen
itemclickmovecurs
itemdblclk
itemeditpr
itemfade_minheight
itemfade_minwidth
itemfadehandle_maxwidth
itemfxtail
itemicons
itemicons_minheight
itemlabel_minheight
itemlowerhalf_minheight
itemmixflag
itemprops
itemprops_timemode
itemsnap
itemtexthide
itemtimelock
itemvolmode
kbd_usealt
labelitems2
lastthemefn5
loadlastproj
locklooptotime
loop
loopclickmode
loopgran
loopgranlen
loopnewitems
loopselpr
loopstopfx
manuallat
manuallatin
mastermutesolo
maxitemlanes
maxrecent
maxrecentfx
maxrecsize
maxrecsize_use
maxsnaptrack
maxspeakgain
metronome_defout
metronome_flags
midiccdensity
mididefcolormap
midieditor
midiins
midiins_cs
midioctoffs
midiouts
midiouts_clock
midiouts_clock_nospp
midiouts_llmode
midioutthread
midisendflags
miditicksperbeat
midivu
mixerflag
mixeruiflag
mixrowflags
mousemovemod
mousewheelmode
multiprojopt
multitouch
multitouch_ignore_ms
multitouch_ignorewheel_ms
multitouch_rotate_gear
multitouch_swipe_gear
multitouch_zoom_gear
mutefadems10
mvu_rmsgain
mvu_rmsmode
mvu_rmsoffs2
mvu_rmsred
mvu_rmssize
nativedrawtext
newfnopt
newprojdo
newtflag
nometers
norunmute
offlineinact
opencopyprompt
opennotes
optimizesilence
pandispmode
panlaw
panmode
peakcachegenmode
peakcachegenrs
peakrecbm
peaksedges
pitchenvrange
playcursormode
playrate
playresamplemode
pmfol
pooledenvattach
pooledenvs
prebufperb
preroll
prerollmeas
projalignbeatsrate
projbpm
projfrbase
projfrdrop
projgriddiv
projgriddivsnap
projgridframe
projgridmin
projgridsnapmin
projgridswing
projgroupover
projgroupsel
projintmix
projmasternch
projmastervuflags
projmaxlen
projmaxlenuse
projmeaslen
projmeasoffs
projmetrobeatlen
projmetrocountin
projmetroen
projmetrof1
projmetrof2
projmetrov1
projmetrov2
projmidieditor
projpeaksgain
projrecforopencopy
projrecmode
projrelpath
projrenderaddtoproj
projrenderdither
projrenderlimit
projrendernch
projrenderqdelay
projrenderrateinternal
projrenderresample
projrendersrate
projrenderstems
projripedit
projsellock
projshowgrid
projsmpteahead
projsmptefw_rec
projsmpteinput
projsmptemaxfree
projsmpteoffs
projsmpterate
projsmpterateuseproj
projsmpteresync
projsmpteresync_rec
projsmpteskip
projsmptesync
projsrate
projsrateuse
projtakelane
projtimemode
projtimemode2
projtimeoffs
projtrackgroupdisabled
projtsdenom
projvidflags
projvidh
projvidw
promptendrec
psmaxv
psminv
quantflag
quantolms
quantolms2
quantsize2
rbn
reamote_maxblock
reamote_maxlat_render
reamote_maxpkt
reamote_smplfmt
reascript
reascripttimeout
recaddatloop
recfile_wildcards
recopts
recupdatems
relativeedges
relsnap
renderaheadlen
renderaheadlen2
renderbsnew
rendercfg
renderclosewhendone
renderqdelay
rendertail
rendertaillen
rendertails
resetvuplay
restrictcpu
rewireslave
rewireslavedelay
reximport
rfprojfirst
rightclickemulate
ripplelockmode
rulerlayout
runafterstop
runallonstop
sampleedges
saveopts
saveundostatesproj
scnameedit
scnotes
scoreminnotelen
scorequant
screenset_as_views
screenset_as_win
screenset_autosave
scrubloopend
scrubloopstart
scrubmode
scrubrelgain
seekmodes
selitem_tintalpha
selitemtop
showctinmix
showlastundo
showmaintrack
showpeaks
showpeaksbuild
showrecitems
slidermaxv
sliderminv
slidershex
smoothseek
smoothseekmeas
snapextrad
snapextraden
solodimdb10
solodimen
soloip
specpeak_alpha
specpeak_bv
specpeak_ftp
specpeak_hueh
specpeak_huel
specpeak_lo
specpeak_na
splitautoxfade
stopendofloop
stopprojlen
syncsmpmax2
syncsmpuse
tabtotransflag
takelanes
tcpalign
templateditcursor
tempoenvmax
tempoenvmin
tempoenvtimelock
textflags
threadpr
timeseledge
tinttcp
titlebarreghide
tooltipdelay
tooltips
trackitemgap
trackselonmouse
transflags
transientsensitivity
transientthreshold
trimmidionsplit
tsmarker
undomask
undomaxmem
unselitem_tintalpha
use_reamote
usedxplugs
useinnc
userewire
verchk
vgrid
video_colorspace
video_decprio
video_delayms
viewadvance
volenvrange
vstbr64
vstfolder_settings
vstfullstate
vuclipstick
vudecay
vumaxvol
vuminvol
vuupdfreq
vzoom2
vzoommode
warnmaxram64
workbehvr
workbuffxuims
workbufmsex
workrender
workset_max
workset_min
workset_use
workthreads
zoom
zoommode
zoomshowarm
--]]

ultraschall={}
function ultraschall.GetStringFromClipboard_SWS()
-- gets a big string from clipboard, using the 
-- CF_GetClipboardBig-function from SWS
-- and deals with all aspects necessary, that
-- surround using it.
  local buf = reaper.CF_GetClipboard(buf)
  local WDL_FastString=reaper.SNM_CreateFastString("HudelDudel")
  local clipboardstring=reaper.CF_GetClipboardBig(WDL_FastString)
  reaper.SNM_DeleteFastString(WDL_FastString)
  return clipboardstring
end

L=reaper.MB("Read variable-names from clipboard?\n(Select No to use Reaper 5.80-variables.)","Query",3)
if L==6 then 
  A=ultraschall.GetStringFromClipboard_SWS()
elseif L==2 then return
else
  -- all valid variables
  A="__numcpu\nacidimport\nactionmenu\nadjreclat\nadjrecmanlat\nadjrecmanlatin\nallstereopairs\naltpeaks\naltpeaksopathlist\naltpeakspath\nalwaysallowkb\naot\napplyfxtail\nasio_bsize\naudioasync\naudiocloseinactive\naudioclosestop\naudioprshift\naudiothreadpr\nautoclosetrackwnds\nautomute\nautomuteflags\nautomuteval\nautonbworkerthreads\nautoreturntime\nautoreturntime_action\nautosaveint\nautosavemode\nautoxfade\ncopyimpmedia\ncpuallowed\ncsurfrate\nctrlcopyitem\ncueitems\ncustommenu\ndefautomode\ndefenvs\ndeffadelen\ndeffadeshape\ndefhwvol\ndefpitchcfg\ndefrenderpath\ndefsavepath\ndefsendflag\ndefsendvol\ndefsplitxfadelen\ndeftrackrecflags\ndeftrackrecinput\ndeftrackvol\ndefvzoom\ndefxfadeshape\ndisabledxscan\ndisk_peakmmap2\ndisk_rdmodeex\ndisk_rdsizeex\ndisk_wrblks"
  A=A.."\ndisk_wrblks2\ndisk_wrmode\ndisk_wrsize\ndiskcheck\ndiskcheckmb\nedit_fontsize\nenv_autoadd\nenv_deffoc\nenv_ol_minh\nenv_options\nenv_reduce\nenvattach\nenvclicksegmode\nenvlanes\nenvtranstime\nenvtrimadjmode\nenvwritepasschg\nerrnowarn\nfadeeditflags\nfadeeditlink\nfadeeditpostsel\nfadeeditpresel\nfeedbackmode\nfullscreenRectB\nfullscreenRectL\nfullscreenRectR\nfullscreenRectT\nfxdenorm\nfxfloat_focus\nfxresize\ng_config_project\ng_markerlist_updcnt\ngriddot\ngridinbg\ngridinbg2\ngroupdispmode\nguidelines2\nhandzoom\nhelp\nhwfadex\nhwoutfx_bypass\nide_colors\ninsertmtrack\nisFullscreen\nitemclickmovecurs\nitemdblclk\nitemeditpr\nitemfade_minheight\nitemfade_minwidth\nitemfadehandle_maxwidth\nitemfxtail\nitemicons\nitemicons_minheight\nitemlabel_minheight\nitemlowerhalf_minheight"
  A=A.."\nitemmixflag\nitemprops\nitemprops_timemode\nitemsnap\nitemtexthide\nitemtimelock\nitemvolmode\nkbd_usealt\nlabelitems2\nlastthemefn5\nloadlastproj\nlocklooptotime\nloop\nloopclickmode\nloopgran\nloopgranlen\nloopnewitems\nloopselpr\nloopstopfx\nmanuallat\nmanuallatin\nmastermutesolo\nmaxitemlanes\nmaxrecent\nmaxrecentfx\nmaxrecsize\nmaxrecsize_use\nmaxsnaptrack\nmaxspeakgain\nmetronome_defout\nmetronome_flags\nmidiccdensity\nmididefcolormap\nmidieditor\nmidiins\nmidiins_cs\nmidioctoffs\nmidiouts\nmidiouts_clock\nmidiouts_clock_nospp\nmidiouts_llmode\nmidioutthread\nmidisendflags\nmiditicksperbeat\nmidivu\nmixerflag\nmixeruiflag\nmixrowflags\nmousemovemod\nmousewheelmode\nmultiprojopt\nmultitouch\nmultitouch_ignore_ms\nmultitouch_ignorewheel_ms\nmultitouch_rotate_gear"
  A=A.."\nmultitouch_swipe_gear\nmultitouch_zoom_gear\nmutefadems10\nmvu_rmsgain\nmvu_rmsmode\nmvu_rmsoffs2\nmvu_rmsred\nmvu_rmssize\nnativedrawtext\nnewfnopt\nnewprojdo\nnewtflag\nnometers\nnorunmute\nofflineinact\nopencopyprompt\nopennotes\noptimizesilence\npandispmode\npanlaw\npanmode\npeakcachegenmode\npeakcachegenrs\npeakrecbm\npeaksedges\npitchenvrange\nplaycursormode\nplayrate\nplayresamplemode\npmfol\npooledenvattach\npooledenvs\nprebufperb\npreroll\nprerollmeas\nprojalignbeatsrate\nprojbpm\nprojfrbase\nprojfrdrop\nprojgriddiv\nprojgriddivsnap\nprojgridframe\nprojgridmin\nprojgridsnapmin\nprojgridswing\nprojgroupover\nprojgroupsel\nprojintmix\nprojmasternch\nprojmastervuflags\nprojmaxlen\nprojmaxlenuse\nprojmeaslen\nprojmeasoffs\nprojmetrobeatlen\nprojmetrocountin"
  A=A.."\nprojmetroen\nprojmetrof1\nprojmetrof2\nprojmetrov1\nprojmetrov2\nprojmidieditor\nprojpeaksgain\nprojrecforopencopy\nprojrecmode\nprojrelpath\nprojrenderaddtoproj\nprojrenderdither\nprojrenderlimit\nprojrendernch\nprojrenderqdelay\nprojrenderrateinternal\nprojrenderresample\nprojrendersrate\nprojrenderstems\nprojripedit\nprojsellock\nprojshowgrid\nprojsmpteahead\nprojsmptefw_rec\nprojsmpteinput\nprojsmptemaxfree\nprojsmpteoffs\nprojsmpterate\nprojsmpterateuseproj\nprojsmpteresync\nprojsmpteresync_rec\nprojsmpteskip\nprojsmptesync\nprojsrate\nprojsrateuse\nprojtakelane\nprojtimemode\nprojtimemode2\nprojtimeoffs\nprojtrackgroupdisabled\nprojtsdenom\nprojvidflags\nprojvidh\nprojvidw\npromptendrec\npsmaxv\npsminv\nquantflag\nquantolms\nquantolms2\nquantsize2\nrbn"
  A=A.."\nreamote_maxblock\nreamote_maxlat_render\nreamote_maxpkt\nreamote_smplfmt\nreascript\nreascripttimeout\nrecaddatloop\nrecfile_wildcards\nrecopts\nrecupdatems\nrelativeedges\nrelsnap\nrenderaheadlen\nrenderaheadlen2\nrenderbsnew\nrendercfg\nrenderclosewhendone\nrenderqdelay\nrendertail\nrendertaillen\nrendertails\nresetvuplay\nrestrictcpu\nrewireslave\nrewireslavedelay\nreximport\nrfprojfirst\nrightclickemulate\nripplelockmode\nrulerlayout\nrunafterstop\nrunallonstop\nsampleedges\nsaveopts\nsaveundostatesproj\nscnameedit\nscnotes\nscoreminnotelen\nscorequant\nscreenset_as_views\nscreenset_as_win\nscreenset_autosave\nscrubloopend\nscrubloopstart\nscrubmode\nscrubrelgain\nseekmodes\nselitem_tintalpha\nselitemtop\nshowctinmix\nshowlastundo\nshowmaintrack\nshowpeaks"
  A=A.."\nshowpeaksbuild\nshowrecitems\nslidermaxv\nsliderminv\nslidershex\nsmoothseek\nsmoothseekmeas\nsnapextrad\nsnapextraden\nsolodimdb10\nsolodimen\nsoloip\nspecpeak_alpha\nspecpeak_bv\nspecpeak_ftp\nspecpeak_hueh\nspecpeak_huel\nspecpeak_lo\nspecpeak_na\nsplitautoxfade\nstopendofloop\nstopprojlen\nsyncsmpmax2\nsyncsmpuse\ntabtotransflag\ntakelanes\ntcpalign\ntemplateditcursor\ntempoenvmax\ntempoenvmin\ntempoenvtimelock\ntextflags\nthreadpr\ntimeseledge\ntinttcp\ntitlebarreghide\ntooltipdelay\ntooltips\ntrackitemgap\ntrackselonmouse\ntransflags\ntransientsensitivity\ntransientthreshold\ntrimmidionsplit\ntsmarker\nundomask\nundomaxmem\nunselitem_tintalpha\nuse_reamote\nusedxplugs\nuseinnc\nuserewire\nverchk\nvgrid\nvideo_colorspace\nvideo_decprio\nvideo_delayms\nviewadvance"
  A=A.."\nvolenvrange\nvstbr64\nvstfolder_settings\nvstfullstate\nvuclipstick\nvudecay\nvumaxvol\nvuminvol\nvuupdfreq\nvzoom2\nvzoommode\nwarnmaxram64\nworkbehvr\nworkbuffxuims\nworkbufmsex\nworkrender\nworkset_max\nworkset_min\nworkset_use\nworkthreads\nzoom\nzoommode\nzoomshowarm"
  
  -- these are rumored to work, but I couldn't verify them. I include them anyway, just in case
  A=A.."\nafxcfg\nbigwndframes\nccresettab\ndefrecpath\nlazyupds\nmidiedit\nmidilatmask\nprojmetrofn1\nprojmetrofn2\nprojmetropattern\nprojrelsnap\nreccfg\nreuseeditor\nrulerlabelmargin\nvstbr32"
  A=A.."\nhidpi_win32"
  
  -- possible other variables
  --[[
  A=A.."uef\nrjt\nsdy\nlmz\nmqw\nefw\nktz\nasz\nzfz\ndjz\nafz\ngfff\navy\nbzy\niry\nmuy\nety\nrky\nmjy\nagy\niby\nhby\njbx\nlxx\nylx\nhlx\nckt\nhzo\nnso\nsno\nygo\nzbo\ncpw\nvnv\nhjv\nxfv\nabv\nzav\nsav\nquu\nutzr\nsxv\nxpv\nqnr\nyxt\navt\nnee\nrto\nkro\ncpo\nylo\njko\nlko\ncgo\nefo\nkdo\nudo\nrco\nrvk\ndsk\nlxk\npsca\nrtnm\nrtrp\nrncs\ncaps\ntsba\nlcmnu\nowm\nzmm\njia\nioi\nuni\nbwi\nvvi\nloi\nrni\ngri\nsgi\nimi\ntji\natf\npyf\noai\npdi\nztf\nmrf\nmof\nrmf\nalf\nnjf\nhef\nudf\njps\nclj\nmjj\nooo\nixh\nssh\nqzh\nzqh"
  A=A.."\nwgh\npgh\nwdh\nsfh\ndah\nate\nele\none\ntrf\nkei\nhai\nmeg\ngeg\njtd\nnld\nqkg\nahq\nyeg\ngje\nkab\ndwf\ngxf\neaf\niza\nrdf\nwia\nmya\nmmd\nsre\ntbf\ncsc\najc\nolb\njcb\newa\nbva\nfsa\ncra\nsia\nevaw\nwyb\nxzb\nlia\nscb\nupf\nyma\nmma\nlma\nbla\nmha\nrhi\ntjf\ncuv\nvaf\nfnu\ndnu\neeu\nkqw\nmgz\nndz\nuty\nksy\nyny\nily\nugy\nead\nmtx\njnx\nkmx\nyuw\nziw\nsws\nhws\naiv\nqzv\nqsv\njuv\nhav\nmda\nruu\ncqu\nekq\nhst\nbnm\nfrb\ncus\nsns\nics\nsbs\nwiz\nrur\nbrr\npmr\nemr\nzlr\nglr\npbr\nfar\nsgf\ntdf\ntaf"
  A=A.."\nbqt\nyss\nyzy\nwyy\nscl\niny\nbny\nozr\npae\npcp\nicp\nxkc\ntqm\neqm\namm\nmmm\nplm\nsel\nouk\nvuk\nonk\nvfk\nwjq\npjq\nggq\nwnd\nmid\ncop\nlnp\nxgd\ncgd\nzgp\njyj\npxj\nvuj\nvfp\nhfj\nucj\nduw\njtu\nxyo\nyyo\nkdi\nfai\nmtn\nlhn\nmhn\nkwi\nmsi\nrfi\nxci\nqci\ndeb\noqm\nmch\nwxf\nrwf\nzrg\nprg\ndrg\nkqg\nrlg\nwtf\nwlf\nsaf\nwvf\nsjf\nwtq\npte\nite\npce\nxvj\nqvj\nxtj\nwej\nkxe\ndte\nthf\nffffff\nrrc\npqc\nwnc\nrzc\ncyc\nhyc\nuqc\ndsc\nmsc\ndnc\ncmc\nkkc\nyec\nrac\nsuc\nudc\nadc\nfzb\nqyb\nzeb\njeb\nheb"
  A=A.."\nqfb\nrnb\nbbb\ndjf\nzjl\ntwa\nsua\nfua\nuta\nxta\ngra\npna\nkna\nyca\nsqa\nffia\nffiau\nevawu\nrdd\nykd\nevawt\nffiat\nvqf\nled\nsni\ndne\nktp\nltk\ntpf\nref\nusf\numzk\nrpf\nfff\ncsm\ntjfff\nclsid\ndescription\nrender\ncapture\nsendlevel\nsendcount\npan\nvolume\nsolo\nmute\nfocused\nselected\nvisibility\ncolor\nindex\nmain\ntype\nname\nmultiselect\neditor\nreaexpr\nreakysw\nvstcache\ncount\ndeveloper\ninst\ncategory\nvstaliasinfo\nmono\nvst\nout\nfxmenu\nundo\nrewire_common\nmethod\n__name\nexit\nopen"
  A=A.."\nreopen\nread\ntrue\nfalse\n__tostring\nassert\ncollectgarbage\ndofile\nerror\ngetmetatable\nipairs\nloadfile\nload\nnext\npairs\npcall\nprint\nrawequal\nrawlen\nrawget\nrawset\nselect\nsetmetatable\ntonumber\ntostring\nxpcall\n__metatable\nstop\nrestart\ncollect\nstep\nsetpause\nsetstepmul\nisrunning\n__pairs\nopcodes\nconstants\ncreate\nresume\nrunning\nstatus\nwrap\nyield\nisyieldable\nsuspended\nnormal\ndead\ndebug\ngetuservalue\ngethook\ngetinfo\ngetlocal\ngetregistry\ngetupvalue\nupvaluejoin"
  A=A.."\nupvalueid\nsetuservalue\nsethook\nsetlocal\nsetupvalue\ntraceback\nsource\nshort_src\nlinedefined\nlastlinedefined\nwhat\ncurrentline\nnups\nnparams\nisvararg\nnamewhat\nistailcall\nactivelines\nfunc\ncall\nreturn\nline\n__mode\ncont\nlocal\nglobal\nfield\nupvalue\nconstant\nhook\nmetamethod\nconcatenate\nbinary\ntext\npackage\ncoroutine\ntable\nstring\nmath\nclose\nflush\nlines\nseek\nsetvbuf\nwrite\ninput\noutput\npopen\ntmpfile\nfile\nrwa\nset\ncur\nend\nfull\n__index\nstdin\nstdout\nstderr\nand"
  A=A.."\nbreak\nelse\nelseif\nfor\nfunction\ngoto\nnot\nrepeat\nthen\nuntil\nwhile\ncomment\nabs\nacos\nasin\natan\nceil\ncos\ndeg\nexp\ntointeger\nfloor\nfmod\nult\nlog\nmax\nmin\nmodf\nrad\nrandom\nrandomseed\nsin\nsqrt\ntan\nhuge\nmaxinteger\nmininteger\nzero\ninteger\nfloat\nrequire\nloadlib\nsearchpath\npreload\ncpath\npath\nsearchers\nloaded\ninit\nconfig\nclock\ndate\ndifftime\nexecute\ngetenv\nremove\nrename\nsetlocale\ntime\ntmpname\nsec\nhour\nday\nmonth\nyear\nwday\nyday\nisdst\nall\ncollate\nctype"
  A=A.."\nmonetary\nnumeric\nupvalues\nfunctions\nself\nbyte\nchar\ndump\nfind\nformat\ngmatch\ngsub\nlen\nlower\nmatch\nrep\nreverse\nsub\nupper\npack\npacksize\nunpack\nconcat\ninsert\nmove\nsort\n__len\n__newindex\nuserdata\nboolean\nnumber\nthread\nproto\n__add\n__sub\n__mul\n__mod\n__pow\n__div\n__idiv\n__band\n__bor\n__bxor\n__shl\n__shr\n__unm\n__bnot\n__concat\n__call\ntruncated\ncorrupted\nint\nsize_t\noffset\ncodepoint\ncodes\ncharpattern\nreamote\nmbox\nscrollbar\nsqr\nsign\nrand\ninvsqrt\n__dbg_getstackptr"
  A=A.."\nfreembuf\nmemcpy\nmemset\n__memtop\nmem_set_values\nmem_get_values\nstack_push\nstack_pop\nstack_peek\nstack_exch\nreg\nthis\nloop\n__denormal_likely\n__denormal_unlikely\npow\nparms\ngmem\nglobals\ninstance\nstatic\nstrcpy\nstrcat\nsbh\noverlay\nmultiply\nmul\ndodge\nadd\ncopy\npop\npush\nalpha\nblend\nyes\noff\nfill\ncmask\nkmask\ndcdx\ndcdy\ndcdxscale\ndcdyscale\nusestate\nparent\nfilter\nsrcalpha\nscale\nsrcx\nsrcy\nsrcw\nsrch\nblit\nrerender\nrect\narc\ncircle\nduplicate\ninvalid\nvwnd_listbox\nvwnd_combobox"
  A=A.."\nvwnd_statictext\nvwnd_iconbutton\nvwnd_slider\nvwnd_tabctrl_child\nvwnd_tabctrl_proxy\nvwnd_unknown\nkdz\nrqg\nknv\nkoi\nhwe\nmcf\nlab\njpf\niak\nljw\nabout\ntitlebarreghide\nnibbles_hs\nblocks_hs\nnag\nuss\npoo\ndague\nrdmid\nactions\nactiondialog\ncommand_id\ncustomaction\nactionlist\nautoclosekeymap\nmidilearn\ndeflearnselonly\ndeflearnccmode\nactionflag\nlastactionfilt\naccel_sec\nlastscript\nextedit\nreascript\ncustomactionwnd_x\ncustomactionwnd_w\ncustomactionwnd_y\ncustomactionwnd_h\nactions_insert\nactions_dd"
  A=A.."\nstopendofloop\nreacontrolmidi\nreaeq\nwav\nreversed\nitemfn\nitem\nrpp\nsubproject\npooledenv\nwarn\nfaultyproject\ninsmultrkwnd_x\ninsmultrkwnd_y\nitemimport\nglued\nglue\nlastproject\nprojecttabs\nopendlgnewtab\nlastprojuiref\nzip\ndstpin\nsrcpin\nlastscript_safe\nmenu\nimportpath\n_more\nsave\ntrack\nreasurround\naot\ntooltips\ntransport_vis\ntitle\ntransport\nhelp\nmixwnd_dock\nitemtexthide\ncueitems\nmixerflag\nshowctinmix\nactionmenu\ncustommenu\ntransflags\ntransport_dock_pos\nrbn\nrunallonstop\nenv_reduce\nenvattach"
  A=A.."\npooledenvattach\nenvclicksegmode\nnometers\nviewadvance\ncopyimpmedia\nitemclickmovecurs\nsolodimen\nlocklooptotime\ntemplateditcursor\ntakelanes\nsmoothseek\nsplitautoxfade\nrelativeedges\ntrimmidionsplit\npooledenvs\nrulerlayout\npreroll\nhwoutfx_bypass\nhwfxnch\nhwfx\nmidi\ndiskcheck\nkbd_usealt\nmultiprojopt\nfxfloat_focus\nvgrid\nshowpeaks\nchooseproj_pos\nreaper\n_freeze\n_stems\nfreeze\ntransientsensitivity\ntransientthreshold\ntransient\nasio_driver_name\nwaveout_driver_in\nwaveout_driver_out\nwasapi_driver_in"
  A=A.."\nwasapi_driver_out\nks_driver_in\nks_driver_out\naudioconfig\nmode\nallow_sr_override\nks_srate\nks_bps\nks_devin\nks_devout\nks_bs\nks_numblocks\nks_nch_in\nks_nch_out\nwaveout_srate\nwaveout_bps\nwaveout_devicein\nwaveout_deviceout\nwaveout_bs\nwaveout_numblocks\nwaveout_nch_in\nwaveout_nch_out\ndsound_srate\ndsound_bps\ndsound_bs\ndsound_numblocks\ndsound_nch_in\ndsound_nch_out\nasio_driver\nasio_srate\nasio_srate_use\nasio_zeromode\nasio_resetignore\nasio_bsize\nasio_bsize_use\nwasapi_mode\nwasapi_srate\nwasapi_bps"
  A=A.."\nwasapi_devin\nwasapi_devout\nwasapi_bs\nwasapi_nch_in\nwasapi_nch_out\ndummy_srate\ndummy_blocksize\nprefs_audiodev\nprefs_audiodev_help\nprefs_audiodev_asio_help\naudiothreadpr\naudiodev\naccess\nsendwnd\nbigclock\nfgcolor\nbgcolor\ntime_mode\nbeatbg_fn\nbeatbg_flags\nliveoutmode\nliveoutgate\nliveoutgatelen\nuntitled\nbounce\nster\nbouncecfg\ncsurf_cnt\nrendertails\nrendertaillen\npsminv\npsmaxv\nprojmastervuflags\nprojmasternch\nprojrenderresample\nplayresamplemode\nprojmetroen\nprojmetrocountin\nprojmetrobeatlen"
  A=A.."\nprojmetropattern\nprojtakelane\nprojsellock\nmastermutesolo\nprojtimeoffs\nprojmeasoffs\npanlaw\npanmode\nopennotes\nfeedbackmode\nmixrowflags\nmixeruiflag\nautoxfade\nprojgroupover\nprojgroupsel\nprojtrackgroupdisabled\nprojripedit\nprojrecmode\nprojmaxlen\nprojmaxlenuse\nprojrecforopencopy\nprojrenderaddtoproj\nprojrenderqdelay\nprojrenderstems\nprojrenderdither\nprojrendersrate\nprojrendernch\nprojrenderlimit\nprojrenderrateinternal\nprojgridmin\nprojshowgrid\nrelsnap\nprojgriddiv\nprojgridsnapmin\nprojgriddivsnap"
  A=A.."\nprojgridswing\nprojgridframe\nprojtimemode\nprojvidflags\nprojvidw\nprojvidh\nprojfrbase\nprojfrdrop\nprojbpm\nprojmeaslen\nprojtsdenom\nshowmaintrack\nitemtimelock\ntempoenvtimelock\nitemmixflag\ndefpitchcfg\nloopgran\naudioprshift\nloopgranlen\nplayrate\nzoom\nprojsrate\nprojsrateuse\nprojintmix\nprojalignbeatsrate\nprojpeaksgain\nreccfg\nafxcfg\nrendercfg\nprojsmptesync\nprojsmpterateuseproj\nprojsmpterate\nprojsmpteoffs\nprojsmpteresync\nprojsmpteresync_rec\nprojsmptefw_rec\nprojsmpteskip\nprojsmpteahead\nprojsmptemaxfree"
  A=A.."\nprojsmpteinput\nprojmidieditor\nscorequant\nscoreminnotelen\nrewireslave\nrewireslavedelay\nprojdefrecpath\ng_config_project\nuiscale\nbigwndframes\nide_colors\ng_markerlist_updcnt\nmvu_rmsmode\nmvu_rmssize\nmvu_rmsred\nmvu_rmsgain\nitemicons\nitemicons_minheight\nitemlabel_minheight\nitemlowerhalf_minheight\nitemfade_minwidth\nitemfade_minheight\nitemfadehandle_maxwidth\nvstfolder_settings\nsyncsmpuse\nsmoothseekmeas\nadjreclat\nrecopts\nmanuallat\nmanuallatin\nadjrecmanlat\nadjrecmanlatin\nmultitouch\nmultitouch_swipe_gear"
  A=A.."\nmultitouch_zoom_gear\nmultitouch_rotate_gear\nmultitouch_ignorewheel_ms\nmultitouch_ignore_ms\nprerollmeas\nmidilatmask\nstopprojlen\ninsertmtrack\nitemsnap\nloadlastproj\npromptendrec\npeakcachegenmode\npeakcachegenrs\npeakrecbm\naudioclosestop\naudiocloseinactive\nrfprojfirst\nuseinnc\npmfol\nmaxrecsize\nmaxrecsize_use\nprojrelpath\nhandzoom\nmidioutthread\nmidisendflags\nmidiins\nmidiins_cs\nmidiouts\nmidiouts_clock\nmidiouts_clock_nospp\nmidiouts_llmode\nworkthreads\nautonbworkerthreads\nworkbufmsex\nworkbuffxuims"
  A=A.."\nprebufperb\nmidioctoffs\nplaycursormode\ngroupdispmode\ntooltipdelay\nshowlastundo\ntcpalign\ntimeseledge\nnativedrawtext\nmidivu\nmidieditor\nmidiedit\nreuseeditor\nmidiccdensity\nscnotes\nzoomshowarm\nofflineinact\nundomaxmem\nmaxsnaptrack\nzoommode\ndefvzoom\nvzoommode\nseekmodes\ndeffadeshape\ndefxfadeshape\nmousemovemod\ndefautomode\ndeffadelen\ndefsplitxfadelen\ndefenvs\nsaveopts\nautosaveint\nautosavemode\nfxresize\nvstfullstate\nenvtrimadjmode\nenvwritepasschg\nenv_options\nusedxplugs\ndisabledxscan"
  A=A.."\nvuupdfreq\nvudecay\naltpeaks\nsnapextrad\nsnapextraden\nshowrecitems\nrecaddatloop\nrecupdatems\nnorunmute\noptimizesilence\nenv_autoadd\nrenderaheadlen\nloopclickmode\nloopstopfx\nundomask\nctrlcopyitem\nworkrender\naudioasync\nworkbehvr\nthreadpr\nmousewheelmode\nautoclosetrackwnds\nalwaysallowkb\ntextflags\nrestrictcpu\nworkset_use\nworkset_min\nworkset_max\ncpuallowed\nverchk\nrenderbsnew\nscrubmode\nscrubloopstart\nscrubloopend\nscrubrelgain\nitemvolmode\nvolenvrange\npitchenvrange\ntempoenvmin"
  A=A.."\ntempoenvmax\npeaksedges\nsampleedges\nsliderminv\nslidermaxv\nvuminvol\nvumaxvol\nvuclipstick\ntrackitemgap\nmaxitemlanes\nitemfxtail\nripplelockmode\nrendertail\nslidershex\nnewtflag\nitemdblclk\ndiskcheckmb\nopencopyprompt\nselitemtop\nrenderclosewhendone\nrenderqdelay\nrunafterstop\naltpeakspath\naltpeaksopathlist\ndefrenderpath\ndefsavepath\nnewprojdo\npandispmode\nmididefcolormap\nvideo_colorspace\nvideo_delayms\nvideo_decprio\ntabtotransflag\nreximport\nacidimport\ndefsendflag\ndeftrackrecflags"
  A=A.."\ndeftrackrecinput\ndefsendvol\ndefhwvol\ndeftrackvol\ncsurfrate\nenv_ol_minh\nenvlanes\nenv_deffoc\nresetvuplay\nquantflag\nquantolms\napplyfxtail\nuserewire\nitemeditpr\nloopselpr\ndisk_rdmodeex\ndisk_rdblksex\ndisk_rdsizeex\ndisk_wrmode\ndisk_wrblks\ndisk_wrsize\nuse_reamote\nreamote_smplfmt\nreamote_maxblock\nreamote_maxlat_render\nreamote_maxpkt\nscreenset_autosave\nscreenset_as_views\nscreenset_as_win\ntinttcp\nsoloip\ngridinbg\ngriddot\ntsmarker\nshowpeaksbuild\nnewfnopt\nrecfile_wildcards\nsaveundostatesproj"
  A=A.."\nallstereopairs\ntrackselonmouse\nselitem_tintalpha\nunselitem_tintalpha\nhwfadex\nfxdenorm\nmiditicksperbeat\nerrnowarn\nmaxrecent\nloopnewitems\nscnameedit\nmaxrecentfx\nautoreturntime\nautoreturntime_action\nenvtranstime\nautomuteflags\nautomute\nautomuteval\nrightclickemulate\nitemprops\nreascripttimeout\nedit_fontsize\nfadeeditpresel\nfadeeditpostsel\nfadeeditflags\nfadeeditlink\nmetronome_defout\nmetronome_flags\nitemprops_timemode\nspecpeak_alpha\nspecpeak_bv\nspecpeak_ftp\nspecpeak_huel\nspecpeak_hueh"
  A=A.."\nspecpeak_lo\nspecpeak_na\nmaxspeakgain\nccresettab\nuiflags\nautosavedir\nnewprojtmpl\ndefrecpath\nprojrelsnap\nconfigex\nctheme\npreset\nfxchain\njseffect\ntemplatemisc\ncursorkeymap\nmenus\nactionsreal\nmenusets\nchanmaps\nlangpacks\nmediadb\nwwwroot\nautoitems\nmidinotenames\nconfigexport\nreaper_www_root\nconfigexport_lastflag\nconfigimport_rem\nconswavefmt\ncons_entproj\ncons_maxsil\ncons_maxsil_en\ncons_tracks\ncons_rsplmode\ncons_saveflags\nlastconspath\nmidiexportpath\nmidi_export\nmidiexport\nconverter"
  A=A.."\nconvert\nconvertaddpath\nconvertusefolder\nconvertcfg\nconvertfolder\nconvertdither\nconvertusefxchain\nconvertnch\nconvertsr\nconvertrs\nconvetnch\ncpumeter\nperf\ndisplay\narrow\nfree\nuse\ncustomizemenu\ntoolbar\niconpicker_x\niconpicker_y\niconpicker_w\niconpicker_h\ntoolbar_icons\npng\nlastmenusetdir\ncustommenuwnd_x\ncustommenuwnd_w\ncustommenuwnd_y\ncustommenuwnd_h\nmenus_dd\ntext_wide_tt\ntext_tt\ntext_wide\nclosing\narrange_dd_tonew\ndircleanrecycle\nreapeaks\ndirclean\ndockheight\ndockheight_l\ndockheight_t"
  A=A.."\ndockheight_r\ndocker_transparency\ndocker_autoopaque\ndocker\ndockcompactsingle\n_left\n_right\n_top\n_bottom\ndockposflags\ndock_resize_ew\ndock_resize\nwnd_vis\nscreensets\nwnd_left\nwnd_top\nwnd_width\nwnd_height\ndock\ndst\nsrc\nmhs\nminslice\nminsilence\nsplitflag\npostfx\ngatethresh\ngatehyst\nremovesilence\nbeatbase\nsnapoffs\nsplitgroups\ndostretchmarkers\nchrommidi\npadfade\nsnapoffstime\nleadpad\ntrailpad\nlastsplitslider\nsplitcnten\ndsplit\ndynsplit_x\ndynsplit_y\nradar\nepin\nroutehelp\nmidi_et\nparmmod"
  A=A.."\nenvdlg\nenvdlg_heading\nvwnd_envpanel_container\nbpm\nenv\nsemitones\ntooltip\nenvcp_resize\ndel\nautoitemprops_x\nautoitemprops_y\nlfo\nfilecopy\nchan\nrea\ndefaultpresets\nfxadd\ncategories\ndevelopers\ndefault\nfxadd_divx\nfxadd_divy\nfxadd_x\nfxadd_y\nfxadd_w\nfxadd_h\nfxadd_vertdiv\nfxadd_autoclear\nfxadd_dock\nfxadd_vis\nfxbrowser\nallp_root\nuserf_root\ncat_root\ndev_root\nvstpath_root\nlastview\nnotepad\nfx_dd\nfx_dd_no\n__builtin_video_processor\nvideoprocessor\nbypassed\noffline\npresets\nunknown\nrewire"
  A=A.."\nbuiltin_video_processor\njsfx\nnumparm\nerr\nsafemode\nshortcut\nrecin\nprout\nfx_resize\nfxchainw\nfx_dd_move\nnone\nevent\naxis\npov\njoystick\neel\nbuttons\nnumbuttons\nsystime\nnumaxis\nnumpov\nsubmode\nreaper_joysticks\nnumdev\npinmgr\nactions_sub\nactions_fmt\nwet\nknob\nfolderstate\nfolderdepth\nmaxfolderdepth\nrecarm\nmcp_panflip\nmcp_docked\nmcp_wantextmix\nmcp_iconsize\ntcp_iconsize\ntrans_flags\ntrans_docked\ntrans_center\nenvcp_type\ntracknch\ntrackpanmode\ntrackcolor_valid\ntrackcolor_r\ntrackcolor_g"
  A=A.."\ntrackcolor_b\ntcp_fxparms\nmcp_maxfolderdepth\nreaper_version\ngloballayout\nlayout\nendlayout\nfront\nreset\nclear\nglob\nmcp\nmaster_mcp\ntcp\nmaster_tcp\nenvcp\ntrans\nsquare\ntriangle\nwnd_state\nmultinst\nlangpack\npcmsrc\nrearoute_loopback\nlastcwd\nvstpath\ncaption\nnul\nleftpanewid\nleftpanewid_alt\ntoppane_alt\ntoppane\ntcppane_resize\ntoolbar_resize\nmixwnd_vis\nwnd_x\nwnd_y\nwnd_w\nwnd_h\nundownd_vis\nroutingwnd_vis\npeakscfg_vis\nmixer\nrouting\nnudge\nnudge_vis\nhwfx_failed\nlua\nnosave\n_user\ntrackmgr"
  A=A.."\nflags\ntrackmgr_insert\nsweep\ntrackmgr_help\ntracks\nregmgr\nmarkerexportpath\nregions\nmarkers\ntxt\ncsv\nnse\nregmgr_help\nbyp\nregion\nmeter\nitemprop\nitemchan\nfadeedit\ncomp\ntheme\nmididevcache\ndebug_midiout\ninant\nmented\ninished\nchord\nseconds\nbeats\ncenter\nstart\nmetronome\nmetronomechars\nrecentmetropat\ncnt\nsavetrimtail\nsaveas\nccolor_x\nccolor_y\ncustcolors\nmarker\ngridsnap\ngangmode\nimport\nmidiimport\nexttc\ngroup\ntgrp_x\ntgrp_y\ntgrpdef\nmisc\nnoteswnd_x\nnoteswnd_y\nnotes\nmemfree\neatmem"
  A=A.."\nsleep\nkbd\nloops\nshow\ncrash\ntls_avail\nprefprompt_x\nprefprompt_y\nlastt\ntabtotrans_x\ntabtotrans_y\npeakscfg_x\npeakscfg_y\nspeak_resize_ew\nspeak_resize_ns\nmidi_keys\nscalefinder_x\nscalefinder_y\nreascale_fn\nsnapflags\npitchenvcfg\nfreezewnd_x\nfreezewnd_y\nfreezewnd_w\nfreezewnd_h\ntempoadj_x\ntempoadj_y\ntempoadj_flag\nprojsettings\nreplaceitem\ntabs\nlyrics\nmastermixer\nmixwnd_x\nmixwnd_y\nmixwnd_w\nmixwnd_h\nmixwnd_max\ncity\nccedit\nmovecur\nhasimported\nmousemaps\nnavigator\ninterval\nuser\nsessionlog"
  A=A.."\nlocalsessionlog\nnudgeamt\nnudgecopies\nnudge_x\nnudge_y\nposition\ncontents\nwhole\nmilliseconds\nsamples\nframes\npixels\npandlg\nautosaveonrender\nfact\nbext\nacid\njunk\ndata\ndefault_size\nwavcfg\nclickdefauto\nclickdefbl\nclickpattern\nclickpattern_msb\nrppsrc\npcmsrc_section\npeaksbuild\nps_e\nsoundtouch\nextrashifter\nrubberband\npitchshift\nps_rbl\nps_st\nps_dle\nparse_timestr_misc\ninflate\ndeflate\nnseel_stringsegments_tobuf\nnseel_int_register_var\neel_setfp_round\neel_setfp_trunc\nget_eel_funcdesc\nvoid"
  A=A.."\ndouble\nbool\ntime_precise\nproj\nfunction_name\ndeprecated\nfont\nfilename\nsourcetype\namt\nversion\nformat_timestr\nget_config_var\nget_midi_config_var\nget_ini_file\nmkpanstr\nmkvolpanstr\nmkvolstr\nparse_timestr\nbuf\nparsepanstr\nstr\nplugin_getapi\nplugin_register\nprojectconfig_var_addr\nprojectconfig_var_getoffs\nrelative_fn\nresolve_fn\nupdate_disk_counters\ncommand_name\nprevent_count\ntake\nwant_last_valid\nevtlist\nbypass\nforce\nseekplay\ntrackid\nlocal_osc_handler\ndev\nhwnd\nident_str\nptr\nidx\nenvelope"
  A=A.."\nval\nignoremask\nproject\npreview\nerrorstr\nmsg\ntpos\ndescchange\n__mergesort\nformat_timestr_len\nformat_timestr_pos\nparse_timestr_len\nparse_timestr_pos\nscreenset_register\nscreenset_unregister\nparam\nmidi_reinit\nfile_exists\nimage_resolve_fn\nerrmsg\naccessor\nflag\nleftmosttrack\njoystick_create\nguid\njoystick_destroy\ndevice\njoystick_enum\njoystick_update\njoystick_getinfo\njoystick_getbuttonmask\njoystick_getaxis\njoystick_getpov\nextstate\nmousemap\ncommand_id_lookup\npcmsink_ext\nhookcustommenu\nprefpage"
  A=A.."\nmasterchannelhook\ntoggleaction\ndestroylocaloschandler\nsendlocaloscmessage\ncreatelocaloschandler\nosclocalmsgfunc\ncsurf\ncsurf_inst\naccelerator\ngaccel\ncustom_action\naction_help\naccel_section\nprojectconfig\nprojectimport\npcmsink\ntimer\nhookpostcommand\nhookcommand\nfile_in_project_ex\ncsurf_type\nmf_sopts\nmissfile\nmf_sdir\nin_pin_\nout_pin_\npdc\nsnap_enabled\nscale_root\nscale_enabled\ndefault_note_len\ndefault_note_chan\ndefault_note_vel\nlast_clicked_cc_lane\nactive_note_row\n__numcpu\nmididefbankprog"
  A=A.."\nmidideftextstr\nreaper_\nreaper_php\nreaper_perl\n_reaper_python\naif\napiconsole_x\napiconsole_y\napiconsole_w\napiconsole_h\nqyy\nthemeblend\nsplashimage\nprefs\nprefs_x\nprefs_y\nprefspage\nprefs_list\n__default__\nprefs_extedit\nexe\nprefs_reamote\nprefs_kbd_help\nprefs_trackdefs_help\nprefs_env\nprefs_track\nrecordmode\ntrackrecstatus\nprefs_itemdefs_help\naliasdlg\noutnamecache\nnamecache\nreaper_chanmap\nmap_hwnch\nmap_size\nnumrecent\nprefs_gen_help\nprefs_path_help\nprefs_project_help\nprefs_audio_help"
  A=A.."\nprefs_audio\nprefs_audio_mutesolo_help\nprefs_render_help\napeaks_help\nprefs_media\nprefs_mediavu_help\nprefs_mediafades_help\nprefs_seek_help\nprefs_playback_help\nprefs_record_loop_help\nprefs_record_help\nprefs_buf_help\nprefs_buf\nprefs_video\nprefs_appear_help\nprefs_fader\nprefs_meter_help\nprefs_env_pitch\nprefs_env_help\nprefs_auto_help\nprefs_edit\nprefs_edit_help\nprefs_mouse\nprefs_mouse_help\nprefs_media_help\nprefs_midi_help\nprefs_midiedit_help\nvideo_plugin_get_decoder_info\nreaper_rex\nprefs_video_help"
  A=A.."\ndll\nprefs_reascript\nprefs_reascript_help\nprefs_plugin_help\nprefs_plugin\nprefs_plugincompat_help\nprefs_plugin_knob\nprefs_plugin_vst\nprefs_vst_help\nprefs_dx_help\nprefs_mididev\nprefs_mididev_help\nbackground\nforeground\nlowest\nlow\nthemelblend\nhigh\nmoderate\nhighest\npspage_last\nprojsave\nprojload\nprojbay\nlength\nunavailable\nactive\ninactive\navailable\nmuted\nmaster\ninstances\nhidden\narmed\nmedia_dd\nmedia_dd_no\nprojbay_tgtdir\nfilterflag\npreviewvol\nextension_api\next_retina\ndest\ntexth\nmouse_hwheel"
  A=A.."\nmouse_wheel\nmouse_cap\nmouse_y\nmouse_x\nmouse_\ngfx_\nget_action_context\nfrom\nelif\nwith\npass\nexcept\nclass\nexec\nraise\ncontinue\nfinally\ndef\nlambda\ntry\nnew_array\nrunloop\ndefer\natexit\nreascriptout_x\nreascriptout_y\nreascriptout_w\nreascriptout_h\nconst\n_eel_unsup\ngfx_setcursor\ngfx_aaaaa\ngfx_measurestr\ngfx_measurechar\ngfx_getfont\ngfx_getimgdim\nhandle\ngfx_getpixel\ngfx_clienttoscreen\ngfx_screentoclient\ngfx_dock\nreascriptedit\nwatch_docked\nwatch_lx\nwatch_ly\nwatch_lw\nwatch_lh\nwatch_lmax\nwatch_divpos"
  A=A.."\n_global\n__debug_watch_value\nave\npee\nprintf\nsprintf\ndejq\nmatchi\nstrlen\nstrcmp\nstricmp\nstrncmp\nstrnicmp\nstrncpy\nstrncat\nstrcpy_from\nstrcpy_substr\nstr_getchar\nstr_setchar\nstr_setlen\nstr_delsub\nstr_insert\nconvolve_c\nfft\nifft\nfft_real\nifft_real\nfft_permute\nfft_ipermute\nfopen\nfclose\nfread\nfgets\nfgetc\nfwrite\nfprintf\nfseek\nftell\nfeof\nfflush\ngfx_init\ngfx_quit\ngfx_update\ngfx_getchar\ngfx_showmenu\ngfx_lineto\ngfx_line\ngfx_rectto\ngfx_rect\ngfx_setpixel\ngfx_drawnumber\ngfx_drawchar\ngfx_drawstr"
  A=A.."\ngfx_setfont\ngfx_printf\ngfx_blurto\ngfx_blit\ngfx_blitext\ngfx_setimgdim\ngfx_loadimg\ngfx_gradrect\ngfx_muladdrect\ngfx_deltablit\ngfx_transformblit\ngfx_circle\ngfx_triangle\ngfx_roundrect\ngfx_arc\ngfx_set\nexpression\nangle\nvalue\nexponent\naddress\ntcp_listen\ntcp_listen_end\nport\ntcp_connect\ntcp_send\ntcp_recv\ntcp_set_block\ntcp_close\nconnection\neval\ngfx_r\ngfx_g\ngfx_b\ngfx_a\ngfx_w\ngfx_h\ngfx_x\ngfx_y\ngfx_mode\ngfx_clear\ngfx_texth\ngfx_dest\ngfx_ext_retina\neelscript_gfx\nretval\ngfxmt\ngfx\nsize\nget_alloc"
  A=A.."\nresize\nconvolve\n__name__\nlibs\nlib\npython\nlibpython\nrescript\nhasrecentsec\nvav\nnxq\nomz\njan\nfeb\nmar\napr\nmay\njun\njul\naug\nsep\noct\nnov\ndec\nqrender_\nrender_month\nrender_wildcard\nfiles\nrenderqwnd_x\nrenderqwnd_y\nlastrenderpath\nrenderwnd_x\nrenderwnd_y\nrealtime\nrenderq\nitems\nrenderq_x\nrenderq_y\nrenderq_w\nrenderq_h\nresample\nrouting_mode\nrouting_show\nroutingwnd_x\nroutingwnd_y\nroutingwnd_w\nroutingwnd_h\nrouting_dock\nrecmenu\ndestination\ngrouping\nslave\nscreensetwnd_lasttab\nscreenset\nmask"
  A=A.."\nleftpanel_size\nmainwnd_status\ndockersel\nmainwnd_rect\nposlist_size\nfocus\nlayouts\nsset_save_mask\nsset_view_save_mask\ntmpset\ndocker_\nexplorer\ntsi_thrhyst\ntsi_minsil\ntsi_minnonsil\ntsi_snappk\ntsi_lead\ntsi_trail\ntsi_flags\nsilence\nsplash_log\ntoolbar_save\ntoolbar_load\ntoolbar_revert\ntoolbar_new\ntoolbar_projprop\ntoolbar_undo\ntoolbar_redo\ntoolbar_lock_on\ntoolbar_lock_off\ntoolbar_envitem_off\ntoolbar_envitem_on\ntoolbar_grid_off\ntoolbar_grid_on\ntoolbar_snap_off\ntoolbar_snap_on\ntoolbar_relsnap_off"
  A=A.."\ntoolbar_relsnap_on\ntoolbar_ripple_off\ntoolbar_ripple_one\ntoolbar_ripple_all\ntoolbar_group_on\ntoolbar_group_off\ntoolbar_xfade_off\ntoolbar_xfade_on\ntoolbar_metro_off\ntoolbar_metro_on\ntransport_record\ntransport_record_on\ntransport_record_loop\ntransport_record_loop_on\ntransport_record_item\ntransport_record_item_on\ntransport_play\ntransport_play_on\ntransport_play_sync\ntransport_play_sync_on\ntransport_pause\ntransport_pause_on\ntransport_repeat_off\ntransport_repeat_on\ntrack_env\ntrack_env_read\ntransport_automation_read"
  A=A.."\ntrack_env_touch\ntransport_automation_touch\ntrack_env_write\ntransport_automation_write\ntrack_env_latch\ntransport_automation_latch\ntrack_env_preview\nmcp_env\nmcp_env_read\nmcp_env_touch\nmcp_env_write\nmcp_env_latch\nmcp_env_preview\ntransport_home\ntransport_end\ntransport_stop\ntransport_previous\ntransport_next\nmixer_menu\ntrack_phase_norm\ntrack_phase_inv\ntrack_stereo\ntrack_mono\ntrack_fx_norm\ntrack_fx_dis\ntrack_fx_empty\nitem_fx_off\nitem_fx_on\nitem_env_off\nitem_env_on\nitem_lock_off\nitem_lock_on\nitem_note_off\nitem_note_on"
  A=A.."\nitem_mute_off\nitem_mute_on\nitem_group\nitem_group_sel\nitem_props\nitem_props_on\nitem_pooled\nitem_pooled_on\nitem_volknob\nitem_volknob_stack\nmonitor_fx_off\nmonitor_fx_on\nmonitor_fx_byp\nmonitor_fx_byp_off\nmonitor_fx_byp_on\nmonitor_fx_byp_byp\nmcp_send_knob_stack\nmcp_fxparm_knob_stack\ntcp_fxparm_knob_stack\ntrack_fxoff_h\ntrack_fxoff_v\ntrack_fxon_h\ntrack_fxon_v\ntrack_fxempty_h\ntrack_fxempty_v\ntrack_monitor_off\ntrack_monitor_on\ntrack_monitor_auto\ntrack_recarm_off\ntrack_recarm_on\ntrack_recarm_auto\ntrack_recarm_auto_on"
  A=A.."\ntrack_mute_off\ntrack_mute_on\ntrack_solo_off\ntrack_solo_on\ntrack_folder_off\ntrack_folder_on\ntrack_folder_last\ntrack_fcomp_off\ntrack_fcomp_small\ntrack_fcomp_tiny\nmcp_fcomp_off\nmcp_fcomp_tiny\ntrack_recmode_in\ntrack_recmode_out\ntrack_recmode_off\nfader_h\nfader_v\ntransport_bg\ntcp_bg\nmcp_bg\ntcp_bgsel\nmcp_bgsel\ntcp_folderbg\nmcp_folderbg\ntcp_folderbgsel\nmcp_folderbgsel\nmcp_mainbg\nmcp_mainbgsel\ntcp_mainbg\ntcp_mainbgsel\ntcp_iconbg\ntcp_iconbgsel\ntcp_mainiconbg\ntcp_mainiconbgsel\nmcp_iconbg\nmcp_iconbgsel"
  A=A.."\nmcp_mainiconbg\nmcp_mainiconbgsel\nmcp_extmixbg\nmcp_extmixbgsel\nmcp_mainextmixbg\nmcp_mainextmixbgsel\ntcp_idxbg\ntcp_idxbg_sel\nmcp_idxbg\nmcp_idxbg_sel\ntoolbar_bg\nitem_bg\nitem_bg_sel\nitem_loop\nfolder_start\nfolder_indent\nfolder_end\npiano_white_key\npiano_white_key_sel\npiano_black_key\npiano_black_key_sel\ntoolbar_blank\ncomposite_toolbar_overlay\ntcp_vol_label\ntcp_pan_label\ntcp_wid_label\nmcp_vol_label\nmcp_pan_label\nmcp_wid_label\ntcp_master_vol_label\ntcp_master_pan_label\ntcp_master_wid_label\nmcp_master_vol_label"
  A=A.."\nmcp_master_pan_label\nmcp_master_wid_label\nvu_indicator\ntcp_volbg\ntcp_volthumb\ntcp_panbg\ntcp_panthumb\ntcp_panbg_vert\ntcp_panthumb_vert\nmcp_volbg\nmcp_volthumb\nmcp_panbg\nmcp_panthumb\nmcp_panbg_vert\nmcp_panthumb_vert\ntcp_volbg_vert\ntcp_volthumb_vert\nmcp_volbg_horz\nmcp_volthumb_horz\ntcp_widthbg\ntcp_widththumb\ntcp_widthbg_vert\ntcp_widththumb_vert\nmcp_widthbg\nmcp_widththumb\nmcp_widthbg_vert\nmcp_widththumb_vert\nenvcp_faderbg\nenvcp_fader\nenvcp_faderbg_vert\nenvcp_fader_vert\ntransport_playspeedbg\ntransport_playspeedthumb"
  A=A.."\ntransport_playspeedbg_vert\ntransport_playspeedthumb_vert\ntcp_vu\nmcp_vu\nmcp_master_vu\ntcp_namebg\nmcp_namebg\ntcp_main_namebg\ntcp_main_namebg_sel\nmcp_main_namebg\nmcp_main_namebg_sel\nmcp_fxlist_norm\nmcp_fxlist_byp\nmcp_fxlist_off\nmcp_fxlist_empty\nmcp_fxlist_arrows\nmcp_arrowbuttons_ud\nmcp_arrowbuttons_lr\ntcp_arrowbuttons_ud\ntcp_arrowbuttons_lr\nmcp_master_fxlist_norm\nmcp_master_fxlist_byp\nmcp_master_fxlist_off\nmcp_master_fxlist_empty\nmcp_master_fxlist_arrows\nmcp_sendlist_arrows\nmcp_sendlist_norm\nmcp_sendlist_knob"
  A=A.."\nmcp_sendlist_meter\nmcp_sendlist_mute\nmcp_sendlist_midihw\nmcp_sendlist_empty\nmcp_master_sendlist_arrows\nmcp_master_sendlist_norm\nmcp_master_sendlist_knob\nmcp_master_sendlist_meter\nmcp_master_sendlist_mute\nmcp_master_sendlist_empty\nmcp_sendlist_knob_bg\nmcp_fxparm_knob_bg\ntcp_fxparm_knob_bg\nmcp_fxparm_norm\nmcp_fxparm_byp\nmcp_fxparm_off\nmcp_fxparm_empty\nmcp_fxparm_arrows\nmcp_fxparm_knob\nmcp_fxparm_bg\ntcp_fxparm_norm\ntcp_fxparm_byp\ntcp_fxparm_off\ntcp_fxparm_empty\ntcp_fxparm_arrows_lr\ntcp_fxparm_arrows_ud\ntcp_fxparm_knob"
  A=A.."\ntcp_fxparm_bg\nmcp_sendlist_bg\nmcp_master_sendlist_bg\nmcp_fxlist_bg\nmcp_master_fxlist_bg\nmaster_tcp_io\nmaster_mcp_io\ntrack_io\nmcp_io\ntrack_io_dis\nmcp_io_dis\ntrack_io_r\ntrack_io_s\ntrack_io_s_r\ntrack_io_r_dis\ntrack_io_s_dis\ntrack_io_s_r_dis\nmcp_io_r\nmcp_io_s\nmcp_io_s_r\nmcp_io_r_dis\nmcp_io_s_dis\nmcp_io_s_r_dis\nmcp_phase_norm\nmcp_phase_inv\nmcp_stereo\nmcp_mono\nmcp_fx_norm\nmcp_fx_dis\nmcp_fx_empty\nmcp_monitor_off\nmcp_monitor_on\nmcp_monitor_auto\nmcp_recarm_off\nmcp_recarm_on\nmcp_recarm_auto\nmcp_recarm_auto_on"
  A=A.."\nmcp_mute_off\nmcp_mute_on\nmcp_solo_off\nmcp_solo_on\nmcp_folder_on\nmcp_folder_last\nmcp_recmode_in\nmcp_recmode_out\nmcp_recmode_off\nmidi_inline_close\nmidi_inline_noteview_rect\nmidi_inline_noteview_diamond\nmidi_inline_noteview_triangle\nmidi_inline_fold_none\nmidi_inline_fold_unnamed\nmidi_inline_fold_unused_unnamed\nmidi_inline_ccwithitems_off\nmidi_inline_ccwithitems_on\nmidi_inline_scroll\nmidi_inline_scrollbar\nmidi_inline_scrollthumb\nmidi_note_colormap\ntoolbar_dock_off\ntoolbar_dock_on\ntoolbar_filter_off\ntoolbar_filter_on"
  A=A.."\ntoolbar_filter_solo\ntoolbar_add\ntoolbar_delete\ntoolbar_sync_on\ntoolbar_sync_off\ntoolbar_quant_off\ntoolbar_quant_on\ntoolbar_midi_tracksel_off\ntoolbar_midi_tracksel_on\ntoolbar_midi_itemsel_off\ntoolbar_midi_itemsel_on\ntab_up\ntab_up_sel\ntab_down\ntab_down_sel\ntcp_solodefeat_on\nmcp_solodefeat_on\ntcp_recinput\nmcp_recinput\ntransport_bpm\ntransport_bpm_bg\ntransport_group_bg\ntransport_edit_bg\ntransport_status_bg\ntransport_status_bg_err\ngen_mute_off\ngen_mute_on\ngen_solo_off\ngen_solo_on\ngen_stereo\ngen_mono"
  A=A.."\ngen_phase_norm\ngen_phase_inv\ngen_midi_off\ngen_midi_on\ngen_env\ngen_env_read\ngen_env_touch\ngen_env_write\ngen_env_latch\ngen_env_preview\ngen_play\ngen_play_on\ngen_pause\ngen_pause_on\ngen_repeat_off\ngen_repeat_on\ngen_home\ngen_end\ngen_stop\ngen_io\ntoosmall_r\ntoosmall_b\ngen_volbg_horz\ngen_volthumb_horz\ngen_panbg_horz\ngen_panthumb_horz\ngen_volbg_vert\ngen_volthumb_vert\ngen_panbg_vert\ngen_panthumb_vert\nmcp_fx_in_norm\ntrack_fx_in_norm\nmcp_fx_in_empty\ntrack_fx_in_empty\nglobal_trim\nglobal_read\nglobal_touch"
  A=A.."\nglobal_write\nglobal_latch\nglobal_preview\nglobal_off\nglobal_bypass\nenvcp_hide\nenvcp_learn\nenvcp_parammod\nenvcp_totrack\nenvcp_arm_off\nenvcp_arm_on\nenvcp_bypass_off\nenvcp_bypass_on\nenvcp_parammod_on\nenvcp_learn_on\nenvcp_bg\nenvcp_bgsel\nenvcp_namebg\nsplash\ngen_knob_bg_large\ngen_knob_bg_small\ntcp_vol_knob_large\ntcp_vol_knob_small\ntcp_pan_knob_large\ntcp_pan_knob_small\ntcp_width_knob_large\ntcp_width_knob_small\nmcp_vol_knob_large\nmcp_vol_knob_small\nmcp_pan_knob_large\nmcp_pan_knob_small"
  A=A.."\nmcp_width_knob_large\nmcp_width_knob_small\nenvcp_knob_large\nenvcp_knob_small\nmeter_mute\nmeter_automute\nmeter_unsolo\nmeter_solodim\nmeter_foldermute\nmeter_bg_h\nmeter_bg_v\nmeter_ol_h\nmeter_ol_v\nmeter_bg_tcp\nmeter_bg_mcp\nmeter_ol_tcp\nmeter_ol_mcp\nmeter_strip_v\nmeter_strip_h\nmeter_clip_v\nmeter_clip_h\nmeter_bg_mcp_master\nmeter_ol_mcp_master\nmeter_strip_v_rms\nmeter_clip_v_rms\nknob_stack\ntcp_vol_knob_stack\ntcp_pan_knob_stack\ntcp_wid_knob_stack\nmcp_vol_knob_stack\nmcp_pan_knob_stack\nmcp_wid_knob_stack"
  A=A.."\nenvcp_knob_stack\ntable_expand_off\ntable_expand_on\ntable_mute_off\ntable_mute_on\ntable_recarm_off\ntable_recarm_on\ntable_solo_off\ntable_solo_on\ntable_sub_expand_off\ntable_sub_expand_on\ntable_target_off\ntable_target_on\ntable_target_invalid\ntable_visible_off\ntable_visible_on\nmidi_item_bounds\ntable_locked_off\ntable_locked_on\ntable_visible_partial\ntable_locked_partial\ntable_remove_off\ntable_remove_on\nreapthemeld\nitem_\nendmacro\nmacro\ngen_pan_zeroline\ngen_vol_zeroline\ntrans_speed_zeroline"
  A=A.."\nmcp_width_zeroline\ntcp_width_zeroline\nmcp_pan_zeroline\nmcp_vol_zeroline\ntcp_pan_zeroline\ntcp_vol_zeroline\nuse_overlays\nuse_lvgs\nuse_pngs\ntransport_showborders\nno_meter_reclbl\nmcp_min_height\nenvcp_min_height\nmcp_altmeterpos\nmcp_showborders\nmcp_mastervupeakheight\nmcp_vupeakheight\ntcp_showborders\ntcp_vupeakwidth\nitem_volknobfg\nmcp_master_voltext_flags\ntcp_master_voltext_flags\nmcp_voltext_flags\ntcp_voltext_flags\ntcp_master_minheight\ntcp_heights\ntcp_folderindent\nglobal_scale\ncol_mi_label"
  A=A.."\ncol_mi_label_sel\ncol_mi_label_float\ncol_mi_label_float_sel\ncol_mi_bg\ncol_mi_fades\ncol_tl_fg\ncol_tl_bg\ncol_trans_fg\ncol_trans_bg\ncol_tl_bgsel\nmidi_selbg\ncol_peaksedge\ncol_peaksedgesel\ncol_peaksfade\ncol_stretchmarker\ncol_stretchmarker_b\ncol_stretchmarker_tm\ncol_stretchmarkerm\ncol_stretchmarker_text\ncol_offlinetext\ncol_seltrack\ncol_cursor\ncol_gridlines\nitem_grouphl\ncol_main_bg\ncol_main_resize\ncol_main_text\ncol_toolbar_text\ncol_toolbar_text_on\ncol_toolbar_frame\ncol_tcp_text"
  A=A.."\ncol_tcp_textsel\nio_text\ncol_main_textshadow\ncol_main_editbk\ncol_tsigmark\ncol_vudoint\ncol_vubot\ncol_vumid\ncol_vutop\ncol_vuclip\ncol_vuintcol\ncol_transport_editbk\ncol_vumidi\ncol_buttonbg\ncol_fadearm\nmarquee_fill\nmarquee_outline\nmarquee_drawmode\nmarqueezoom_fill\nmarqueezoom_outline\nmarqueezoom_drawmode\nmidieditorlist_bg\nmidieditorlist_fg\nmidieditorlist_grid\ngenlist_bg\ngenlist_fg\ngenlist_grid\ngenlist_selbg\ngenlist_selfg\ngenlist_seliabg\ngenlist_seliafg\nmidieditorlist_selbg\nmidieditorlist_selfg"
  A=A.."\nmidieditorlist_seliabg\nmidieditorlist_seliafg\ntimesel_drawmode\nmidi_selbg_drawmode\nitembg_drawmode\nfadezone_drawmode\nfadearea_drawmode\nplaycursor_drawmode\nguideline_drawmode\ntoolbararmed_drawmode\ntcplocked_drawmode\ncc_chase_drawmode\ntoolbararmed_color\nfadezone_color\nfadearea_color\nplaycursor_color\nguideline_color\ntcplocked_color\nselitem_tag\nactivetake_tag\nmidifont_col_dark\nmidifont_col_light\nscore_bg\nscore_fg\nscore_sel\nscore_timesel\nscore_loop\nregion_lane_bg\nmarker_lane_bg\nts_lane_bg"
  A=A.."\nregion_lane_text\nmarker_lane_text\nts_lane_text\ncol_mixerbg\ncol_tracklistbg\ncol_arrangebg\nmidi_rulerbg\nmidi_rulerfg\nmidioct\nmidioct_inline\nplayrate_edited\nmidi_endpt\nmidi_notebg\nmidi_notefg\nmidi_notemute\nmidi_notemute_sel\nmidi_itemctl\nmidi_editcurs\nmidi_ofsn\nmidi_ofsnsel\nmidi_noteon_flash\ndocker_shadow\ndocker_selface\ndocker_unselface\ndocker_text\ndocker_text_sel\ndocker_bg\nwindowtab_bg\nmcp_fx_normal\nmcp_fx_bypassed\nmcp_fx_offlined\nmcp_fxparm_normal\nmcp_fxparm_bypassed\nmcp_fxparm_offlined"
  A=A.."\nmcp_sends_normal\nmcp_send_midihw\nmcp_sends_muted\nmcp_sends_levels\nenv_track_mute\nenv_sends_mute\nenv_item_vol\nenv_item_pan\nenv_item_mute\nenv_item_pitch\nauto_item_unsel\ntimesig_sel_bg\narrange_vgrid\ntl_font\ntrans_font\nmi_font\nlb_font\nui_img\nui_img_path\nedges\nctrls\nenvs\nstrmarkers\ncpy\ndelete\nincrease\nincr\ndecrease\ndecr\nprevious\nprev\nforward\nfwd\nquantize\nconfig_toolbar\nmcp_routing_dd\nmcp_fx_dd\nextmix_multiresize\nextmix_allresize\nextmix_resize\nextmix_multisection_resize"
  A=A.."\nextmix_allsection_resize\nextmix_section_resize\nmcp_resize\nparm\ntcp_routing_dd\ntcp_resize\nroutdlg\nroutdlg_heading\nchannel\ntouch\nlatch\nvwnd_trackpanel_container\nenvname\nenv_pt_move\nenv_pencil\narrange_dd_copy\narrange_slide\narrange_move\narrange_dualstretch\narrange_dualedge\narrange_leftstretch\narrange_leftresize\narrange_rightstretch\narrange_rightresize\nxfade_move\nxfade_curve\nfadein_curve\narrange_fadein\nfadeout_curve\narrange_fadeout\nxfade_width\narrange_itemvol\nenv_pt_bez\nenv_seg"
  A=A.."\nitemenv_dd\nitemenv_dd_no\nitemfx_dd\nitemfx_dd_no\nspecedit\nsendmenu\nenvmenu\narrange_leftadd\narrange_rightadd\narrange_pencil\nenv_addpt\nspecedit_leftedge\nspecedit_rightedge\nspecedit_pencil\nspecedit_topedge\nspecedit_bottomedge\nspecedit_nwse\nspecedit_nesw\nspecedit_move\narrange_stretchmarker\narrange_stretchmarker_rate\narrange_snapoffs\narrange_freesize\narrange_notes\narrange_pan_adj\narrange_pitch_adj\narrange_timeitemsel\narrange_marquee\narrange_marqueezoom\narrange_armedaction"
  A=A.."\nfreezedesc\nruler_timesel\narrange_ibeam\narrange_scroll\narrange_handscroll\nruler_region\nruler_regionedge_left\nruler_regionedge_right\nruler_regionedge_dual\nruler_marker\nruler_tsmarker\nruler_scroll\ntimesel_move\ntransport_dock\ntransport_x\ntransport_y\ntransport_w\ntransport_h\nundoinfo\nundohist\nundodiff_pos\nundownd_x\nundownd_y\nundownd_w\nundownd_h\nundownd_dock\nvol\nrearoute_in\nrearoute_out\nlicecap_path\ncommon\nvkb\nnotecenter\nvkb_notes\narrowen\nvst_dll_options\nvst_noidle\nfxpdir"
  A=A.."\n_def\nstereo\nvst_common\nlabl\nsmpl\npins\nauds\noay\nvgk\nsqrtl\nsqrtf\nlogl\nlogf\nexpl\nexpf\npowl\npowf\nscalbl\nscalb\nscalbf\nhypotl\nhypot\nhypotf\nacosl\nacosf\nasinl\nasinf\nacosdl\nacosd\nacosdf\nasindl\nasind\nasindf\ncoshl\ncosh\ncoshf\nsinhl\nsinh\nsinhf\nacoshl\nacosh\nacoshf\natanhl\natanh\natanhf\nerfinvl\nerfinv\nerfinvf\ngammal\ngamma\ngammaf\nlgammal\nlgamma\nlgammaf\ntgammal\ntgamma\ntgammaf\njnl\njnf\nynl\nynf\nfmodl\nfmodf\nremainderl\nremainder\nremainderf\ndkc\nfmx\nsgy"
  A=A.."\nmxe\nutpn\nxpxxxx\nslovak\nholland\nengland\nczech\nchina\nbritain\namerica\nusa\nswiss\nnorwegian\nchinese\nchi\nchh\ncanadian\nbelgian\naustralian\namerican\noperator\nnew\n__unaligned\n__restrict\n__clrcall\n__fastcall\n__thiscall\n__stdcall\n__pascal\n__cdecl\nxppwpp\npxz\nrdh\nktf\njtf\nmdr\nftq\nldr\ndtq\nypc\ncqc\nwod\nyhe\nwvj\nttk\nqtl\nytr\nztr\nyhn\nyjp\nutt\nttt\ncjt\nkwu\nzxv\nifw\nccg\nfffff\nlfffl\nbhxhb\nflxlf\nffff\nibt\nwave\nddd\nabcdefghijklmnopqrstuvwxyz\nfca\nfib\nhib\nvpb\nxpb"
  A=A.."\npqb\ngsd\nzae\nlke\nrme\ntme\nhpe\nnoi\npoi\nfbl\naap\nnwp\npwp\npfq\njtr\nltr\npvt\njyt\nlyt\nlku\nfou\nhou\nqpu\ndpv\njtv\nltv\nmyw\npfx\nirz\nprz\nbvz\npvz\ngxz\nuzz\nqauds\ntrackview\ntimeline\nldexp\nfrexp\ncosf\nsinf\nwrite_message\n__libm_error_support\nmatherrf\nmatherr\nmatherrl\nmegabytes\nfirst\nlast\nins\ndown\noctaves\ncues\nlabel\naca\nalways\nnever\nevery\ncoloredit\nripctx\nbnd_en"
--]]
end


-- prepare all entries and read their current values

-- Keep in mind, you must have all config-variable-names in the clipboard to execute 
-- the script successfully. You can find a list for Reaper 5.80 to copy'n'paste in the
-- comment-section at the beginning of this script.
-- Every variable-name must be in it's own line without trailing or preceding whitespaces or tabs!
vars={} -- variable-values
vars_double={}
vars_string={}
vars2={} -- variable-names
counter=0
i=1 -- number of variables(for later use)
for line in A:gmatch("(.-)\n") do
  if vars[line]==nil then counter=counter+1 end
  vars[line]=reaper.SNM_GetIntConfigVar(line,-8)
  vars_double[line]=reaper.SNM_GetDoubleConfigVar(line,-8)
  if reaper.get_config_var_string==nil then vars_string[line]="String variable not available in this Reaper-version, sorry." else _t,vars_string[line]=reaper.get_config_var_string(line) end
  i=i+1
  vars2[i]=line
end

count=1
Lotto=1

-- Let's do the magic
function main()
  Lotto=Lotto+1
  if Lotto==15 then Lotto=1
    -- update only every 15th cycle, to save ressources.
    for a=1, i do
      line=vars2[a]
      if reaper.get_config_var_string==nil then 
      temp="String variable not available in this Reaper-version, sorry." 
      else _t,temp=reaper.get_config_var_string(line) end
      -- go through all variables and see, if their values have changed since last defer-run
      -- if they've changed, display them and update the value stored in the table vars
      if reaper.SNM_GetIntConfigVar(line,-8)==vars[line] and 
--      reaper.SNM_GetDoubleConfigVar(line,-8)==vars_double[line] and
      temp==vars_string[line] then
      elseif line~=nil then
        vars[line]=reaper.SNM_GetIntConfigVar(line,-8) -- update value
        vars_double[line]=reaper.SNM_GetDoubleConfigVar(line,-8)
        if reaper.get_config_var_string==nil then vars_string[line]="String variable not available in this Reaper-version, sorry." else _t,vars_string[line]=reaper.get_config_var_string(line) end
        if line~=nil and line~="" and count==3 then reaper.ShowConsoleMsg("\n"..line..": \n       int: "..vars[line].."\n       double: "..vars_double[line].."\n       string: "..vars_string[line].."\n") end -- show varname and value        
        a1=vars[line]&1 if a1~=0 then a1=1 end
        a2=vars[line]&2 if a2~=0 then a2=1 end
        a3=vars[line]&4 if a3~=0 then a3=1 end
        a4=vars[line]&8 if a4~=0 then a4=1 end
        a5=vars[line]&16 if a5~=0 then a5=1 end
        a6=vars[line]&32 if a6~=0 then a6=1 end
        a7=vars[line]&64 if a7~=0 then a7=1 end
        a8=vars[line]&128 if a8~=0 then a8=1 end
  
        a9=vars[line]&256 if a9~=0 then a9=1 end
        a10=vars[line]&512 if a10~=0 then a10=1 end
        a11=vars[line]&1024 if a11~=0 then a11=1 end
        a12=vars[line]&2048 if a12~=0 then a12=1 end
        a13=vars[line]&4096 if a13~=0 then a13=1 end
        a14=vars[line]&8192 if a14~=0 then a14=1 end
        a15=vars[line]&16384 if a15~=0 then a15=1 end
        a16=vars[line]&32768 if a16~=0 then a16=1 end
        
        a17=vars[line]&65536 if a17~=0 then a17=1 end
        a18=vars[line]&131072 if a18~=0 then a18=1 end
        a19=vars[line]&262144 if a19~=0 then a19=1 end
        a20=vars[line]&524288 if a20~=0 then a20=1 end
        a21=vars[line]&1048576 if a21~=0 then a21=1 end
        a22=vars[line]&2097152 if a22~=0 then a22=1 end
        a23=vars[line]&4194304 if a23~=0 then a23=1 end
        a24=vars[line]&8388608 if a24~=0 then a24=1 end
  
        a25=vars[line]&16777216 if a25~=0 then a25=1 end
        a26=vars[line]&33554432 if a26~=0 then a26=1 end
        a27=vars[line]&67108864 if a27~=0 then a27=1 end
        a28=vars[line]&134217728 if a28~=0 then a28=1 end
        a29=vars[line]&268435456 if a29~=0 then a29=1 end
        a30=vars[line]&536870912 if a30~=0 then a30=1 end
        a31=vars[line]&1073741824 if a31~=0 then a31=1 end
        a32=vars[line]&2147483648 if a32~=0 then a32=1 end
        
        if count==3 then 
          reaper.ShowConsoleMsg("       Bitfield, with &1 at start: "..a1.." "..a2.." "..a3.." "..a4..":"..a5.." "..a6.." "..a7.." "..a8.." - "..a9.." "..a10.." "..a11.." "..a12..":"..a13.." "..a14.." "..a15.." "..a16.." - "..a17.." "..a18.." "..a19.." "..a20..":"..a21.." "..a22.." "..a23.." "..a24.." - "..a25.." "..a26.." "..a27.." "..a28..":"..a29.." "..a30.." "..a31.." "..a32.."\n") 
          Lr,LLr=reaper.BR_Win32_GetPrivateProfileString("REAPER", line,"nothingfound",reaper.get_ini_file())
          if LLR~="nothingfound" then reaper.ShowConsoleMsg("       Entry in the reaper.ini: [REAPER] -> "..line.."   - Currently-set-ini-value: "..LLr.."\n") end
        end--]]
      end
    end
  if count~=3 then count=2 end
  -- after the first run, show an introduction to the script
    if count==2 then 
      reaper.ClearConsole() 
      reaper.ShowConsoleMsg("Reaper-Config-Variable-Inspector by Meo Mespotine(mespotine.de) 18.5.2018 for Ultraschall.fm\n\n  This shows all altered Config-Variables and their bitwise-representation as well as the value in the reaper.ini,\n  that can be accessed at runtime through LUA using the SWS-functions: \n     SNM_GetIntConfigVar(), SNM_SetIntConfigVar(), SNM_GetDoubleConfigVar() and SNM_SetDoubleConfigVar(). \n\n  These variables cover the preferences window, project-settings, render-dialog, settings in the context-menu of \n  transportarea and numerous other things.\n\n  Just change some settings in the preferences and click apply to see, which variable is changed to which value, \n  shown in this Reascript-Console.\n\n  Keep in mind: certain variables use bit-wise-values, which means, that one variable may contain the settings for \n  numerous checkboxes; stored using a bitmask, which will be shown in here as well.\n\n") 
      reaper.ShowConsoleMsg("  Mismatch between int/double-values the currently set reaper.ini-value(as well as only int/double changing) is a hint at,\n  that the value is not stored into reaper.ini.\n\n")
      reaper.ShowConsoleMsg("IMPORANT! This script has an issue with float-variables, when the float is set as an integer, it's changes will not be shown.\n      For instance, when setting projmaxlen (maximum project-length) in Project Settings, it will not update, if you \n      set the value to 1.000, but it will update it, when you set it to 1.001(triggering the float-section of the value).\n      So when reverse-engineering floats, keep in mind to set the float-part of the value, or it will not show up!\n      Sorry for that...\n")      count=3 
    end
  end
  reaper.defer(main)
end

main() -- kick it off

 
