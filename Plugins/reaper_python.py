import re
from ctypes import *

# lowercase rpr_ functions are for internal use

_ft={}

def rpr_initft(ft):
  if (len(_ft) == 0):
    _ft.update(ft)

def rpr_getfp(fn):
  return _ft[fn]

def rpr_packp(t,v):
  m=re.match('^\((\w+\*|HWND)\)0x([0-9A-F]+)$', str(v))
  if (m != None):
    (_t,_v)=m.groups()
    if (_t == t or t == 'void*'):
      a=int(_v[:8],16)
      b=int(_v[8:],16);
      p=c_uint64((a<<32)|b).value
      if (RPR_ValidatePtr(p,t)):
        return p
  return 0

def rpr_unpackp(t,v):
  if (v == None):
    v=0
  a=int(v>>32)
  b=int(v&0xFFFFFFFF)
  return '(%s)0x%08X%08X' % (t,a,b)

def RPR_ValidatePtr(p,t):
  a=_ft['ValidatePtr']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p)(a)
  return f(c_uint64(p),rpr_packsc(t))

def rpr_packsc(v):
  return c_char_p(str(v).encode("UTF-8"))

def rpr_packs(v):
  MAX_STRBUF=4*1024*1024
  return create_string_buffer(str(v).encode("UTF-8"),MAX_STRBUF)

def rpr_unpacks(v):
  return str(v.value.decode())

def RPR_GetAudioAccessorSamples(p0,p1,p2,p3,p4,p5):
  a=_ft['GetAudioAccessorSamples']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_int,c_double,c_int,c_void_p)(a)
  v=cast((c_double*p2*p4)(),POINTER(c_double))
  t=(rpr_packp('void*',p0),c_int(p1),c_int(p2),c_double(p3),c_int(p4),v)
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  for i in range(p2*p4):
    p5[i]=float(v[i])
  return (r,p5)

def RPR_AddMediaItemToTrack(p0):
  a=_ft['AddMediaItemToTrack']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaItem*',r)

