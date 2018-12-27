dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

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
  
  vars={} -- variable-values
  vars2={} -- variable-names
  counter=0
  i=1 -- number of variables(for later use)
  for line in A:gmatch("(.-)\n") do
    if vars[line]==nil then counter=counter+1 end
    reaper.SNM_SetIntConfigVar(line,reaper.SNM_GetIntConfigVar(line,-8)+2)
    vars[line]=reaper.SNM_GetIntConfigVar(line,-8)
    i=i+1
    vars2[i]=line
  end
  
I=53997
I=55470
-- I=-1
I=26752
K=0
a=5 --a=2
AnzahlToggleActions=0
CommandName=""
O=0
Lotto=0
count=1
-- Options: Add edge points when ripple editing or inserting time

function checkchanges(SECTION, AID)
    for a=1, i do
      line=vars2[a]

      -- go through all variables and see, if their values have changed since last defer-run
      -- if they've changed, display them and update the value stored in the table vars
      if reaper.SNM_GetIntConfigVar(line,-8)==vars[line] then--and reaper.SNM_GetDoubleConfigVar(line,-7)==vars[line] then
      elseif line~=nil then
        vars[line]=reaper.SNM_GetIntConfigVar(line,-8) -- update value
        varsB=reaper.SNM_GetDoubleConfigVar(line,-8)
        if line~=nil and line~="" then reaper.ShowConsoleMsg("\n"..line.."\n       int: "..vars[line].."\n       double: "..varsB.."\n") end -- show varname and value        
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
        

          A=reaper.GetExtState("hack","count")
          reaper.ShowConsoleMsg(A.."       Bitfield, with &1 at start: "..a1.." "..a2.." "..a3.." "..a4..":"..a5.." "..a6.." "..a7.." "..a8.." - "..a9.." "..a10.." "..a11.." "..a12..":"..a13.." "..a14.." "..a15.." "..a16.." - "..a17.." "..a18.." "..a19.." "..a20..":"..a21.." "..a22.." "..a23.." "..a24.." - "..a25.." "..a26.." "..a27.." "..a28..":"..a29.." "..a30.." "..a31.." "..a32.."\n") 
          Lr,LLr=reaper.BR_Win32_GetPrivateProfileString("REAPER", line,"nothingfound",reaper.get_ini_file())
          if LLR~="nothingfound" then reaper.ShowConsoleMsg("       Entry in the reaper.ini: [REAPER] -> "..line.."   - Currently-set-ini-value: "..LLr.."\n") end
          ultraschall.WriteValueToFile("c:\\ShowVars_Toggle-midi.txt", A.."="..line.." \t - INT: "..(vars[line]-2).."  - DOUBLE: "..(varsB-2).."\n", false, true) 

      end
    end
  count=count+1
  if count~=3 then count=2 end  
end

function main()
if Lotto==1 then Lotto=-1 end
Lotto=Lotto+1
if Lotto==1 then
--  I=I+1
if K==0 then 
  for i=0, 10000 do
    I=I+1
    T=reaper.GetToggleCommandState(I)
    CommandName=tostring(reaper.ReverseNamedCommandLookup(I))
    if T~=-1 and CommandName=="nil" then O=O+1 break end
  end
end
  if a==0 then Section=0
  elseif a==1 then Section=100
  elseif a==2 then Section=32060
  elseif a==3 then Section=32061
  elseif a==4 then Section=32062
  elseif a==5 then Section=32063
  end
  if I>65536 then a=a+1 I=0 end
  L=reaper.ReverseNamedCommandLookup(I)                      
  reaper.SetExtState("hack","count","Sec:"..tostring(Section).."_AID:"..tostring(I),true)
  if K>0 then reaper.Main_OnCommand(I,0)     
    checkchanges(Section, I) 
    K=K+1 end --else I=I+1 end
  if K==0 and T~=-1 then 
    reaper.Main_OnCommand(I,0)
    checkchanges(Section, I)
    K=K+1 
    AnzahlToggleActions=AnzahlToggleActions+1 
  end
--  if I<=65536 then reaper.defer(main) end
  T2=reaper.GetToggleCommandState(I)
  if a<=5 then reaper.defer(main) end
  if K==3 then K=0 end
else
reaper.defer(main)
end
end

main()

--[[  reaper.Main_OnCommand(I,0)
  reaper.Main_OnCommand(I,0)
  reaper.Main_OnCommand(I,0)
  reaper.Main_OnCommand(I,0)
--]]