def RPR_AddProjectMarker(p0,p1,p2,p3,p4,p5):
  a=_ft['AddProjectMarker']
  f=CFUNCTYPE(c_int,c_uint64,c_byte,c_double,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),c_double(p2),c_double(p3),rpr_packsc(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_AddProjectMarker2(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['AddProjectMarker2']
  f=CFUNCTYPE(c_int,c_uint64,c_byte,c_double,c_double,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),c_double(p2),c_double(p3),rpr_packsc(p4),c_int(p5),c_int(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return r

def RPR_AddRemoveReaScript(p0,p1,p2,p3):
  a=_ft['AddRemoveReaScript']
  f=CFUNCTYPE(c_int,c_byte,c_int,c_char_p,c_byte)(a)
  t=(c_byte(p0),c_int(p1),rpr_packsc(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_AddTakeToMediaItem(p0):
  a=_ft['AddTakeToMediaItem']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_AddTempoTimeSigMarker(p0,p1,p2,p3,p4,p5):
  a=_ft['AddTempoTimeSigMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_double,c_int,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_double(p2),c_int(p3),c_int(p4),c_byte(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_adjustZoom(p0,p1,p2,p3):
  a=_ft['adjustZoom']
  f=CFUNCTYPE(None,c_double,c_int,c_byte,c_int)(a)
  t=(c_double(p0),c_int(p1),c_byte(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_AnyTrackSolo(p0):
  a=_ft['AnyTrackSolo']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_APIExists(p0):
  a=_ft['APIExists']
  f=CFUNCTYPE(c_byte,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_APITest():
  a=_ft['APITest']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ApplyNudge(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['ApplyNudge']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int,c_double,c_byte,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_int(p2),c_int(p3),c_double(p4),c_byte(p5),c_int(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return r

def RPR_ArmCommand(p0,p1):
  a=_ft['ArmCommand']
  f=CFUNCTYPE(None,c_int,c_char_p)(a)
  t=(c_int(p0),rpr_packsc(p1))
  f(t[0],t[1])

def RPR_Audio_Init():
  a=_ft['Audio_Init']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_Audio_IsPreBuffer():
  a=_ft['Audio_IsPreBuffer']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_Audio_IsRunning():
  a=_ft['Audio_IsRunning']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_Audio_Quit():
  a=_ft['Audio_Quit']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_AudioAccessorStateChanged(p0):
  a=_ft['AudioAccessorStateChanged']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  r=f(t[0])
  return r

def RPR_AudioAccessorUpdate(p0):
  a=_ft['AudioAccessorUpdate']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  f(t[0])

def RPR_AudioAccessorValidateState(p0):
  a=_ft['AudioAccessorValidateState']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  r=f(t[0])
  return r

def RPR_BypassFxAllTracks(p0):
  a=_ft['BypassFxAllTracks']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_CalculateNormalization(p0,p1,p2,p3,p4):
  a=_ft['CalculateNormalization']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_double,c_double,c_double)(a)
  t=(rpr_packp('PCM_source*',p0),c_int(p1),c_double(p2),c_double(p3),c_double(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_ClearAllRecArmed():
  a=_ft['ClearAllRecArmed']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ClearConsole():
  a=_ft['ClearConsole']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ClearPeakCache():
  a=_ft['ClearPeakCache']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ColorFromNative(p0,p1,p2,p3):
  a=_ft['ColorFromNative']
  f=CFUNCTYPE(None,c_int,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2),c_int(p3))
  f(t[0],byref(t[1]),byref(t[2]),byref(t[3]))
  return (p0,int(t[1].value),int(t[2].value),int(t[3].value))

def RPR_ColorToNative(p0,p1,p2):
  a=_ft['ColorToNative']
  f=CFUNCTYPE(c_int,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CountAutomationItems(p0):
  a=_ft['CountAutomationItems']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('TrackEnvelope*',p0),)
  r=f(t[0])
  return r

def RPR_CountEnvelopePoints(p0):
  a=_ft['CountEnvelopePoints']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('TrackEnvelope*',p0),)
  r=f(t[0])
  return r

def RPR_CountEnvelopePointsEx(p0,p1):
  a=_ft['CountEnvelopePointsEx']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CountMediaItems(p0):
  a=_ft['CountMediaItems']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_CountProjectMarkers(p0,p1,p2):
  a=_ft['CountProjectMarkers']
  f=CFUNCTYPE(c_int,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_int(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (r,p0,int(t[1].value),int(t[2].value))

def RPR_CountSelectedMediaItems(p0):
  a=_ft['CountSelectedMediaItems']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_CountSelectedTracks(p0):
  a=_ft['CountSelectedTracks']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_CountSelectedTracks2(p0,p1):
  a=_ft['CountSelectedTracks2']
  f=CFUNCTYPE(c_int,c_uint64,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_CountTakeEnvelopes(p0):
  a=_ft['CountTakeEnvelopes']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_CountTakes(p0):
  a=_ft['CountTakes']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return r

def RPR_CountTCPFXParms(p0,p1):
  a=_ft['CountTCPFXParms']
  f=CFUNCTYPE(c_int,c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1))
  r=f(t[0],t[1])
  return r

def RPR_CountTempoTimeSigMarkers(p0):
  a=_ft['CountTempoTimeSigMarkers']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_CountTrackEnvelopes(p0):
  a=_ft['CountTrackEnvelopes']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_CountTrackMediaItems(p0):
  a=_ft['CountTrackMediaItems']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_CountTracks(p0):
  a=_ft['CountTracks']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_CreateNewMIDIItemInProj(p0,p1,p2,p3):
  a=_ft['CreateNewMIDIItemInProj']
  f=CFUNCTYPE(c_uint64,c_uint64,c_double,c_double,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],byref(t[3]))
  return (rpr_unpackp('MediaItem*',r),p0,p1,p2,int(t[3].value))

def RPR_CreateTakeAudioAccessor(p0):
  a=_ft['CreateTakeAudioAccessor']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return rpr_unpackp('AudioAccessor*',r)

def RPR_CreateTrackAudioAccessor(p0):
  a=_ft['CreateTrackAudioAccessor']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return rpr_unpackp('AudioAccessor*',r)

def RPR_CreateTrackSend(p0,p1):
  a=_ft['CreateTrackSend']
  f=CFUNCTYPE(c_int,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packp('MediaTrack*',p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_FlushUndo(p0):
  a=_ft['CSurf_FlushUndo']
  f=CFUNCTYPE(None,c_byte)(a)
  t=(c_byte(p0),)
  f(t[0])

def RPR_CSurf_GetTouchState(p0,p1):
  a=_ft['CSurf_GetTouchState']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_GoEnd():
  a=_ft['CSurf_GoEnd']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_GoStart():
  a=_ft['CSurf_GoStart']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_NumTracks(p0):
  a=_ft['CSurf_NumTracks']
  f=CFUNCTYPE(c_int,c_byte)(a)
  t=(c_byte(p0),)
  r=f(t[0])
  return r

def RPR_CSurf_OnArrow(p0,p1):
  a=_ft['CSurf_OnArrow']
  f=CFUNCTYPE(None,c_int,c_byte)(a)
  t=(c_int(p0),c_byte(p1))
  f(t[0],t[1])

def RPR_CSurf_OnFwd(p0):
  a=_ft['CSurf_OnFwd']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_CSurf_OnFXChange(p0,p1):
  a=_ft['CSurf_OnFXChange']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnInputMonitorChange(p0,p1):
  a=_ft['CSurf_OnInputMonitorChange']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnInputMonitorChangeEx(p0,p1,p2):
  a=_ft['CSurf_OnInputMonitorChangeEx']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnMuteChange(p0,p1):
  a=_ft['CSurf_OnMuteChange']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnMuteChangeEx(p0,p1,p2):
  a=_ft['CSurf_OnMuteChangeEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnPanChange(p0,p1,p2):
  a=_ft['CSurf_OnPanChange']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnPanChangeEx(p0,p1,p2,p3):
  a=_ft['CSurf_OnPanChangeEx']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnPause():
  a=_ft['CSurf_OnPause']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_OnPlay():
  a=_ft['CSurf_OnPlay']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_OnPlayRateChange(p0):
  a=_ft['CSurf_OnPlayRateChange']
  f=CFUNCTYPE(None,c_double)(a)
  t=(c_double(p0),)
  f(t[0])

def RPR_CSurf_OnRecArmChange(p0,p1):
  a=_ft['CSurf_OnRecArmChange']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnRecArmChangeEx(p0,p1,p2):
  a=_ft['CSurf_OnRecArmChangeEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnRecord():
  a=_ft['CSurf_OnRecord']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_OnRecvPanChange(p0,p1,p2,p3):
  a=_ft['CSurf_OnRecvPanChange']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnRecvVolumeChange(p0,p1,p2,p3):
  a=_ft['CSurf_OnRecvVolumeChange']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnRew(p0):
  a=_ft['CSurf_OnRew']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_CSurf_OnRewFwd(p0,p1):
  a=_ft['CSurf_OnRewFwd']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_CSurf_OnScroll(p0,p1):
  a=_ft['CSurf_OnScroll']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_CSurf_OnSelectedChange(p0,p1):
  a=_ft['CSurf_OnSelectedChange']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnSendPanChange(p0,p1,p2,p3):
  a=_ft['CSurf_OnSendPanChange']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnSendVolumeChange(p0,p1,p2,p3):
  a=_ft['CSurf_OnSendVolumeChange']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnSoloChange(p0,p1):
  a=_ft['CSurf_OnSoloChange']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_CSurf_OnSoloChangeEx(p0,p1,p2):
  a=_ft['CSurf_OnSoloChangeEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnStop():
  a=_ft['CSurf_OnStop']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_OnTempoChange(p0):
  a=_ft['CSurf_OnTempoChange']
  f=CFUNCTYPE(None,c_double)(a)
  t=(c_double(p0),)
  f(t[0])

def RPR_CSurf_OnTrackSelection(p0):
  a=_ft['CSurf_OnTrackSelection']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  f(t[0])

def RPR_CSurf_OnVolumeChange(p0,p1,p2):
  a=_ft['CSurf_OnVolumeChange']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnVolumeChangeEx(p0,p1,p2,p3):
  a=_ft['CSurf_OnVolumeChangeEx']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnWidthChange(p0,p1,p2):
  a=_ft['CSurf_OnWidthChange']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_CSurf_OnWidthChangeEx(p0,p1,p2,p3):
  a=_ft['CSurf_OnWidthChangeEx']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_byte,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_byte(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_CSurf_OnZoom(p0,p1):
  a=_ft['CSurf_OnZoom']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_CSurf_ResetAllCachedVolPanStates():
  a=_ft['CSurf_ResetAllCachedVolPanStates']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_ScrubAmt(p0):
  a=_ft['CSurf_ScrubAmt']
  f=CFUNCTYPE(None,c_double)(a)
  t=(c_double(p0),)
  f(t[0])

def RPR_CSurf_SetAutoMode(p0,p1):
  a=_ft['CSurf_SetAutoMode']
  f=CFUNCTYPE(None,c_int,c_uint64)(a)
  t=(c_int(p0),rpr_packp('IReaperControlSurface*',p1))
  f(t[0],t[1])

def RPR_CSurf_SetPlayState(p0,p1,p2,p3):
  a=_ft['CSurf_SetPlayState']
  f=CFUNCTYPE(None,c_byte,c_byte,c_byte,c_uint64)(a)
  t=(c_byte(p0),c_byte(p1),c_byte(p2),rpr_packp('IReaperControlSurface*',p3))
  f(t[0],t[1],t[2],t[3])

def RPR_CSurf_SetRepeatState(p0,p1):
  a=_ft['CSurf_SetRepeatState']
  f=CFUNCTYPE(None,c_byte,c_uint64)(a)
  t=(c_byte(p0),rpr_packp('IReaperControlSurface*',p1))
  f(t[0],t[1])

def RPR_CSurf_SetSurfaceMute(p0,p1,p2):
  a=_ft['CSurf_SetSurfaceMute']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetSurfacePan(p0,p1,p2):
  a=_ft['CSurf_SetSurfacePan']
  f=CFUNCTYPE(None,c_uint64,c_double,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetSurfaceRecArm(p0,p1,p2):
  a=_ft['CSurf_SetSurfaceRecArm']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetSurfaceSelected(p0,p1,p2):
  a=_ft['CSurf_SetSurfaceSelected']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetSurfaceSolo(p0,p1,p2):
  a=_ft['CSurf_SetSurfaceSolo']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetSurfaceVolume(p0,p1,p2):
  a=_ft['CSurf_SetSurfaceVolume']
  f=CFUNCTYPE(None,c_uint64,c_double,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),rpr_packp('IReaperControlSurface*',p2))
  f(t[0],t[1],t[2])

def RPR_CSurf_SetTrackListChange():
  a=_ft['CSurf_SetTrackListChange']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_CSurf_TrackFromID(p0,p1):
  a=_ft['CSurf_TrackFromID']
  f=CFUNCTYPE(c_uint64,c_int,c_byte)(a)
  t=(c_int(p0),c_byte(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaTrack*',r)

def RPR_CSurf_TrackToID(p0,p1):
  a=_ft['CSurf_TrackToID']
  f=CFUNCTYPE(c_int,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_DB2SLIDER(p0):
  a=_ft['DB2SLIDER']
  f=CFUNCTYPE(c_double,c_double)(a)
  t=(c_double(p0),)
  r=f(t[0])
  return r

def RPR_DeleteEnvelopePointEx(p0,p1,p2):
  a=_ft['DeleteEnvelopePointEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_DeleteEnvelopePointRange(p0,p1,p2):
  a=_ft['DeleteEnvelopePointRange']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_double)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_double(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_DeleteEnvelopePointRangeEx(p0,p1,p2,p3):
  a=_ft['DeleteEnvelopePointRangeEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double,c_double)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_DeleteExtState(p0,p1,p2):
  a=_ft['DeleteExtState']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_DeleteProjectMarker(p0,p1,p2):
  a=_ft['DeleteProjectMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_DeleteProjectMarkerByIndex(p0,p1):
  a=_ft['DeleteProjectMarkerByIndex']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_DeleteTakeMarker(p0,p1):
  a=_ft['DeleteTakeMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_DeleteTakeStretchMarkers(p0,p1,p2):
  a=_ft['DeleteTakeStretchMarkers']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_DeleteTempoTimeSigMarker(p0,p1):
  a=_ft['DeleteTempoTimeSigMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_DeleteTrack(p0):
  a=_ft['DeleteTrack']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  f(t[0])

def RPR_DeleteTrackMediaItem(p0,p1):
  a=_ft['DeleteTrackMediaItem']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packp('MediaItem*',p1))
  r=f(t[0],t[1])
  return r

def RPR_DestroyAudioAccessor(p0):
  a=_ft['DestroyAudioAccessor']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  f(t[0])

def RPR_Dock_UpdateDockID(p0,p1):
  a=_ft['Dock_UpdateDockID']
  f=CFUNCTYPE(None,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  f(t[0],t[1])

def RPR_DockGetPosition(p0):
  a=_ft['DockGetPosition']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_DockIsChildOfDock(p0,p1):
  a=_ft['DockIsChildOfDock']
  f=CFUNCTYPE(c_int,c_uint64,c_void_p)(a)
  t=(rpr_packp('HWND',p0),c_byte(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_DockWindowActivate(p0):
  a=_ft['DockWindowActivate']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('HWND',p0),)
  f(t[0])

def RPR_DockWindowAdd(p0,p1,p2,p3):
  a=_ft['DockWindowAdd']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('HWND',p0),rpr_packsc(p1),c_int(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_DockWindowAddEx(p0,p1,p2,p3):
  a=_ft['DockWindowAddEx']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('HWND',p0),rpr_packsc(p1),rpr_packsc(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_DockWindowRefresh():
  a=_ft['DockWindowRefresh']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_DockWindowRefreshForHWND(p0):
  a=_ft['DockWindowRefreshForHWND']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('HWND',p0),)
  f(t[0])

def RPR_DockWindowRemove(p0):
  a=_ft['DockWindowRemove']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('HWND',p0),)
  f(t[0])

def RPR_EditTempoTimeSigMarker(p0,p1):
  a=_ft['EditTempoTimeSigMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_EnsureNotCompletelyOffscreen(p0):
  a=_ft['EnsureNotCompletelyOffscreen']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('RECT*',p0),)
  f(t[0])

def RPR_EnumerateFiles(p0,p1):
  a=_ft['EnumerateFiles']
  f=CFUNCTYPE(c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_EnumerateSubdirectories(p0,p1):
  a=_ft['EnumerateSubdirectories']
  f=CFUNCTYPE(c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_EnumPitchShiftModes(p0,p1):
  a=_ft['EnumPitchShiftModes']
  f=CFUNCTYPE(c_byte,c_int,c_uint64)(a)
  t=(c_int(p0),rpr_packp('char**',p1))
  r=f(t[0],t[1])
  return r

def RPR_EnumPitchShiftSubModes(p0,p1):
  a=_ft['EnumPitchShiftSubModes']
  f=CFUNCTYPE(c_char_p,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_EnumProjectMarkers(p0,p1,p2,p3,p4,p5):
  a=_ft['EnumProjectMarkers']
  f=CFUNCTYPE(c_int,c_int,c_void_p,c_void_p,c_void_p,c_uint64,c_void_p)(a)
  t=(c_int(p0),c_byte(p1),c_double(p2),c_double(p3),rpr_packp('char**',p4),c_int(p5))
  r=f(t[0],byref(t[1]),byref(t[2]),byref(t[3]),t[4],byref(t[5]))
  return (r,p0,int(t[1].value),float(t[2].value),float(t[3].value),p4,int(t[5].value))

def RPR_EnumProjectMarkers2(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['EnumProjectMarkers2']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_uint64,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),rpr_packp('char**',p5),c_int(p6))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),t[5],byref(t[6]))
  return (r,p0,p1,int(t[2].value),float(t[3].value),float(t[4].value),p5,int(t[6].value))

def RPR_EnumProjectMarkers3(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['EnumProjectMarkers3']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),rpr_packp('char**',p5),c_int(p6),c_int(p7))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),t[5],byref(t[6]),byref(t[7]))
  return (r,p0,p1,int(t[2].value),float(t[3].value),float(t[4].value),p5,int(t[6].value),int(t[7].value))

def RPR_EnumProjects(p0,p1,p2):
  a=_ft['EnumProjects']
  f=CFUNCTYPE(c_uint64,c_int,c_char_p,c_int)(a)
  t=(c_int(p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (rpr_unpackp('ReaProject*',r),p0,rpr_unpacks(t[1]),p2)

def RPR_EnumProjExtState(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['EnumProjExtState']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_char_p,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),c_int(p2),rpr_packs(p3),c_int(p4),rpr_packs(p5),c_int(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4,rpr_unpacks(t[5]),p6)

def RPR_EnumRegionRenderMatrix(p0,p1,p2):
  a=_ft['EnumRegionRenderMatrix']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return rpr_unpackp('MediaTrack*',r)

def RPR_EnumTrackMIDIProgramNames(p0,p1,p2,p3):
  a=_ft['EnumTrackMIDIProgramNames']
  f=CFUNCTYPE(c_byte,c_int,c_int,c_char_p,c_int)(a)
  t=(c_int(p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_EnumTrackMIDIProgramNamesEx(p0,p1,p2,p3,p4):
  a=_ft['EnumTrackMIDIProgramNamesEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_Envelope_Evaluate(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['Envelope_Evaluate']
  f=CFUNCTYPE(c_int,c_uint64,c_double,c_double,c_int,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_double(p1),c_double(p2),c_int(p3),c_double(p4),c_double(p5),c_double(p6),c_double(p7))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]))
  return (r,p0,p1,p2,p3,float(t[4].value),float(t[5].value),float(t[6].value),float(t[7].value))

def RPR_Envelope_FormatValue(p0,p1,p2,p3):
  a=_ft['Envelope_FormatValue']
  f=CFUNCTYPE(None,c_uint64,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_double(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_Envelope_GetParentTake(p0,p1,p2):
  a=_ft['Envelope_GetParentTake']
  f=CFUNCTYPE(c_uint64,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_int(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (rpr_unpackp('MediaItem_Take*',r),p0,int(t[1].value),int(t[2].value))

def RPR_Envelope_GetParentTrack(p0,p1,p2):
  a=_ft['Envelope_GetParentTrack']
  f=CFUNCTYPE(c_uint64,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_int(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (rpr_unpackp('MediaTrack*',r),p0,int(t[1].value),int(t[2].value))

def RPR_Envelope_SortPoints(p0):
  a=_ft['Envelope_SortPoints']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('TrackEnvelope*',p0),)
  r=f(t[0])
  return r

def RPR_Envelope_SortPointsEx(p0,p1):
  a=_ft['Envelope_SortPointsEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_ExecProcess(p0,p1):
  a=_ft['ExecProcess']
  f=CFUNCTYPE(c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_file_exists(p0):
  a=_ft['file_exists']
  f=CFUNCTYPE(c_byte,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_FindTempoTimeSigMarker(p0,p1):
  a=_ft['FindTempoTimeSigMarker']
  f=CFUNCTYPE(c_int,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_format_timestr(p0,p1,p2):
  a=_ft['format_timestr']
  f=CFUNCTYPE(None,c_double,c_char_p,c_int)(a)
  t=(c_double(p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_format_timestr_len(p0,p1,p2,p3,p4):
  a=_ft['format_timestr_len']
  f=CFUNCTYPE(None,c_double,c_char_p,c_int,c_double,c_int)(a)
  t=(c_double(p0),rpr_packs(p1),c_int(p2),c_double(p3),c_int(p4))
  f(t[0],t[1],t[2],t[3],t[4])
  return (p0,rpr_unpacks(t[1]),p2,p3,p4)

def RPR_format_timestr_pos(p0,p1,p2,p3):
  a=_ft['format_timestr_pos']
  f=CFUNCTYPE(None,c_double,c_char_p,c_int,c_int)(a)
  t=(c_double(p0),rpr_packs(p1),c_int(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,rpr_unpacks(t[1]),p2,p3)

def RPR_genGuid(p0):
  a=_ft['genGuid']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('GUID*',p0),)
  f(t[0])

def RPR_get_config_var_string(p0,p1,p2):
  a=_ft['get_config_var_string']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_get_ini_file():
  a=_ft['get_ini_file']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetActiveTake(p0):
  a=_ft['GetActiveTake']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_GetAllProjectPlayStates(p0):
  a=_ft['GetAllProjectPlayStates']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetAppVersion():
  a=_ft['GetAppVersion']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetArmedCommand(p0,p1):
  a=_ft['GetArmedCommand']
  f=CFUNCTYPE(c_int,c_char_p,c_int)(a)
  t=(rpr_packs(p0),c_int(p1))
  r=f(t[0],t[1])
  return (r,rpr_unpacks(t[0]),p1)

def RPR_GetAudioAccessorEndTime(p0):
  a=_ft['GetAudioAccessorEndTime']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  r=f(t[0])
  return r

def RPR_GetAudioAccessorHash(p0,p1):
  a=_ft['GetAudioAccessorHash']
  f=CFUNCTYPE(None,c_uint64,c_char_p)(a)
  t=(rpr_packp('AudioAccessor*',p0),rpr_packs(p1))
  f(t[0],t[1])
  return (p0,rpr_unpacks(t[1]))

def RPR_GetAudioAccessorStartTime(p0):
  a=_ft['GetAudioAccessorStartTime']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('AudioAccessor*',p0),)
  r=f(t[0])
  return r

def RPR_GetAudioDeviceInfo(p0,p1,p2):
  a=_ft['GetAudioDeviceInfo']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetConfigWantsDock(p0):
  a=_ft['GetConfigWantsDock']
  f=CFUNCTYPE(c_int,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_GetCurrentProjectInLoadSave():
  a=_ft['GetCurrentProjectInLoadSave']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('ReaProject*',r)

def RPR_GetCursorContext():
  a=_ft['GetCursorContext']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetCursorContext2(p0):
  a=_ft['GetCursorContext2']
  f=CFUNCTYPE(c_int,c_byte)(a)
  t=(c_byte(p0),)
  r=f(t[0])
  return r

def RPR_GetCursorPosition():
  a=_ft['GetCursorPosition']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_GetCursorPositionEx(p0):
  a=_ft['GetCursorPositionEx']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetDisplayedMediaItemColor(p0):
  a=_ft['GetDisplayedMediaItemColor']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return r

def RPR_GetDisplayedMediaItemColor2(p0,p1):
  a=_ft['GetDisplayedMediaItemColor2']
  f=CFUNCTYPE(c_int,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packp('MediaItem_Take*',p1))
  r=f(t[0],t[1])
  return r

def RPR_GetEnvelopeInfo_Value(p0,p1):
  a=_ft['GetEnvelopeInfo_Value']
  f=CFUNCTYPE(c_double,c_uint64,c_char_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetEnvelopeName(p0,p1,p2):
  a=_ft['GetEnvelopeName']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetEnvelopePoint(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['GetEnvelopePoint']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2),c_double(p3),c_int(p4),c_double(p5),c_byte(p6))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,p1,float(t[2].value),float(t[3].value),int(t[4].value),float(t[5].value),int(t[6].value))

def RPR_GetEnvelopePointByTime(p0,p1):
  a=_ft['GetEnvelopePointByTime']
  f=CFUNCTYPE(c_int,c_uint64,c_double)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetEnvelopePointByTimeEx(p0,p1,p2):
  a=_ft['GetEnvelopePointByTimeEx']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_double)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_GetEnvelopePointEx(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['GetEnvelopePointEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_int(p5),c_double(p6),c_byte(p7))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),int(t[5].value),float(t[6].value),int(t[7].value))

def RPR_GetEnvelopeScalingMode(p0):
  a=_ft['GetEnvelopeScalingMode']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('TrackEnvelope*',p0),)
  r=f(t[0])
  return r

def RPR_GetEnvelopeStateChunk(p0,p1,p2,p3):
  a=_ft['GetEnvelopeStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetExePath():
  a=_ft['GetExePath']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetExtState(p0,p1):
  a=_ft['GetExtState']
  f=CFUNCTYPE(c_char_p,c_char_p,c_char_p)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_GetFocusedFX(p0,p1,p2):
  a=_ft['GetFocusedFX']
  f=CFUNCTYPE(c_int,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(byref(t[0]),byref(t[1]),byref(t[2]))
  return (r,int(t[0].value),int(t[1].value),int(t[2].value))

def RPR_GetFocusedFX2(p0,p1,p2):
  a=_ft['GetFocusedFX2']
  f=CFUNCTYPE(c_int,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(byref(t[0]),byref(t[1]),byref(t[2]))
  return (r,int(t[0].value),int(t[1].value),int(t[2].value))

def RPR_GetFreeDiskSpaceForRecordPath(p0,p1):
  a=_ft['GetFreeDiskSpaceForRecordPath']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetFXEnvelope(p0,p1,p2,p3):
  a=_ft['GetFXEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetGlobalAutomationOverride():
  a=_ft['GetGlobalAutomationOverride']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetHZoomLevel():
  a=_ft['GetHZoomLevel']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_GetInputChannelName(p0):
  a=_ft['GetInputChannelName']
  f=CFUNCTYPE(c_char_p,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_GetInputOutputLatency(p0,p1):
  a=_ft['GetInputOutputLatency']
  f=CFUNCTYPE(None,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1))
  f(byref(t[0]),byref(t[1]))
  return (int(t[0].value),int(t[1].value))

def RPR_GetItemEditingTime2(p0,p1):
  a=_ft['GetItemEditingTime2']
  f=CFUNCTYPE(c_double,c_uint64,c_void_p)(a)
  t=(rpr_packp('PCM_source**',p0),c_int(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_GetItemFromPoint(p0,p1,p2,p3):
  a=_ft['GetItemFromPoint']
  f=CFUNCTYPE(c_uint64,c_int,c_int,c_byte,c_uint64)(a)
  t=(c_int(p0),c_int(p1),c_byte(p2),rpr_packp('MediaItem_Take**',p3))
  r=f(t[0],t[1],t[2],t[3])
  return rpr_unpackp('MediaItem*',r)

def RPR_GetItemProjectContext(p0):
  a=_ft['GetItemProjectContext']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return rpr_unpackp('ReaProject*',r)

def RPR_GetItemStateChunk(p0,p1,p2,p3):
  a=_ft['GetItemStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetLastColorThemeFile():
  a=_ft['GetLastColorThemeFile']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetLastMarkerAndCurRegion(p0,p1,p2,p3):
  a=_ft['GetLastMarkerAndCurRegion']
  f=CFUNCTYPE(None,c_uint64,c_double,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_int(p2),c_int(p3))
  f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (p0,p1,int(t[2].value),int(t[3].value))

def RPR_GetLastTouchedFX(p0,p1,p2):
  a=_ft['GetLastTouchedFX']
  f=CFUNCTYPE(c_byte,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(byref(t[0]),byref(t[1]),byref(t[2]))
  return (r,int(t[0].value),int(t[1].value),int(t[2].value))

def RPR_GetLastTouchedTrack():
  a=_ft['GetLastTouchedTrack']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMainHwnd():
  a=_ft['GetMainHwnd']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('HWND',r)

def RPR_GetMasterMuteSoloFlags():
  a=_ft['GetMasterMuteSoloFlags']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetMasterTrack(p0):
  a=_ft['GetMasterTrack']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMasterTrackVisibility():
  a=_ft['GetMasterTrackVisibility']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetMaxMidiInputs():
  a=_ft['GetMaxMidiInputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetMaxMidiOutputs():
  a=_ft['GetMaxMidiOutputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetMediaFileMetadata(p0,p1,p2,p3):
  a=_ft['GetMediaFileMetadata']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packp('PCM_source*',p0),rpr_packsc(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetMediaItem(p0,p1):
  a=_ft['GetMediaItem']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem*',r)

def RPR_GetMediaItem_Track(p0):
  a=_ft['GetMediaItem_Track']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMediaItemInfo_Value(p0,p1):
  a=_ft['GetMediaItemInfo_Value']
  f=CFUNCTYPE(c_double,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetMediaItemNumTakes(p0):
  a=_ft['GetMediaItemNumTakes']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return r

def RPR_GetMediaItemTake(p0,p1):
  a=_ft['GetMediaItemTake']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_GetMediaItemTake_Item(p0):
  a=_ft['GetMediaItemTake_Item']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaItem*',r)

def RPR_GetMediaItemTake_Peaks(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['GetMediaItemTake_Peaks']
  f=CFUNCTYPE(c_int,c_uint64,c_double,c_double,c_int,c_int,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1),c_double(p2),c_int(p3),c_int(p4),c_int(p5),c_double(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],byref(t[6]))
  return (r,p0,p1,p2,p3,p4,p5,float(t[6].value))

def RPR_GetMediaItemTake_Source(p0):
  a=_ft['GetMediaItemTake_Source']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return rpr_unpackp('PCM_source*',r)

def RPR_GetMediaItemTake_Track(p0):
  a=_ft['GetMediaItemTake_Track']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMediaItemTakeByGUID(p0,p1):
  a=_ft['GetMediaItemTakeByGUID']
  f=CFUNCTYPE(c_uint64,c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('GUID*',p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_GetMediaItemTakeInfo_Value(p0,p1):
  a=_ft['GetMediaItemTakeInfo_Value']
  f=CFUNCTYPE(c_double,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetMediaItemTrack(p0):
  a=_ft['GetMediaItemTrack']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMediaSourceFileName(p0,p1,p2):
  a=_ft['GetMediaSourceFileName']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('PCM_source*',p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_GetMediaSourceLength(p0,p1):
  a=_ft['GetMediaSourceLength']
  f=CFUNCTYPE(c_double,c_uint64,c_void_p)(a)
  t=(rpr_packp('PCM_source*',p0),c_byte(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_GetMediaSourceNumChannels(p0):
  a=_ft['GetMediaSourceNumChannels']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('PCM_source*',p0),)
  r=f(t[0])
  return r

def RPR_GetMediaSourceParent(p0):
  a=_ft['GetMediaSourceParent']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('PCM_source*',p0),)
  r=f(t[0])
  return rpr_unpackp('PCM_source*',r)

def RPR_GetMediaSourceSampleRate(p0):
  a=_ft['GetMediaSourceSampleRate']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('PCM_source*',p0),)
  r=f(t[0])
  return r

def RPR_GetMediaSourceType(p0,p1,p2):
  a=_ft['GetMediaSourceType']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('PCM_source*',p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_GetMediaTrackInfo_Value(p0,p1):
  a=_ft['GetMediaTrackInfo_Value']
  f=CFUNCTYPE(c_double,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetMIDIInputName(p0,p1,p2):
  a=_ft['GetMIDIInputName']
  f=CFUNCTYPE(c_byte,c_int,c_char_p,c_int)(a)
  t=(c_int(p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetMIDIOutputName(p0,p1,p2):
  a=_ft['GetMIDIOutputName']
  f=CFUNCTYPE(c_byte,c_int,c_char_p,c_int)(a)
  t=(c_int(p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetMixerScroll():
  a=_ft['GetMixerScroll']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetMouseModifier(p0,p1,p2,p3):
  a=_ft['GetMouseModifier']
  f=CFUNCTYPE(None,c_char_p,c_int,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetMousePosition(p0,p1):
  a=_ft['GetMousePosition']
  f=CFUNCTYPE(None,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1))
  f(byref(t[0]),byref(t[1]))
  return (int(t[0].value),int(t[1].value))

def RPR_GetNumAudioInputs():
  a=_ft['GetNumAudioInputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetNumAudioOutputs():
  a=_ft['GetNumAudioOutputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetNumMIDIInputs():
  a=_ft['GetNumMIDIInputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetNumMIDIOutputs():
  a=_ft['GetNumMIDIOutputs']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetNumTakeMarkers(p0):
  a=_ft['GetNumTakeMarkers']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_GetNumTracks():
  a=_ft['GetNumTracks']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetOS():
  a=_ft['GetOS']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetOutputChannelName(p0):
  a=_ft['GetOutputChannelName']
  f=CFUNCTYPE(c_char_p,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_GetOutputLatency():
  a=_ft['GetOutputLatency']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_GetParentTrack(p0):
  a=_ft['GetParentTrack']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetPeakFileName(p0,p1,p2):
  a=_ft['GetPeakFileName']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_GetPeakFileNameEx(p0,p1,p2,p3):
  a=_ft['GetPeakFileNameEx']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int,c_byte)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetPeakFileNameEx2(p0,p1,p2,p3,p4):
  a=_ft['GetPeakFileNameEx2']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int,c_byte,c_char_p)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2),c_byte(p3),rpr_packsc(p4))
  f(t[0],t[1],t[2],t[3],t[4])
  return (p0,rpr_unpacks(t[1]),p2,p3,p4)

def RPR_GetPlayPosition():
  a=_ft['GetPlayPosition']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_GetPlayPosition2():
  a=_ft['GetPlayPosition2']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_GetPlayPosition2Ex(p0):
  a=_ft['GetPlayPosition2Ex']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetPlayPositionEx(p0):
  a=_ft['GetPlayPositionEx']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetPlayState():
  a=_ft['GetPlayState']
  f=CFUNCTYPE(c_int)(a)
  r=f()
  return r

def RPR_GetPlayStateEx(p0):
  a=_ft['GetPlayStateEx']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetProjectLength(p0):
  a=_ft['GetProjectLength']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetProjectName(p0,p1,p2):
  a=_ft['GetProjectName']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_GetProjectPath(p0,p1):
  a=_ft['GetProjectPath']
  f=CFUNCTYPE(None,c_char_p,c_int)(a)
  t=(rpr_packs(p0),c_int(p1))
  f(t[0],t[1])
  return (rpr_unpacks(t[0]),p1)

def RPR_GetProjectPathEx(p0,p1,p2):
  a=_ft['GetProjectPathEx']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_GetProjectStateChangeCount(p0):
  a=_ft['GetProjectStateChangeCount']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_GetProjectTimeOffset(p0,p1):
  a=_ft['GetProjectTimeOffset']
  f=CFUNCTYPE(c_double,c_uint64,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetProjectTimeSignature(p0,p1):
  a=_ft['GetProjectTimeSignature']
  f=CFUNCTYPE(None,c_void_p,c_void_p)(a)
  t=(c_double(p0),c_double(p1))
  f(byref(t[0]),byref(t[1]))
  return (float(t[0].value),float(t[1].value))

def RPR_GetProjectTimeSignature2(p0,p1,p2):
  a=_ft['GetProjectTimeSignature2']
  f=CFUNCTYPE(None,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_double(p2))
  f(t[0],byref(t[1]),byref(t[2]))
  return (p0,float(t[1].value),float(t[2].value))

def RPR_GetProjExtState(p0,p1,p2,p3,p4):
  a=_ft['GetProjExtState']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),rpr_packsc(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_GetResourcePath():
  a=_ft['GetResourcePath']
  f=CFUNCTYPE(c_char_p)(a)
  r=f()
  return str(r.decode())

def RPR_GetSelectedEnvelope(p0):
  a=_ft['GetSelectedEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetSelectedMediaItem(p0,p1):
  a=_ft['GetSelectedMediaItem']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem*',r)

def RPR_GetSelectedTrack(p0,p1):
  a=_ft['GetSelectedTrack']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetSelectedTrack2(p0,p1,p2):
  a=_ft['GetSelectedTrack2']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetSelectedTrackEnvelope(p0):
  a=_ft['GetSelectedTrackEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetSet_ArrangeView2(p0,p1,p2,p3,p4,p5):
  a=_ft['GetSet_ArrangeView2']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_int,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),c_int(p2),c_int(p3),c_double(p4),c_double(p5))
  f(t[0],t[1],t[2],t[3],byref(t[4]),byref(t[5]))
  return (p0,p1,p2,p3,float(t[4].value),float(t[5].value))

def RPR_GetSet_LoopTimeRange(p0,p1,p2,p3,p4):
  a=_ft['GetSet_LoopTimeRange']
  f=CFUNCTYPE(None,c_byte,c_byte,c_void_p,c_void_p,c_byte)(a)
  t=(c_byte(p0),c_byte(p1),c_double(p2),c_double(p3),c_byte(p4))
  f(t[0],t[1],byref(t[2]),byref(t[3]),t[4])
  return (p0,p1,float(t[2].value),float(t[3].value),p4)

def RPR_GetSet_LoopTimeRange2(p0,p1,p2,p3,p4,p5):
  a=_ft['GetSet_LoopTimeRange2']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_byte,c_void_p,c_void_p,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),c_byte(p2),c_double(p3),c_double(p4),c_byte(p5))
  f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),t[5])
  return (p0,p1,p2,float(t[3].value),float(t[4].value),p5)

def RPR_GetSetAutomationItemInfo(p0,p1,p2,p3,p4):
  a=_ft['GetSetAutomationItemInfo']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_char_p,c_double,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),rpr_packsc(p2),c_double(p3),c_byte(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_GetSetAutomationItemInfo_String(p0,p1,p2,p3,p4):
  a=_ft['GetSetAutomationItemInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),rpr_packsc(p2),rpr_packs(p3),c_byte(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_GetSetEnvelopeInfo_String(p0,p1,p2,p3):
  a=_ft['GetSetEnvelopeInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packsc(p1),rpr_packs(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetEnvelopeState(p0,p1,p2):
  a=_ft['GetSetEnvelopeState']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetSetEnvelopeState2(p0,p1,p2,p3):
  a=_ft['GetSetEnvelopeState2']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetSetItemState(p0,p1,p2):
  a=_ft['GetSetItemState']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetSetItemState2(p0,p1,p2,p3):
  a=_ft['GetSetItemState2']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetSetMediaItemInfo_String(p0,p1,p2,p3):
  a=_ft['GetSetMediaItemInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packsc(p1),rpr_packs(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetMediaItemTakeInfo_String(p0,p1,p2,p3):
  a=_ft['GetSetMediaItemTakeInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1),rpr_packs(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetMediaTrackInfo_String(p0,p1,p2,p3):
  a=_ft['GetSetMediaTrackInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),rpr_packs(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetProjectAuthor(p0,p1,p2,p3):
  a=_ft['GetSetProjectAuthor']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetProjectGrid(p0,p1,p2,p3,p4):
  a=_ft['GetSetProjectGrid']
  f=CFUNCTYPE(c_int,c_uint64,c_byte,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),c_double(p2),c_int(p3),c_double(p4))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]))
  return (r,p0,p1,float(t[2].value),int(t[3].value),float(t[4].value))

def RPR_GetSetProjectInfo(p0,p1,p2,p3):
  a=_ft['GetSetProjectInfo']
  f=CFUNCTYPE(c_double,c_uint64,c_char_p,c_double,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),c_double(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_GetSetProjectInfo_String(p0,p1,p2,p3):
  a=_ft['GetSetProjectInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),rpr_packs(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetProjectNotes(p0,p1,p2,p3):
  a=_ft['GetSetProjectNotes']
  f=CFUNCTYPE(None,c_uint64,c_byte,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetSetRepeat(p0):
  a=_ft['GetSetRepeat']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_GetSetRepeatEx(p0,p1):
  a=_ft['GetSetRepeatEx']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetSetTrackGroupMembership(p0,p1,p2,p3):
  a=_ft['GetSetTrackGroupMembership']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_GetSetTrackGroupMembershipHigh(p0,p1,p2,p3):
  a=_ft['GetSetTrackGroupMembershipHigh']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_GetSetTrackSendInfo_String(p0,p1,p2,p3,p4,p5):
  a=_ft['GetSetTrackSendInfo_String']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packsc(p3),rpr_packs(p4),c_byte(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return (r,p0,p1,p2,p3,rpr_unpacks(t[4]),p5)

def RPR_GetSetTrackState(p0,p1,p2):
  a=_ft['GetSetTrackState']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetSetTrackState2(p0,p1,p2,p3):
  a=_ft['GetSetTrackState2']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetSubProjectFromSource(p0):
  a=_ft['GetSubProjectFromSource']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('PCM_source*',p0),)
  r=f(t[0])
  return rpr_unpackp('ReaProject*',r)

def RPR_GetTake(p0,p1):
  a=_ft['GetTake']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_GetTakeEnvelope(p0,p1):
  a=_ft['GetTakeEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetTakeEnvelopeByName(p0,p1):
  a=_ft['GetTakeEnvelopeByName']
  f=CFUNCTYPE(c_uint64,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetTakeMarker(p0,p1,p2,p3,p4):
  a=_ft['GetTakeMarker']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_char_p,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packs(p2),c_int(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]))
  return (r,p0,p1,rpr_unpacks(t[2]),p3,int(t[4].value))

def RPR_GetTakeName(p0):
  a=_ft['GetTakeName']
  f=CFUNCTYPE(c_char_p,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_GetTakeNumStretchMarkers(p0):
  a=_ft['GetTakeNumStretchMarkers']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_GetTakeStretchMarker(p0,p1,p2,p3):
  a=_ft['GetTakeStretchMarker']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,float(t[2].value),float(t[3].value))

def RPR_GetTakeStretchMarkerSlope(p0,p1):
  a=_ft['GetTakeStretchMarkerSlope']
  f=CFUNCTYPE(c_double,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetTCPFXParm(p0,p1,p2,p3,p4):
  a=_ft['GetTCPFXParm']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1),c_int(p2),c_int(p3),c_int(p4))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]))
  return (r,p0,p1,p2,int(t[3].value),int(t[4].value))

def RPR_GetTempoMatchPlayRate(p0,p1,p2,p3,p4,p5):
  a=_ft['GetTempoMatchPlayRate']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_double,c_double,c_void_p,c_void_p)(a)
  t=(rpr_packp('PCM_source*',p0),c_double(p1),c_double(p2),c_double(p3),c_double(p4),c_double(p5))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]),byref(t[5]))
  return (r,p0,p1,p2,p3,float(t[4].value),float(t[5].value))

def RPR_GetTempoTimeSigMarker(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['GetTempoTimeSigMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_double(p2),c_int(p3),c_double(p4),c_double(p5),c_int(p6),c_int(p7),c_byte(p8))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]))
  return (r,p0,p1,float(t[2].value),int(t[3].value),float(t[4].value),float(t[5].value),int(t[6].value),int(t[7].value),int(t[8].value))

def RPR_GetThemeColor(p0,p1):
  a=_ft['GetThemeColor']
  f=CFUNCTYPE(c_int,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetThingFromPoint(p0,p1,p2,p3):
  a=_ft['GetThingFromPoint']
  f=CFUNCTYPE(c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(c_int(p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (rpr_unpackp('MediaTrack*',r),p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetToggleCommandState(p0):
  a=_ft['GetToggleCommandState']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_GetToggleCommandStateEx(p0,p1):
  a=_ft['GetToggleCommandStateEx']
  f=CFUNCTYPE(c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetTooltipWindow():
  a=_ft['GetTooltipWindow']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('HWND',r)

def RPR_GetTrack(p0,p1):
  a=_ft['GetTrack']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaTrack*',r)

def RPR_GetTrackAutomationMode(p0):
  a=_ft['GetTrackAutomationMode']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_GetTrackColor(p0):
  a=_ft['GetTrackColor']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_GetTrackDepth(p0):
  a=_ft['GetTrackDepth']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_GetTrackEnvelope(p0,p1):
  a=_ft['GetTrackEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetTrackEnvelopeByChunkName(p0,p1):
  a=_ft['GetTrackEnvelopeByChunkName']
  f=CFUNCTYPE(c_uint64,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetTrackEnvelopeByName(p0,p1):
  a=_ft['GetTrackEnvelopeByName']
  f=CFUNCTYPE(c_uint64,c_uint64,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_GetTrackFromPoint(p0,p1,p2):
  a=_ft['GetTrackFromPoint']
  f=CFUNCTYPE(c_uint64,c_int,c_int,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (rpr_unpackp('MediaTrack*',r),p0,p1,int(t[2].value))

def RPR_GetTrackGUID(p0):
  a=_ft['GetTrackGUID']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return rpr_unpackp('GUID*',r)

def RPR_GetTrackMediaItem(p0,p1):
  a=_ft['GetTrackMediaItem']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem*',r)

def RPR_GetTrackMIDILyrics(p0,p1,p2,p3):
  a=_ft['GetTrackMIDILyrics']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],byref(t[3]))
  return (r,p0,p1,rpr_unpacks(t[2]),int(t[3].value))

def RPR_GetTrackMIDINoteName(p0,p1,p2):
  a=_ft['GetTrackMIDINoteName']
  f=CFUNCTYPE(c_char_p,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return str(r.decode())

def RPR_GetTrackMIDINoteNameEx(p0,p1,p2,p3):
  a=_ft['GetTrackMIDINoteNameEx']
  f=CFUNCTYPE(c_char_p,c_uint64,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return str(r.decode())

def RPR_GetTrackMIDINoteRange(p0,p1,p2,p3):
  a=_ft['GetTrackMIDINoteRange']
  f=CFUNCTYPE(None,c_uint64,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1),c_int(p2),c_int(p3))
  f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (p0,p1,int(t[2].value),int(t[3].value))

def RPR_GetTrackName(p0,p1,p2):
  a=_ft['GetTrackName']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return (r,p0,rpr_unpacks(t[1]),p2)

def RPR_GetTrackNumMediaItems(p0):
  a=_ft['GetTrackNumMediaItems']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_GetTrackNumSends(p0,p1):
  a=_ft['GetTrackNumSends']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_GetTrackReceiveName(p0,p1,p2,p3):
  a=_ft['GetTrackReceiveName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetTrackReceiveUIMute(p0,p1,p2):
  a=_ft['GetTrackReceiveUIMute']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_GetTrackReceiveUIVolPan(p0,p1,p2,p3):
  a=_ft['GetTrackReceiveUIVolPan']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,float(t[2].value),float(t[3].value))

def RPR_GetTrackSendInfo_Value(p0,p1,p2,p3):
  a=_ft['GetTrackSendInfo_Value']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packsc(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_GetTrackSendName(p0,p1,p2,p3):
  a=_ft['GetTrackSendName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_GetTrackSendUIMute(p0,p1,p2):
  a=_ft['GetTrackSendUIMute']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_GetTrackSendUIVolPan(p0,p1,p2,p3):
  a=_ft['GetTrackSendUIVolPan']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,float(t[2].value),float(t[3].value))

def RPR_GetTrackState(p0,p1):
  a=_ft['GetTrackState']
  f=CFUNCTYPE(c_char_p,c_uint64,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],byref(t[1]))
  return (str(r.decode()),p0,int(t[1].value))

def RPR_GetTrackStateChunk(p0,p1,p2,p3):
  a=_ft['GetTrackStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packs(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,rpr_unpacks(t[1]),p2,p3)

def RPR_GetTrackUIMute(p0,p1):
  a=_ft['GetTrackUIMute']
  f=CFUNCTYPE(c_byte,c_uint64,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_GetTrackUIPan(p0,p1,p2,p3):
  a=_ft['GetTrackUIPan']
  f=CFUNCTYPE(c_byte,c_uint64,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_double(p2),c_int(p3))
  r=f(t[0],byref(t[1]),byref(t[2]),byref(t[3]))
  return (r,p0,float(t[1].value),float(t[2].value),int(t[3].value))

def RPR_GetTrackUIVolPan(p0,p1,p2):
  a=_ft['GetTrackUIVolPan']
  f=CFUNCTYPE(c_byte,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_double(p1),c_double(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (r,p0,float(t[1].value),float(t[2].value))

def RPR_GetUnderrunTime(p0,p1,p2):
  a=_ft['GetUnderrunTime']
  f=CFUNCTYPE(None,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  f(byref(t[0]),byref(t[1]),byref(t[2]))
  return (int(t[0].value),int(t[1].value),int(t[2].value))

def RPR_GetUserFileNameForRead(p0,p1,p2):
  a=_ft['GetUserFileNameForRead']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p,c_char_p)(a)
  t=(rpr_packs(p0),rpr_packsc(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return (r,rpr_unpacks(t[0]),p1,p2)

def RPR_GetUserInputs(p0,p1,p2,p3,p4):
  a=_ft['GetUserInputs']
  f=CFUNCTYPE(c_byte,c_char_p,c_int,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),rpr_packsc(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_GoToMarker(p0,p1,p2):
  a=_ft['GoToMarker']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_GoToRegion(p0,p1,p2):
  a=_ft['GoToRegion']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_GR_SelectColor(p0,p1):
  a=_ft['GR_SelectColor']
  f=CFUNCTYPE(c_int,c_uint64,c_void_p)(a)
  t=(rpr_packp('HWND',p0),c_int(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_GSC_mainwnd(p0):
  a=_ft['GSC_mainwnd']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_guidToString(p0,p1):
  a=_ft['guidToString']
  f=CFUNCTYPE(None,c_uint64,c_char_p)(a)
  t=(rpr_packp('GUID*',p0),rpr_packs(p1))
  f(t[0],t[1])
  return (p0,rpr_unpacks(t[1]))

def RPR_HasExtState(p0,p1):
  a=_ft['HasExtState']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_HasTrackMIDIPrograms(p0):
  a=_ft['HasTrackMIDIPrograms']
  f=CFUNCTYPE(c_char_p,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_HasTrackMIDIProgramsEx(p0,p1):
  a=_ft['HasTrackMIDIProgramsEx']
  f=CFUNCTYPE(c_char_p,c_uint64,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_Help_Set(p0,p1):
  a=_ft['Help_Set']
  f=CFUNCTYPE(None,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),c_byte(p1))
  f(t[0],t[1])

def RPR_image_resolve_fn(p0,p1,p2):
  a=_ft['image_resolve_fn']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_InsertAutomationItem(p0,p1,p2,p3):
  a=_ft['InsertAutomationItem']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_double,c_double)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_InsertEnvelopePoint(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['InsertEnvelopePoint']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_double,c_int,c_double,c_byte,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_double(p1),c_double(p2),c_int(p3),c_double(p4),c_byte(p5),c_byte(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],byref(t[6]))
  return (r,p0,p1,p2,p3,p4,p5,int(t[6].value))

def RPR_InsertEnvelopePointEx(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['InsertEnvelopePointEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double,c_double,c_int,c_double,c_byte,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2),c_double(p3),c_int(p4),c_double(p5),c_byte(p6),c_byte(p7))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],byref(t[7]))
  return (r,p0,p1,p2,p3,p4,p5,p6,int(t[7].value))

def RPR_InsertMedia(p0,p1):
  a=_ft['InsertMedia']
  f=CFUNCTYPE(c_int,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_InsertMediaSection(p0,p1,p2,p3,p4):
  a=_ft['InsertMediaSection']
  f=CFUNCTYPE(c_int,c_char_p,c_int,c_double,c_double,c_double)(a)
  t=(rpr_packsc(p0),c_int(p1),c_double(p2),c_double(p3),c_double(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_InsertTrackAtIndex(p0,p1):
  a=_ft['InsertTrackAtIndex']
  f=CFUNCTYPE(None,c_int,c_byte)(a)
  t=(c_int(p0),c_byte(p1))
  f(t[0],t[1])

def RPR_IsMediaExtension(p0,p1):
  a=_ft['IsMediaExtension']
  f=CFUNCTYPE(c_byte,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_IsMediaItemSelected(p0):
  a=_ft['IsMediaItemSelected']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  r=f(t[0])
  return r

def RPR_IsProjectDirty(p0):
  a=_ft['IsProjectDirty']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_IsTrackSelected(p0):
  a=_ft['IsTrackSelected']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_IsTrackVisible(p0,p1):
  a=_ft['IsTrackVisible']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_joystick_create(p0):
  a=_ft['joystick_create']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('GUID*',p0),)
  r=f(t[0])
  return rpr_unpackp('joystick_device*',r)

def RPR_joystick_destroy(p0):
  a=_ft['joystick_destroy']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('joystick_device*',p0),)
  f(t[0])

def RPR_joystick_enum(p0,p1):
  a=_ft['joystick_enum']
  f=CFUNCTYPE(c_char_p,c_int,c_uint64)(a)
  t=(c_int(p0),rpr_packp('char**',p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_joystick_getaxis(p0,p1):
  a=_ft['joystick_getaxis']
  f=CFUNCTYPE(c_double,c_uint64,c_int)(a)
  t=(rpr_packp('joystick_device*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_joystick_getbuttonmask(p0):
  a=_ft['joystick_getbuttonmask']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('joystick_device*',p0),)
  r=f(t[0])
  return r

def RPR_joystick_getinfo(p0,p1,p2):
  a=_ft['joystick_getinfo']
  f=CFUNCTYPE(c_int,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('joystick_device*',p0),c_int(p1),c_int(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (r,p0,int(t[1].value),int(t[2].value))

def RPR_joystick_getpov(p0,p1):
  a=_ft['joystick_getpov']
  f=CFUNCTYPE(c_double,c_uint64,c_int)(a)
  t=(rpr_packp('joystick_device*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_joystick_update(p0):
  a=_ft['joystick_update']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('joystick_device*',p0),)
  r=f(t[0])
  return r

def RPR_LICE_ClipLine(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['LICE_ClipLine']
  f=CFUNCTYPE(c_byte,c_void_p,c_void_p,c_void_p,c_void_p,c_int,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4),c_int(p5),c_int(p6),c_int(p7))
  r=f(byref(t[0]),byref(t[1]),byref(t[2]),byref(t[3]),t[4],t[5],t[6],t[7])
  return (r,int(t[0].value),int(t[1].value),int(t[2].value),int(t[3].value),p4,p5,p6,p7)

def RPR_LocalizeString(p0,p1,p2):
  a=_ft['LocalizeString']
  f=CFUNCTYPE(c_char_p,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return str(r.decode())

def RPR_Loop_OnArrow(p0,p1):
  a=_ft['Loop_OnArrow']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_Main_OnCommand(p0,p1):
  a=_ft['Main_OnCommand']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_Main_OnCommandEx(p0,p1,p2):
  a=_ft['Main_OnCommandEx']
  f=CFUNCTYPE(None,c_int,c_int,c_uint64)(a)
  t=(c_int(p0),c_int(p1),rpr_packp('ReaProject*',p2))
  f(t[0],t[1],t[2])

def RPR_Main_openProject(p0):
  a=_ft['Main_openProject']
  f=CFUNCTYPE(None,c_char_p)(a)
  t=(rpr_packsc(p0),)
  f(t[0])

def RPR_Main_SaveProject(p0,p1):
  a=_ft['Main_SaveProject']
  f=CFUNCTYPE(None,c_uint64,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1))
  f(t[0],t[1])

def RPR_Main_SaveProjectEx(p0,p1,p2):
  a=_ft['Main_SaveProjectEx']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),c_int(p2))
  f(t[0],t[1],t[2])

def RPR_Main_UpdateLoopInfo(p0):
  a=_ft['Main_UpdateLoopInfo']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_MarkProjectDirty(p0):
  a=_ft['MarkProjectDirty']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_MarkTrackItemsDirty(p0,p1):
  a=_ft['MarkTrackItemsDirty']
  f=CFUNCTYPE(None,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packp('MediaItem*',p1))
  f(t[0],t[1])

def RPR_Master_GetPlayRate(p0):
  a=_ft['Master_GetPlayRate']
  f=CFUNCTYPE(c_double,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_Master_GetPlayRateAtTime(p0,p1):
  a=_ft['Master_GetPlayRateAtTime']
  f=CFUNCTYPE(c_double,c_double,c_uint64)(a)
  t=(c_double(p0),rpr_packp('ReaProject*',p1))
  r=f(t[0],t[1])
  return r

def RPR_Master_GetTempo():
  a=_ft['Master_GetTempo']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_Master_NormalizePlayRate(p0,p1):
  a=_ft['Master_NormalizePlayRate']
  f=CFUNCTYPE(c_double,c_double,c_byte)(a)
  t=(c_double(p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_Master_NormalizeTempo(p0,p1):
  a=_ft['Master_NormalizeTempo']
  f=CFUNCTYPE(c_double,c_double,c_byte)(a)
  t=(c_double(p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_MB(p0,p1,p2):
  a=_ft['MB']
  f=CFUNCTYPE(c_int,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_MediaItemDescendsFromTrack(p0,p1):
  a=_ft['MediaItemDescendsFromTrack']
  f=CFUNCTYPE(c_int,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packp('MediaTrack*',p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_CountEvts(p0,p1,p2,p3):
  a=_ft['MIDI_CountEvts']
  f=CFUNCTYPE(c_int,c_uint64,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_int(p3))
  r=f(t[0],byref(t[1]),byref(t[2]),byref(t[3]))
  return (r,p0,int(t[1].value),int(t[2].value),int(t[3].value))

def RPR_MIDI_DeleteCC(p0,p1):
  a=_ft['MIDI_DeleteCC']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_DeleteEvt(p0,p1):
  a=_ft['MIDI_DeleteEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_DeleteNote(p0,p1):
  a=_ft['MIDI_DeleteNote']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_DeleteTextSysexEvt(p0,p1):
  a=_ft['MIDI_DeleteTextSysexEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_DisableSort(p0):
  a=_ft['MIDI_DisableSort']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  f(t[0])

def RPR_MIDI_EnumSelCC(p0,p1):
  a=_ft['MIDI_EnumSelCC']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_EnumSelEvts(p0,p1):
  a=_ft['MIDI_EnumSelEvts']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_EnumSelNotes(p0,p1):
  a=_ft['MIDI_EnumSelNotes']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_EnumSelTextSysexEvts(p0,p1):
  a=_ft['MIDI_EnumSelTextSysexEvts']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetAllEvts(p0,p1,p2):
  a=_ft['MIDI_GetAllEvts']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packs(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,rpr_unpacks(t[1]),int(t[2].value))

def RPR_MIDI_GetCC(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['MIDI_GetCC']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_int(p5),c_int(p6),c_int(p7),c_int(p8))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),int(t[5].value),int(t[6].value),int(t[7].value),int(t[8].value))

def RPR_MIDI_GetCCShape(p0,p1,p2,p3):
  a=_ft['MIDI_GetCCShape']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,int(t[2].value),float(t[3].value))

def RPR_MIDI_GetEvt(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['MIDI_GetEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_char_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),rpr_packs(p5),c_int(p6))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),t[5],byref(t[6]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),rpr_unpacks(t[5]),int(t[6].value))

def RPR_MIDI_GetGrid(p0,p1,p2):
  a=_ft['MIDI_GetGrid']
  f=CFUNCTYPE(c_double,c_uint64,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1),c_double(p2))
  r=f(t[0],byref(t[1]),byref(t[2]))
  return (r,p0,float(t[1].value),float(t[2].value))

def RPR_MIDI_GetHash(p0,p1,p2,p3):
  a=_ft['MIDI_GetHash']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_MIDI_GetNote(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['MIDI_GetNote']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_double(p5),c_int(p6),c_int(p7),c_int(p8))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),float(t[5].value),int(t[6].value),int(t[7].value),int(t[8].value))

def RPR_MIDI_GetPPQPos_EndOfMeasure(p0,p1):
  a=_ft['MIDI_GetPPQPos_EndOfMeasure']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetPPQPos_StartOfMeasure(p0,p1):
  a=_ft['MIDI_GetPPQPos_StartOfMeasure']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetPPQPosFromProjQN(p0,p1):
  a=_ft['MIDI_GetPPQPosFromProjQN']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetPPQPosFromProjTime(p0,p1):
  a=_ft['MIDI_GetPPQPosFromProjTime']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetProjQNFromPPQPos(p0,p1):
  a=_ft['MIDI_GetProjQNFromPPQPos']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetProjTimeFromPPQPos(p0,p1):
  a=_ft['MIDI_GetProjTimeFromPPQPos']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDI_GetRecentInputEvent(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['MIDI_GetRecentInputEvent']
  f=CFUNCTYPE(c_int,c_int,c_char_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),rpr_packs(p1),c_int(p2),c_int(p3),c_int(p4),c_double(p5),c_int(p6))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,rpr_unpacks(t[1]),int(t[2].value),int(t[3].value),int(t[4].value),float(t[5].value),int(t[6].value))

def RPR_MIDI_GetScale(p0,p1,p2,p3,p4):
  a=_ft['MIDI_GetScale']
  f=CFUNCTYPE(c_byte,c_uint64,c_void_p,c_void_p,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],byref(t[1]),byref(t[2]),t[3],t[4])
  return (r,p0,int(t[1].value),int(t[2].value),rpr_unpacks(t[3]),p4)

def RPR_MIDI_GetTextSysexEvt(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['MIDI_GetTextSysexEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_char_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_int(p5),rpr_packs(p6),c_int(p7))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),t[6],byref(t[7]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),int(t[5].value),rpr_unpacks(t[6]),int(t[7].value))

def RPR_MIDI_GetTrackHash(p0,p1,p2,p3):
  a=_ft['MIDI_GetTrackHash']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_midi_init(p0,p1):
  a=_ft['midi_init']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_MIDI_InsertCC(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['MIDI_InsertCC']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_byte,c_double,c_int,c_int,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1),c_byte(p2),c_double(p3),c_int(p4),c_int(p5),c_int(p6),c_int(p7))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7])
  return r

def RPR_MIDI_InsertEvt(p0,p1,p2,p3,p4,p5):
  a=_ft['MIDI_InsertEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_byte,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1),c_byte(p2),c_double(p3),rpr_packsc(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_MIDI_InsertNote(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['MIDI_InsertNote']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_byte,c_double,c_double,c_int,c_int,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1),c_byte(p2),c_double(p3),c_double(p4),c_int(p5),c_int(p6),c_int(p7),c_byte(p8))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7],byref(t[8]))
  return (r,p0,p1,p2,p3,p4,p5,p6,p7,int(t[8].value))

def RPR_MIDI_InsertTextSysexEvt(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['MIDI_InsertTextSysexEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_byte,c_byte,c_double,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1),c_byte(p2),c_double(p3),c_int(p4),rpr_packsc(p5),c_int(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return r

def RPR_midi_reinit():
  a=_ft['midi_reinit']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_MIDI_SelectAll(p0,p1):
  a=_ft['MIDI_SelectAll']
  f=CFUNCTYPE(None,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_byte(p1))
  f(t[0],t[1])

def RPR_MIDI_SetAllEvts(p0,p1,p2):
  a=_ft['MIDI_SetAllEvts']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_MIDI_SetCC(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9):
  a=_ft['MIDI_SetCC']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_int(p5),c_int(p6),c_int(p7),c_int(p8),c_byte(p9))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]),byref(t[9]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),int(t[5].value),int(t[6].value),int(t[7].value),int(t[8].value),int(t[9].value))

def RPR_MIDI_SetCCShape(p0,p1,p2,p3,p4):
  a=_ft['MIDI_SetCCShape']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),c_byte(p4))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]))
  return (r,p0,p1,p2,p3,int(t[4].value))

def RPR_MIDI_SetEvt(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['MIDI_SetEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_char_p,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),rpr_packsc(p5),c_int(p6),c_byte(p7))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),t[5],t[6],byref(t[7]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),p5,p6,int(t[7].value))

def RPR_MIDI_SetItemExtents(p0,p1,p2):
  a=_ft['MIDI_SetItemExtents']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_double)(a)
  t=(rpr_packp('MediaItem*',p0),c_double(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_MIDI_SetNote(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9):
  a=_ft['MIDI_SetNote']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_double(p5),c_int(p6),c_int(p7),c_int(p8),c_byte(p9))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]),byref(t[9]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),float(t[5].value),int(t[6].value),int(t[7].value),int(t[8].value),int(t[9].value))

def RPR_MIDI_SetTextSysexEvt(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['MIDI_SetTextSysexEvt']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_char_p,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2),c_byte(p3),c_double(p4),c_int(p5),rpr_packsc(p6),c_int(p7),c_byte(p8))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),t[6],t[7],byref(t[8]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),int(t[5].value),p6,p7,int(t[8].value))

def RPR_MIDI_Sort(p0):
  a=_ft['MIDI_Sort']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  f(t[0])

def RPR_MIDIEditor_EnumTakes(p0,p1,p2):
  a=_ft['MIDIEditor_EnumTakes']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('HWND',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_MIDIEditor_GetActive():
  a=_ft['MIDIEditor_GetActive']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('HWND',r)

def RPR_MIDIEditor_GetMode(p0):
  a=_ft['MIDIEditor_GetMode']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('HWND',p0),)
  r=f(t[0])
  return r

def RPR_MIDIEditor_GetSetting_int(p0,p1):
  a=_ft['MIDIEditor_GetSetting_int']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p)(a)
  t=(rpr_packp('HWND',p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDIEditor_GetSetting_str(p0,p1,p2,p3):
  a=_ft['MIDIEditor_GetSetting_str']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packp('HWND',p0),rpr_packsc(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_MIDIEditor_GetTake(p0):
  a=_ft['MIDIEditor_GetTake']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('HWND',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaItem_Take*',r)

def RPR_MIDIEditor_LastFocused_OnCommand(p0,p1):
  a=_ft['MIDIEditor_LastFocused_OnCommand']
  f=CFUNCTYPE(c_byte,c_int,c_byte)(a)
  t=(c_int(p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDIEditor_OnCommand(p0,p1):
  a=_ft['MIDIEditor_OnCommand']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('HWND',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_MIDIEditor_SetSetting_int(p0,p1,p2):
  a=_ft['MIDIEditor_SetSetting_int']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('HWND',p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_mkpanstr(p0,p1):
  a=_ft['mkpanstr']
  f=CFUNCTYPE(None,c_char_p,c_double)(a)
  t=(rpr_packs(p0),c_double(p1))
  f(t[0],t[1])
  return (rpr_unpacks(t[0]),p1)

def RPR_mkvolpanstr(p0,p1,p2):
  a=_ft['mkvolpanstr']
  f=CFUNCTYPE(None,c_char_p,c_double,c_double)(a)
  t=(rpr_packs(p0),c_double(p1),c_double(p2))
  f(t[0],t[1],t[2])
  return (rpr_unpacks(t[0]),p1,p2)

def RPR_mkvolstr(p0,p1):
  a=_ft['mkvolstr']
  f=CFUNCTYPE(None,c_char_p,c_double)(a)
  t=(rpr_packs(p0),c_double(p1))
  f(t[0],t[1])
  return (rpr_unpacks(t[0]),p1)

def RPR_MoveEditCursor(p0,p1):
  a=_ft['MoveEditCursor']
  f=CFUNCTYPE(None,c_double,c_byte)(a)
  t=(c_double(p0),c_byte(p1))
  f(t[0],t[1])

def RPR_MoveMediaItemToTrack(p0,p1):
  a=_ft['MoveMediaItemToTrack']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packp('MediaTrack*',p1))
  r=f(t[0],t[1])
  return r

def RPR_MuteAllTracks(p0):
  a=_ft['MuteAllTracks']
  f=CFUNCTYPE(None,c_byte)(a)
  t=(c_byte(p0),)
  f(t[0])

def RPR_my_getViewport(p0,p1,p2):
  a=_ft['my_getViewport']
  f=CFUNCTYPE(None,c_uint64,c_uint64,c_byte)(a)
  t=(rpr_packp('RECT*',p0),rpr_packp('RECT*',p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_NamedCommandLookup(p0):
  a=_ft['NamedCommandLookup']
  f=CFUNCTYPE(c_int,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_OnPauseButton():
  a=_ft['OnPauseButton']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_OnPauseButtonEx(p0):
  a=_ft['OnPauseButtonEx']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_OnPlayButton():
  a=_ft['OnPlayButton']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_OnPlayButtonEx(p0):
  a=_ft['OnPlayButtonEx']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_OnStopButton():
  a=_ft['OnStopButton']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_OnStopButtonEx(p0):
  a=_ft['OnStopButtonEx']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_OpenColorThemeFile(p0):
  a=_ft['OpenColorThemeFile']
  f=CFUNCTYPE(c_byte,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_OpenMediaExplorer(p0,p1):
  a=_ft['OpenMediaExplorer']
  f=CFUNCTYPE(c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),c_byte(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('HWND',r)

def RPR_OscLocalMessageToHost(p0,p1):
  a=_ft['OscLocalMessageToHost']
  f=CFUNCTYPE(None,c_char_p,c_void_p)(a)
  t=(rpr_packsc(p0),c_double(p1))
  f(t[0],byref(t[1]))
  return (p0,float(t[1].value))

def RPR_parse_timestr(p0):
  a=_ft['parse_timestr']
  f=CFUNCTYPE(c_double,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_parse_timestr_len(p0,p1,p2):
  a=_ft['parse_timestr_len']
  f=CFUNCTYPE(c_double,c_char_p,c_double,c_int)(a)
  t=(rpr_packsc(p0),c_double(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_parse_timestr_pos(p0,p1):
  a=_ft['parse_timestr_pos']
  f=CFUNCTYPE(c_double,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_parsepanstr(p0):
  a=_ft['parsepanstr']
  f=CFUNCTYPE(c_double,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return r

def RPR_PCM_Sink_Enum(p0,p1):
  a=_ft['PCM_Sink_Enum']
  f=CFUNCTYPE(c_int,c_int,c_uint64)(a)
  t=(c_int(p0),rpr_packp('char**',p1))
  r=f(t[0],t[1])
  return r

def RPR_PCM_Sink_GetExtension(p0,p1):
  a=_ft['PCM_Sink_GetExtension']
  f=CFUNCTYPE(c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return str(r.decode())

def RPR_PCM_Sink_ShowConfig(p0,p1,p2):
  a=_ft['PCM_Sink_ShowConfig']
  f=CFUNCTYPE(c_uint64,c_char_p,c_int,c_uint64)(a)
  t=(rpr_packsc(p0),c_int(p1),rpr_packp('HWND',p2))
  r=f(t[0],t[1],t[2])
  return rpr_unpackp('HWND',r)

def RPR_PCM_Source_BuildPeaks(p0,p1):
  a=_ft['PCM_Source_BuildPeaks']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('PCM_source*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_PCM_Source_CreateFromFile(p0):
  a=_ft['PCM_Source_CreateFromFile']
  f=CFUNCTYPE(c_uint64,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return rpr_unpackp('PCM_source*',r)

def RPR_PCM_Source_CreateFromFileEx(p0,p1):
  a=_ft['PCM_Source_CreateFromFileEx']
  f=CFUNCTYPE(c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),c_byte(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('PCM_source*',r)

def RPR_PCM_Source_CreateFromType(p0):
  a=_ft['PCM_Source_CreateFromType']
  f=CFUNCTYPE(c_uint64,c_char_p)(a)
  t=(rpr_packsc(p0),)
  r=f(t[0])
  return rpr_unpackp('PCM_source*',r)

def RPR_PCM_Source_Destroy(p0):
  a=_ft['PCM_Source_Destroy']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('PCM_source*',p0),)
  f(t[0])

def RPR_PCM_Source_GetPeaks(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['PCM_Source_GetPeaks']
  f=CFUNCTYPE(c_int,c_uint64,c_double,c_double,c_int,c_int,c_int,c_void_p)(a)
  t=(rpr_packp('PCM_source*',p0),c_double(p1),c_double(p2),c_int(p3),c_int(p4),c_int(p5),c_double(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],byref(t[6]))
  return (r,p0,p1,p2,p3,p4,p5,float(t[6].value))

def RPR_PCM_Source_GetSectionInfo(p0,p1,p2,p3):
  a=_ft['PCM_Source_GetSectionInfo']
  f=CFUNCTYPE(c_byte,c_uint64,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('PCM_source*',p0),c_double(p1),c_double(p2),c_byte(p3))
  r=f(t[0],byref(t[1]),byref(t[2]),byref(t[3]))
  return (r,p0,float(t[1].value),float(t[2].value),int(t[3].value))

def RPR_PluginWantsAlwaysRunFx(p0):
  a=_ft['PluginWantsAlwaysRunFx']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_PreventUIRefresh(p0):
  a=_ft['PreventUIRefresh']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_PromptForAction(p0,p1,p2):
  a=_ft['PromptForAction']
  f=CFUNCTYPE(c_int,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_ReaScriptError(p0):
  a=_ft['ReaScriptError']
  f=CFUNCTYPE(None,c_char_p)(a)
  t=(rpr_packsc(p0),)
  f(t[0])

def RPR_RecursiveCreateDirectory(p0,p1):
  a=_ft['RecursiveCreateDirectory']
  f=CFUNCTYPE(c_int,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_reduce_open_files(p0):
  a=_ft['reduce_open_files']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_RefreshToolbar(p0):
  a=_ft['RefreshToolbar']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_RefreshToolbar2(p0,p1):
  a=_ft['RefreshToolbar2']
  f=CFUNCTYPE(None,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  f(t[0],t[1])

def RPR_relative_fn(p0,p1,p2):
  a=_ft['relative_fn']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_RemoveTrackSend(p0,p1,p2):
  a=_ft['RemoveTrackSend']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_RenderFileSection(p0,p1,p2,p3,p4):
  a=_ft['RenderFileSection']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p,c_double,c_double,c_double)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),c_double(p2),c_double(p3),c_double(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_ReorderSelectedTracks(p0,p1):
  a=_ft['ReorderSelectedTracks']
  f=CFUNCTYPE(c_byte,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_Resample_EnumModes(p0):
  a=_ft['Resample_EnumModes']
  f=CFUNCTYPE(c_char_p,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_resolve_fn(p0,p1,p2):
  a=_ft['resolve_fn']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2))
  f(t[0],t[1],t[2])
  return (p0,rpr_unpacks(t[1]),p2)

def RPR_resolve_fn2(p0,p1,p2,p3):
  a=_ft['resolve_fn2']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_int,c_char_p)(a)
  t=(rpr_packsc(p0),rpr_packs(p1),c_int(p2),rpr_packsc(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,rpr_unpacks(t[1]),p2,p3)

def RPR_ReverseNamedCommandLookup(p0):
  a=_ft['ReverseNamedCommandLookup']
  f=CFUNCTYPE(c_char_p,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_ScaleFromEnvelopeMode(p0,p1):
  a=_ft['ScaleFromEnvelopeMode']
  f=CFUNCTYPE(c_double,c_int,c_double)(a)
  t=(c_int(p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_ScaleToEnvelopeMode(p0,p1):
  a=_ft['ScaleToEnvelopeMode']
  f=CFUNCTYPE(c_double,c_int,c_double)(a)
  t=(c_int(p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_SelectAllMediaItems(p0,p1):
  a=_ft['SelectAllMediaItems']
  f=CFUNCTYPE(None,c_uint64,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1))
  f(t[0],t[1])

def RPR_SelectProjectInstance(p0):
  a=_ft['SelectProjectInstance']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_SetActiveTake(p0):
  a=_ft['SetActiveTake']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  f(t[0])

def RPR_SetAutomationMode(p0,p1):
  a=_ft['SetAutomationMode']
  f=CFUNCTYPE(None,c_int,c_byte)(a)
  t=(c_int(p0),c_byte(p1))
  f(t[0],t[1])

def RPR_SetCurrentBPM(p0,p1,p2):
  a=_ft['SetCurrentBPM']
  f=CFUNCTYPE(None,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_SetCursorContext(p0,p1):
  a=_ft['SetCursorContext']
  f=CFUNCTYPE(None,c_int,c_uint64)(a)
  t=(c_int(p0),rpr_packp('TrackEnvelope*',p1))
  f(t[0],t[1])

def RPR_SetEditCurPos(p0,p1,p2):
  a=_ft['SetEditCurPos']
  f=CFUNCTYPE(None,c_double,c_byte,c_byte)(a)
  t=(c_double(p0),c_byte(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_SetEditCurPos2(p0,p1,p2,p3):
  a=_ft['SetEditCurPos2']
  f=CFUNCTYPE(None,c_uint64,c_double,c_byte,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_byte(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_SetEnvelopePoint(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['SetEnvelopePoint']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_double(p2),c_double(p3),c_int(p4),c_double(p5),c_byte(p6),c_byte(p7))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]))
  return (r,p0,p1,float(t[2].value),float(t[3].value),int(t[4].value),float(t[5].value),int(t[6].value),int(t[7].value))

def RPR_SetEnvelopePointEx(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['SetEnvelopePointEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('TrackEnvelope*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_int(p5),c_double(p6),c_byte(p7),c_byte(p8))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]),byref(t[7]),byref(t[8]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),int(t[5].value),float(t[6].value),int(t[7].value),int(t[8].value))

def RPR_SetEnvelopeStateChunk(p0,p1,p2):
  a=_ft['SetEnvelopeStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packp('TrackEnvelope*',p0),rpr_packsc(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetExtState(p0,p1,p2,p3):
  a=_ft['SetExtState']
  f=CFUNCTYPE(None,c_char_p,c_char_p,c_char_p,c_byte)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),rpr_packsc(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_SetGlobalAutomationOverride(p0):
  a=_ft['SetGlobalAutomationOverride']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_SetItemStateChunk(p0,p1,p2):
  a=_ft['SetItemStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packsc(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMasterTrackVisibility(p0):
  a=_ft['SetMasterTrackVisibility']
  f=CFUNCTYPE(c_int,c_int)(a)
  t=(c_int(p0),)
  r=f(t[0])
  return r

def RPR_SetMediaItemInfo_Value(p0,p1,p2):
  a=_ft['SetMediaItemInfo_Value']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_double)(a)
  t=(rpr_packp('MediaItem*',p0),rpr_packsc(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMediaItemLength(p0,p1,p2):
  a=_ft['SetMediaItemLength']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),c_double(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMediaItemPosition(p0,p1,p2):
  a=_ft['SetMediaItemPosition']
  f=CFUNCTYPE(c_byte,c_uint64,c_double,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),c_double(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMediaItemSelected(p0,p1):
  a=_ft['SetMediaItemSelected']
  f=CFUNCTYPE(None,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaItem*',p0),c_byte(p1))
  f(t[0],t[1])

def RPR_SetMediaItemTake_Source(p0,p1):
  a=_ft['SetMediaItemTake_Source']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packp('PCM_source*',p1))
  r=f(t[0],t[1])
  return r

def RPR_SetMediaItemTakeInfo_Value(p0,p1,p2):
  a=_ft['SetMediaItemTakeInfo_Value']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMediaTrackInfo_Value(p0,p1,p2):
  a=_ft['SetMediaTrackInfo_Value']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_double)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetMIDIEditorGrid(p0,p1):
  a=_ft['SetMIDIEditorGrid']
  f=CFUNCTYPE(None,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  f(t[0],t[1])

def RPR_SetMixerScroll(p0):
  a=_ft['SetMixerScroll']
  f=CFUNCTYPE(c_uint64,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return rpr_unpackp('MediaTrack*',r)

def RPR_SetMouseModifier(p0,p1,p2):
  a=_ft['SetMouseModifier']
  f=CFUNCTYPE(None,c_char_p,c_int,c_char_p)(a)
  t=(rpr_packsc(p0),c_int(p1),rpr_packsc(p2))
  f(t[0],t[1],t[2])

def RPR_SetOnlyTrackSelected(p0):
  a=_ft['SetOnlyTrackSelected']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  f(t[0])

def RPR_SetProjectGrid(p0,p1):
  a=_ft['SetProjectGrid']
  f=CFUNCTYPE(None,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  f(t[0],t[1])

def RPR_SetProjectMarker(p0,p1,p2,p3,p4):
  a=_ft['SetProjectMarker']
  f=CFUNCTYPE(c_byte,c_int,c_byte,c_double,c_double,c_char_p)(a)
  t=(c_int(p0),c_byte(p1),c_double(p2),c_double(p3),rpr_packsc(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_SetProjectMarker2(p0,p1,p2,p3,p4,p5):
  a=_ft['SetProjectMarker2']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte,c_double,c_double,c_char_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),rpr_packsc(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_SetProjectMarker3(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['SetProjectMarker3']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte,c_double,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),rpr_packsc(p5),c_int(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return r

def RPR_SetProjectMarker4(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['SetProjectMarker4']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte,c_double,c_double,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),rpr_packsc(p5),c_int(p6),c_int(p7))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7])
  return r

def RPR_SetProjectMarkerByIndex(p0,p1,p2,p3,p4,p5,p6,p7):
  a=_ft['SetProjectMarkerByIndex']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte,c_double,c_double,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),c_int(p5),rpr_packsc(p6),c_int(p7))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7])
  return r

def RPR_SetProjectMarkerByIndex2(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['SetProjectMarkerByIndex2']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_byte,c_double,c_double,c_int,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_byte(p2),c_double(p3),c_double(p4),c_int(p5),rpr_packsc(p6),c_int(p7),c_int(p8))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8])
  return r

def RPR_SetProjExtState(p0,p1,p2,p3):
  a=_ft['SetProjExtState']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_char_p,c_char_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),rpr_packsc(p2),rpr_packsc(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_SetRegionRenderMatrix(p0,p1,p2,p3):
  a=_ft['SetRegionRenderMatrix']
  f=CFUNCTYPE(None,c_uint64,c_int,c_uint64,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),rpr_packp('MediaTrack*',p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_SetTakeMarker(p0,p1,p2,p3,p4):
  a=_ft['SetTakeMarker']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_char_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packsc(p2),c_double(p3),c_int(p4))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]))
  return (r,p0,p1,p2,float(t[3].value),int(t[4].value))

def RPR_SetTakeStretchMarker(p0,p1,p2,p3):
  a=_ft['SetTakeStretchMarker']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_double,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],t[2],byref(t[3]))
  return (r,p0,p1,p2,float(t[3].value))

def RPR_SetTakeStretchMarkerSlope(p0,p1,p2):
  a=_ft['SetTakeStretchMarkerSlope']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_double(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetTempoTimeSigMarker(p0,p1,p2,p3,p4,p5,p6,p7,p8):
  a=_ft['SetTempoTimeSigMarker']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double,c_int,c_double,c_double,c_int,c_int,c_byte)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_double(p2),c_int(p3),c_double(p4),c_double(p5),c_int(p6),c_int(p7),c_byte(p8))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7],t[8])
  return r

def RPR_SetThemeColor(p0,p1,p2):
  a=_ft['SetThemeColor']
  f=CFUNCTYPE(c_int,c_char_p,c_int,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetToggleCommandState(p0,p1,p2):
  a=_ft['SetToggleCommandState']
  f=CFUNCTYPE(c_byte,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetTrackAutomationMode(p0,p1):
  a=_ft['SetTrackAutomationMode']
  f=CFUNCTYPE(None,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  f(t[0],t[1])

def RPR_SetTrackColor(p0,p1):
  a=_ft['SetTrackColor']
  f=CFUNCTYPE(None,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  f(t[0],t[1])

def RPR_SetTrackMIDILyrics(p0,p1,p2):
  a=_ft['SetTrackMIDILyrics']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_SetTrackMIDINoteName(p0,p1,p2,p3):
  a=_ft['SetTrackMIDINoteName']
  f=CFUNCTYPE(c_byte,c_int,c_int,c_int,c_char_p)(a)
  t=(c_int(p0),c_int(p1),c_int(p2),rpr_packsc(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_SetTrackMIDINoteNameEx(p0,p1,p2,p3,p4):
  a=_ft['SetTrackMIDINoteNameEx']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64,c_int,c_int,c_char_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('MediaTrack*',p1),c_int(p2),c_int(p3),rpr_packsc(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_SetTrackSelected(p0,p1):
  a=_ft['SetTrackSelected']
  f=CFUNCTYPE(None,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1))
  f(t[0],t[1])

def RPR_SetTrackSendInfo_Value(p0,p1,p2,p3,p4):
  a=_ft['SetTrackSendInfo_Value']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_double)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packsc(p3),c_double(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_SetTrackSendUIPan(p0,p1,p2,p3):
  a=_ft['SetTrackSendUIPan']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_SetTrackSendUIVol(p0,p1,p2,p3):
  a=_ft['SetTrackSendUIVol']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_double,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_double(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_SetTrackStateChunk(p0,p1,p2):
  a=_ft['SetTrackStateChunk']
  f=CFUNCTYPE(c_byte,c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_ShowActionList(p0,p1):
  a=_ft['ShowActionList']
  f=CFUNCTYPE(None,c_uint64,c_uint64)(a)
  t=(rpr_packp('KbdSectionInfo*',p0),rpr_packp('HWND',p1))
  f(t[0],t[1])

def RPR_ShowConsoleMsg(p0):
  a=_ft['ShowConsoleMsg']
  f=CFUNCTYPE(None,c_char_p)(a)
  t=(rpr_packsc(p0),)
  f(t[0])

def RPR_ShowMessageBox(p0,p1,p2):
  a=_ft['ShowMessageBox']
  f=CFUNCTYPE(c_int,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_ShowPopupMenu(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['ShowPopupMenu']
  f=CFUNCTYPE(None,c_char_p,c_int,c_int,c_uint64,c_uint64,c_int,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),c_int(p2),rpr_packp('HWND',p3),rpr_packp('void*',p4),c_int(p5),c_int(p6))
  f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])

def RPR_SLIDER2DB(p0):
  a=_ft['SLIDER2DB']
  f=CFUNCTYPE(c_double,c_double)(a)
  t=(c_double(p0),)
  r=f(t[0])
  return r

def RPR_SnapToGrid(p0,p1):
  a=_ft['SnapToGrid']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_SoloAllTracks(p0):
  a=_ft['SoloAllTracks']
  f=CFUNCTYPE(None,c_int)(a)
  t=(c_int(p0),)
  f(t[0])

def RPR_Splash_GetWnd():
  a=_ft['Splash_GetWnd']
  f=CFUNCTYPE(c_uint64)(a)
  r=f()
  return rpr_unpackp('HWND',r)

def RPR_SplitMediaItem(p0,p1):
  a=_ft['SplitMediaItem']
  f=CFUNCTYPE(c_uint64,c_uint64,c_double)(a)
  t=(rpr_packp('MediaItem*',p0),c_double(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('MediaItem*',r)

def RPR_stringToGuid(p0,p1):
  a=_ft['stringToGuid']
  f=CFUNCTYPE(None,c_char_p,c_uint64)(a)
  t=(rpr_packsc(p0),rpr_packp('GUID*',p1))
  f(t[0],t[1])

def RPR_StuffMIDIMessage(p0,p1,p2,p3):
  a=_ft['StuffMIDIMessage']
  f=CFUNCTYPE(None,c_int,c_int,c_int,c_int)(a)
  t=(c_int(p0),c_int(p1),c_int(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_TakeFX_AddByName(p0,p1,p2):
  a=_ft['TakeFX_AddByName']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),rpr_packsc(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_CopyToTake(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_CopyToTake']
  f=CFUNCTYPE(None,c_uint64,c_int,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packp('MediaItem_Take*',p2),c_int(p3),c_byte(p4))
  f(t[0],t[1],t[2],t[3],t[4])

def RPR_TakeFX_CopyToTrack(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_CopyToTrack']
  f=CFUNCTYPE(None,c_uint64,c_int,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packp('MediaTrack*',p2),c_int(p3),c_byte(p4))
  f(t[0],t[1],t[2],t[3],t[4])

def RPR_TakeFX_Delete(p0,p1):
  a=_ft['TakeFX_Delete']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TakeFX_EndParamEdit(p0,p1,p2):
  a=_ft['TakeFX_EndParamEdit']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_FormatParamValue(p0,p1,p2,p3,p4,p5):
  a=_ft['TakeFX_FormatParamValue']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),rpr_packs(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return (r,p0,p1,p2,p3,rpr_unpacks(t[4]),p5)

def RPR_TakeFX_FormatParamValueNormalized(p0,p1,p2,p3,p4,p5):
  a=_ft['TakeFX_FormatParamValueNormalized']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),rpr_packs(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return (r,p0,p1,p2,p3,rpr_unpacks(t[4]),p5)

def RPR_TakeFX_GetChainVisible(p0):
  a=_ft['TakeFX_GetChainVisible']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_TakeFX_GetCount(p0):
  a=_ft['TakeFX_GetCount']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_TakeFX_GetEnabled(p0,p1):
  a=_ft['TakeFX_GetEnabled']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TakeFX_GetEnvelope(p0,p1,p2,p3):
  a=_ft['TakeFX_GetEnvelope']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_byte(p3))
  r=f(t[0],t[1],t[2],t[3])
  return rpr_unpackp('TrackEnvelope*',r)

def RPR_TakeFX_GetFloatingWindow(p0,p1):
  a=_ft['TakeFX_GetFloatingWindow']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('HWND',r)

def RPR_TakeFX_GetFormattedParamValue(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetFormattedParamValue']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TakeFX_GetFXGUID(p0,p1):
  a=_ft['TakeFX_GetFXGUID']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('GUID*',r)

def RPR_TakeFX_GetFXName(p0,p1,p2,p3):
  a=_ft['TakeFX_GetFXName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TakeFX_GetIOSize(p0,p1,p2,p3):
  a=_ft['TakeFX_GetIOSize']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,int(t[2].value),int(t[3].value))

def RPR_TakeFX_GetNamedConfigParm(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetNamedConfigParm']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packsc(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TakeFX_GetNumParams(p0,p1):
  a=_ft['TakeFX_GetNumParams']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TakeFX_GetOffline(p0,p1):
  a=_ft['TakeFX_GetOffline']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TakeFX_GetOpen(p0,p1):
  a=_ft['TakeFX_GetOpen']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TakeFX_GetParam(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetParam']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value))

def RPR_TakeFX_GetParameterStepSizes(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['TakeFX_GetParameterStepSizes']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_double(p5),c_byte(p6))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),float(t[5].value),int(t[6].value))

def RPR_TakeFX_GetParamEx(p0,p1,p2,p3,p4,p5):
  a=_ft['TakeFX_GetParamEx']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_double(p5))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),float(t[5].value))

def RPR_TakeFX_GetParamFromIdent(p0,p1,p2):
  a=_ft['TakeFX_GetParamFromIdent']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_char_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_GetParamIdent(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetParamIdent']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TakeFX_GetParamName(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetParamName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TakeFX_GetParamNormalized(p0,p1,p2):
  a=_ft['TakeFX_GetParamNormalized']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_GetPinMappings(p0,p1,p2,p3,p4):
  a=_ft['TakeFX_GetPinMappings']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_int,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]))
  return (r,p0,p1,p2,p3,int(t[4].value))

def RPR_TakeFX_GetPreset(p0,p1,p2,p3):
  a=_ft['TakeFX_GetPreset']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TakeFX_GetPresetIndex(p0,p1,p2):
  a=_ft['TakeFX_GetPresetIndex']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_TakeFX_GetUserPresetFilename(p0,p1,p2,p3):
  a=_ft['TakeFX_GetUserPresetFilename']
  f=CFUNCTYPE(None,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TakeFX_NavigatePresets(p0,p1,p2):
  a=_ft['TakeFX_NavigatePresets']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_SetEnabled(p0,p1,p2):
  a=_ft['TakeFX_SetEnabled']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TakeFX_SetNamedConfigParm(p0,p1,p2,p3):
  a=_ft['TakeFX_SetNamedConfigParm']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_char_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packsc(p2),rpr_packsc(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TakeFX_SetOffline(p0,p1,p2):
  a=_ft['TakeFX_SetOffline']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TakeFX_SetOpen(p0,p1,p2):
  a=_ft['TakeFX_SetOpen']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TakeFX_SetParam(p0,p1,p2,p3):
  a=_ft['TakeFX_SetParam']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TakeFX_SetParamNormalized(p0,p1,p2,p3):
  a=_ft['TakeFX_SetParamNormalized']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TakeFX_SetPinMappings(p0,p1,p2,p3,p4,p5):
  a=_ft['TakeFX_SetPinMappings']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_TakeFX_SetPreset(p0,p1,p2):
  a=_ft['TakeFX_SetPreset']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_SetPresetByIndex(p0,p1,p2):
  a=_ft['TakeFX_SetPresetByIndex']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TakeFX_Show(p0,p1,p2):
  a=_ft['TakeFX_Show']
  f=CFUNCTYPE(None,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaItem_Take*',p0),c_int(p1),c_int(p2))
  f(t[0],t[1],t[2])

def RPR_TakeIsMIDI(p0):
  a=_ft['TakeIsMIDI']
  f=CFUNCTYPE(c_byte,c_uint64)(a)
  t=(rpr_packp('MediaItem_Take*',p0),)
  r=f(t[0])
  return r

def RPR_ThemeLayout_GetLayout(p0,p1,p2,p3):
  a=_ft['ThemeLayout_GetLayout']
  f=CFUNCTYPE(c_byte,c_char_p,c_int,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_ThemeLayout_GetParameter(p0,p1,p2,p3,p4,p5):
  a=_ft['ThemeLayout_GetParameter']
  f=CFUNCTYPE(c_char_p,c_int,c_uint64,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(c_int(p0),rpr_packp('char**',p1),c_int(p2),c_int(p3),c_int(p4),c_int(p5))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]))
  return (str(r.decode()),p0,p1,int(t[2].value),int(t[3].value),int(t[4].value),int(t[5].value))

def RPR_ThemeLayout_RefreshAll():
  a=_ft['ThemeLayout_RefreshAll']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ThemeLayout_SetLayout(p0,p1):
  a=_ft['ThemeLayout_SetLayout']
  f=CFUNCTYPE(c_byte,c_char_p,c_char_p)(a)
  t=(rpr_packsc(p0),rpr_packsc(p1))
  r=f(t[0],t[1])
  return r

def RPR_ThemeLayout_SetParameter(p0,p1,p2):
  a=_ft['ThemeLayout_SetParameter']
  f=CFUNCTYPE(c_byte,c_int,c_int,c_byte)(a)
  t=(c_int(p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_time_precise():
  a=_ft['time_precise']
  f=CFUNCTYPE(c_double)(a)
  r=f()
  return r

def RPR_TimeMap2_beatsToTime(p0,p1,p2):
  a=_ft['TimeMap2_beatsToTime']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_TimeMap2_GetDividedBpmAtTime(p0,p1):
  a=_ft['TimeMap2_GetDividedBpmAtTime']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_TimeMap2_GetNextChangeTime(p0,p1):
  a=_ft['TimeMap2_GetNextChangeTime']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_TimeMap2_QNToTime(p0,p1):
  a=_ft['TimeMap2_QNToTime']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_TimeMap2_timeToBeats(p0,p1,p2,p3,p4,p5):
  a=_ft['TimeMap2_timeToBeats']
  f=CFUNCTYPE(c_double,c_uint64,c_double,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_int(p2),c_int(p3),c_double(p4),c_int(p5))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]))
  return (r,p0,p1,int(t[2].value),int(t[3].value),float(t[4].value),int(t[5].value))

def RPR_TimeMap2_timeToQN(p0,p1):
  a=_ft['TimeMap2_timeToQN']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_TimeMap_curFrameRate(p0,p1):
  a=_ft['TimeMap_curFrameRate']
  f=CFUNCTYPE(c_double,c_uint64,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_byte(p1))
  r=f(t[0],byref(t[1]))
  return (r,p0,int(t[1].value))

def RPR_TimeMap_GetDividedBpmAtTime(p0):
  a=_ft['TimeMap_GetDividedBpmAtTime']
  f=CFUNCTYPE(c_double,c_double)(a)
  t=(c_double(p0),)
  r=f(t[0])
  return r

def RPR_TimeMap_GetMeasureInfo(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['TimeMap_GetMeasureInfo']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_void_p,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_int(p1),c_double(p2),c_double(p3),c_int(p4),c_int(p5),c_double(p6))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,p1,float(t[2].value),float(t[3].value),int(t[4].value),int(t[5].value),float(t[6].value))

def RPR_TimeMap_GetMetronomePattern(p0,p1,p2,p3):
  a=_ft['TimeMap_GetMetronomePattern']
  f=CFUNCTYPE(c_int,c_uint64,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TimeMap_GetTimeSigAtTime(p0,p1,p2,p3,p4):
  a=_ft['TimeMap_GetTimeSigAtTime']
  f=CFUNCTYPE(None,c_uint64,c_double,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_int(p2),c_int(p3),c_double(p4))
  f(t[0],t[1],byref(t[2]),byref(t[3]),byref(t[4]))
  return (p0,p1,int(t[2].value),int(t[3].value),float(t[4].value))

def RPR_TimeMap_QNToMeasures(p0,p1,p2,p3):
  a=_ft['TimeMap_QNToMeasures']
  f=CFUNCTYPE(c_int,c_uint64,c_double,c_void_p,c_void_p)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1),c_double(p2),c_double(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,float(t[2].value),float(t[3].value))

def RPR_TimeMap_QNToTime(p0):
  a=_ft['TimeMap_QNToTime']
  f=CFUNCTYPE(c_double,c_double)(a)
  t=(c_double(p0),)
  r=f(t[0])
  return r

def RPR_TimeMap_QNToTime_abs(p0,p1):
  a=_ft['TimeMap_QNToTime_abs']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_TimeMap_timeToQN(p0):
  a=_ft['TimeMap_timeToQN']
  f=CFUNCTYPE(c_double,c_double)(a)
  t=(c_double(p0),)
  r=f(t[0])
  return r

def RPR_TimeMap_timeToQN_abs(p0,p1):
  a=_ft['TimeMap_timeToQN_abs']
  f=CFUNCTYPE(c_double,c_uint64,c_double)(a)
  t=(rpr_packp('ReaProject*',p0),c_double(p1))
  r=f(t[0],t[1])
  return r

def RPR_ToggleTrackSendUIMute(p0,p1):
  a=_ft['ToggleTrackSendUIMute']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_Track_GetPeakHoldDB(p0,p1,p2):
  a=_ft['Track_GetPeakHoldDB']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_Track_GetPeakInfo(p0,p1):
  a=_ft['Track_GetPeakInfo']
  f=CFUNCTYPE(c_double,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackCtl_SetToolTip(p0,p1,p2,p3):
  a=_ft['TrackCtl_SetToolTip']
  f=CFUNCTYPE(None,c_char_p,c_int,c_int,c_byte)(a)
  t=(rpr_packsc(p0),c_int(p1),c_int(p2),c_byte(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_TrackFX_AddByName(p0,p1,p2,p3):
  a=_ft['TrackFX_AddByName']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_byte,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_byte(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TrackFX_CopyToTake(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_CopyToTake']
  f=CFUNCTYPE(None,c_uint64,c_int,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packp('MediaItem_Take*',p2),c_int(p3),c_byte(p4))
  f(t[0],t[1],t[2],t[3],t[4])

def RPR_TrackFX_CopyToTrack(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_CopyToTrack']
  f=CFUNCTYPE(None,c_uint64,c_int,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packp('MediaTrack*',p2),c_int(p3),c_byte(p4))
  f(t[0],t[1],t[2],t[3],t[4])

def RPR_TrackFX_Delete(p0,p1):
  a=_ft['TrackFX_Delete']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_EndParamEdit(p0,p1,p2):
  a=_ft['TrackFX_EndParamEdit']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_FormatParamValue(p0,p1,p2,p3,p4,p5):
  a=_ft['TrackFX_FormatParamValue']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3),rpr_packs(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return (r,p0,p1,p2,p3,rpr_unpacks(t[4]),p5)

def RPR_TrackFX_FormatParamValueNormalized(p0,p1,p2,p3,p4,p5):
  a=_ft['TrackFX_FormatParamValueNormalized']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3),rpr_packs(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return (r,p0,p1,p2,p3,rpr_unpacks(t[4]),p5)

def RPR_TrackFX_GetByName(p0,p1,p2):
  a=_ft['TrackFX_GetByName']
  f=CFUNCTYPE(c_int,c_uint64,c_char_p,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),rpr_packsc(p1),c_byte(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_GetChainVisible(p0):
  a=_ft['TrackFX_GetChainVisible']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_TrackFX_GetCount(p0):
  a=_ft['TrackFX_GetCount']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_TrackFX_GetEnabled(p0,p1):
  a=_ft['TrackFX_GetEnabled']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_GetEQ(p0,p1):
  a=_ft['TrackFX_GetEQ']
  f=CFUNCTYPE(c_int,c_uint64,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_byte(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_GetEQBandEnabled(p0,p1,p2,p3):
  a=_ft['TrackFX_GetEQBandEnabled']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TrackFX_GetEQParam(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['TrackFX_GetEQParam']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4),c_int(p5),c_double(p6))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,p1,p2,int(t[3].value),int(t[4].value),int(t[5].value),float(t[6].value))

def RPR_TrackFX_GetFloatingWindow(p0,p1):
  a=_ft['TrackFX_GetFloatingWindow']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('HWND',r)

def RPR_TrackFX_GetFormattedParamValue(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetFormattedParamValue']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TrackFX_GetFXGUID(p0,p1):
  a=_ft['TrackFX_GetFXGUID']
  f=CFUNCTYPE(c_uint64,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return rpr_unpackp('GUID*',r)

def RPR_TrackFX_GetFXName(p0,p1,p2,p3):
  a=_ft['TrackFX_GetFXName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TrackFX_GetInstrument(p0):
  a=_ft['TrackFX_GetInstrument']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_TrackFX_GetIOSize(p0,p1,p2,p3):
  a=_ft['TrackFX_GetIOSize']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3))
  r=f(t[0],t[1],byref(t[2]),byref(t[3]))
  return (r,p0,p1,int(t[2].value),int(t[3].value))

def RPR_TrackFX_GetNamedConfigParm(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetNamedConfigParm']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packsc(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TrackFX_GetNumParams(p0,p1):
  a=_ft['TrackFX_GetNumParams']
  f=CFUNCTYPE(c_int,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_GetOffline(p0,p1):
  a=_ft['TrackFX_GetOffline']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_GetOpen(p0,p1):
  a=_ft['TrackFX_GetOpen']
  f=CFUNCTYPE(c_byte,c_uint64,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1))
  r=f(t[0],t[1])
  return r

def RPR_TrackFX_GetParam(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetParam']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value))

def RPR_TrackFX_GetParameterStepSizes(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['TrackFX_GetParameterStepSizes']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_double(p5),c_byte(p6))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]),byref(t[6]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),float(t[5].value),int(t[6].value))

def RPR_TrackFX_GetParamEx(p0,p1,p2,p3,p4,p5):
  a=_ft['TrackFX_GetParamEx']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int,c_void_p,c_void_p,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3),c_double(p4),c_double(p5))
  r=f(t[0],t[1],t[2],byref(t[3]),byref(t[4]),byref(t[5]))
  return (r,p0,p1,p2,float(t[3].value),float(t[4].value),float(t[5].value))

def RPR_TrackFX_GetParamFromIdent(p0,p1,p2):
  a=_ft['TrackFX_GetParamFromIdent']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_GetParamIdent(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetParamIdent']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TrackFX_GetParamName(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetParamName']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),rpr_packs(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return (r,p0,p1,p2,rpr_unpacks(t[3]),p4)

def RPR_TrackFX_GetParamNormalized(p0,p1,p2):
  a=_ft['TrackFX_GetParamNormalized']
  f=CFUNCTYPE(c_double,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_GetPinMappings(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_GetPinMappings']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_int,c_int,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4))
  r=f(t[0],t[1],t[2],t[3],byref(t[4]))
  return (r,p0,p1,p2,p3,int(t[4].value))

def RPR_TrackFX_GetPreset(p0,p1,p2,p3):
  a=_ft['TrackFX_GetPreset']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  r=f(t[0],t[1],t[2],t[3])
  return (r,p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TrackFX_GetPresetIndex(p0,p1,p2):
  a=_ft['TrackFX_GetPresetIndex']
  f=CFUNCTYPE(c_int,c_uint64,c_int,c_void_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],byref(t[2]))
  return (r,p0,p1,int(t[2].value))

def RPR_TrackFX_GetRecChainVisible(p0):
  a=_ft['TrackFX_GetRecChainVisible']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_TrackFX_GetRecCount(p0):
  a=_ft['TrackFX_GetRecCount']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('MediaTrack*',p0),)
  r=f(t[0])
  return r

def RPR_TrackFX_GetUserPresetFilename(p0,p1,p2,p3):
  a=_ft['TrackFX_GetUserPresetFilename']
  f=CFUNCTYPE(None,c_uint64,c_int,c_char_p,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packs(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])
  return (p0,p1,rpr_unpacks(t[2]),p3)

def RPR_TrackFX_NavigatePresets(p0,p1,p2):
  a=_ft['TrackFX_NavigatePresets']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_SetEnabled(p0,p1,p2):
  a=_ft['TrackFX_SetEnabled']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TrackFX_SetEQBandEnabled(p0,p1,p2,p3,p4):
  a=_ft['TrackFX_SetEQBandEnabled']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3),c_byte(p4))
  r=f(t[0],t[1],t[2],t[3],t[4])
  return r

def RPR_TrackFX_SetEQParam(p0,p1,p2,p3,p4,p5,p6):
  a=_ft['TrackFX_SetEQParam']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int,c_int,c_double,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4),c_double(p5),c_byte(p6))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5],t[6])
  return r

def RPR_TrackFX_SetNamedConfigParm(p0,p1,p2,p3):
  a=_ft['TrackFX_SetNamedConfigParm']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packsc(p2),rpr_packsc(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TrackFX_SetOffline(p0,p1,p2):
  a=_ft['TrackFX_SetOffline']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TrackFX_SetOpen(p0,p1,p2):
  a=_ft['TrackFX_SetOpen']
  f=CFUNCTYPE(None,c_uint64,c_int,c_byte)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_byte(p2))
  f(t[0],t[1],t[2])

def RPR_TrackFX_SetParam(p0,p1,p2,p3):
  a=_ft['TrackFX_SetParam']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TrackFX_SetParamNormalized(p0,p1,p2,p3):
  a=_ft['TrackFX_SetParamNormalized']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_double)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_double(p3))
  r=f(t[0],t[1],t[2],t[3])
  return r

def RPR_TrackFX_SetPinMappings(p0,p1,p2,p3,p4,p5):
  a=_ft['TrackFX_SetPinMappings']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int,c_int,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2),c_int(p3),c_int(p4),c_int(p5))
  r=f(t[0],t[1],t[2],t[3],t[4],t[5])
  return r

def RPR_TrackFX_SetPreset(p0,p1,p2):
  a=_ft['TrackFX_SetPreset']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_char_p)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_SetPresetByIndex(p0,p1,p2):
  a=_ft['TrackFX_SetPresetByIndex']
  f=CFUNCTYPE(c_byte,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_TrackFX_Show(p0,p1,p2):
  a=_ft['TrackFX_Show']
  f=CFUNCTYPE(None,c_uint64,c_int,c_int)(a)
  t=(rpr_packp('MediaTrack*',p0),c_int(p1),c_int(p2))
  f(t[0],t[1],t[2])

def RPR_TrackList_AdjustWindows(p0):
  a=_ft['TrackList_AdjustWindows']
  f=CFUNCTYPE(None,c_byte)(a)
  t=(c_byte(p0),)
  f(t[0])

def RPR_TrackList_UpdateAllExternalSurfaces():
  a=_ft['TrackList_UpdateAllExternalSurfaces']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_Undo_BeginBlock():
  a=_ft['Undo_BeginBlock']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_Undo_BeginBlock2(p0):
  a=_ft['Undo_BeginBlock2']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  f(t[0])

def RPR_Undo_CanRedo2(p0):
  a=_ft['Undo_CanRedo2']
  f=CFUNCTYPE(c_char_p,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_Undo_CanUndo2(p0):
  a=_ft['Undo_CanUndo2']
  f=CFUNCTYPE(c_char_p,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return str(r.decode())

def RPR_Undo_DoRedo2(p0):
  a=_ft['Undo_DoRedo2']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_Undo_DoUndo2(p0):
  a=_ft['Undo_DoUndo2']
  f=CFUNCTYPE(c_int,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),)
  r=f(t[0])
  return r

def RPR_Undo_EndBlock(p0,p1):
  a=_ft['Undo_EndBlock']
  f=CFUNCTYPE(None,c_char_p,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1))
  f(t[0],t[1])

def RPR_Undo_EndBlock2(p0,p1,p2):
  a=_ft['Undo_EndBlock2']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),c_int(p2))
  f(t[0],t[1],t[2])

def RPR_Undo_OnStateChange(p0):
  a=_ft['Undo_OnStateChange']
  f=CFUNCTYPE(None,c_char_p)(a)
  t=(rpr_packsc(p0),)
  f(t[0])

def RPR_Undo_OnStateChange2(p0,p1):
  a=_ft['Undo_OnStateChange2']
  f=CFUNCTYPE(None,c_uint64,c_char_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1))
  f(t[0],t[1])

def RPR_Undo_OnStateChange_Item(p0,p1,p2):
  a=_ft['Undo_OnStateChange_Item']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_uint64)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),rpr_packp('MediaItem*',p2))
  f(t[0],t[1],t[2])

def RPR_Undo_OnStateChangeEx(p0,p1,p2):
  a=_ft['Undo_OnStateChangeEx']
  f=CFUNCTYPE(None,c_char_p,c_int,c_int)(a)
  t=(rpr_packsc(p0),c_int(p1),c_int(p2))
  f(t[0],t[1],t[2])

def RPR_Undo_OnStateChangeEx2(p0,p1,p2,p3):
  a=_ft['Undo_OnStateChangeEx2']
  f=CFUNCTYPE(None,c_uint64,c_char_p,c_int,c_int)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packsc(p1),c_int(p2),c_int(p3))
  f(t[0],t[1],t[2],t[3])

def RPR_UpdateArrange():
  a=_ft['UpdateArrange']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_UpdateItemInProject(p0):
  a=_ft['UpdateItemInProject']
  f=CFUNCTYPE(None,c_uint64)(a)
  t=(rpr_packp('MediaItem*',p0),)
  f(t[0])

def RPR_UpdateTimeline():
  a=_ft['UpdateTimeline']
  f=CFUNCTYPE(None)(a)
  f()

def RPR_ValidatePtr2(p0,p1,p2):
  a=_ft['ValidatePtr2']
  f=CFUNCTYPE(c_byte,c_uint64,c_uint64,c_char_p)(a)
  t=(rpr_packp('ReaProject*',p0),rpr_packp('void*',p1),rpr_packsc(p2))
  r=f(t[0],t[1],t[2])
  return r

def RPR_ViewPrefs(p0,p1):
  a=_ft['ViewPrefs']
  f=CFUNCTYPE(None,c_int,c_char_p)(a)
  t=(c_int(p0),rpr_packsc(p1))
  f(t[0],t[1])

