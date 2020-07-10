_**Note: With the release of v3, this repo is no longer being actively developed with the exception of fixing any bugs that may come up. v3 is available on ReaPack, and documentation can be found [here](https://jalovatt.github.io/scythe). Cheers.**_

# Lokasenna_GUI v2
Lua GUI library for [REAPER][1] scripts

## Obligatory Preamble
As powerful as REAPER's scripting capabilities are, it offers nothing in the way of
providing a graphical interface for the end-user to make choices, tinker with settings, etc.
Many scripters opt to designate certain lines in the script with _USER_ _SETTINGS_
_HERE_ and _EDIT_ _THIS_ _LINE_, but - in my opinion - any feature that requires users to edit
Lua, EEL, or (_*shudder*_) Python files directly is woefully incomplete. Rude, even.

In the process of learning to write scripts for myself I found myself copying, pasting, and
extending the same fragments of code, cobbled together from a handful of forum threads
with examples of REAPER's graphical functions, and eventually decided to just stop what I
was doing and put it all together into a proper GUI toolkit.

![https://github.com/jalovatt/Lokasenna_GUI/wiki/images/showcase thumb.png][5]

Enjoy. :)

Or don't. See if I care.

## Installation
### End Users
Stable releases are available from the ReaTeam repository on [ReaPack][4], or directly from the
[ReaTeam script repository][6].

- Install _Lokasenna's GUI Library v2 for Lua_
- In Reaper's action list, choose _ReaScript: Run reaScript (EEL, lua, or python)..._
- Navigate to the library's folder. Typically:
  _[Reaper resource folder]/Scripts/ReaTeam Scripts/Development/Lokasenna_GUI v2/Library_
- Run _Set Lokasenna_GUI v2 library path.lua_ to make the library available for other scripts

### Developers
A separate package, _Lokasenna's GUI Library v2 for Lua (Developer Tools)_, provides templates,
examples, and an experimental GUI builder. I hope you'll find enough detail to answer any questions. If something's missing, wrong, outdated, or vague, by all means let me know.

This repository is home to all development work for upcoming releases and their accompanying
documentation. As such, nothing here should be considered safe for release until it shows up on ReaPack. Likewise, the project wiki is subject to change and revision at the drop of a hat. I'll try to keep it more-or-less in sync with any changes/features/etc as I upload them.

## Documentation
See the [project wiki](https://github.com/jalovatt/Lokasenna_GUI/wiki).

## Contributing
I'd love to not be the only person working on this. Fork the project if you want, send me a
message with your changes, submit pull requests, whatever works for you. I apologize in advance
if I end up making changes that break whatever you were working on - I've been known to restructure
and refactor the entire library when I feel the need.

## Licensing
Do whatever you want with it. If you release a script using my library I'd love to know about it,
and would be thrilled to see my name mentioned on your script's thread/website. If you plan to
charge money for a script using this library, that's great, but I'd really appreciate a donation
for my time and effort.

If you just use or copy my code without mentioning where it came from, I'll be very upset and might
become an alcoholic to cope with the embarassment. And then my marriage would fall apart, and my family
would abandon me. And I wouldn't be able to hold down a job, so I'd be homeless and sick and it
would be all your fault. You bastard.

## Discussion
General questions, comments, feature requests, bug reports, and the latest celebrity gossip are welcome
either here, via the Issue tracker, or in the project's [official thread][3] on the REAPER forum.

## Donations
I don't have the confidence to charge money for this stuff. However, should you feel so inclined,
contributions of Dollars, Quatloos, Pieces of Eight, Galactic Credits, or Pus (no Ningis, thanks)
are always welcome and can be made [via Paypal][7]. Cheers.

[1]: https://www.reaper.fm/
[2]: https://github.com/jalovatt/Lokasenna_GUI/wiki
[3]: https://forum.cockos.com/showthread.php?t=177772
[4]: https://reapack.com/
[5]: https://github.com/jalovatt/Lokasenna_GUI/wiki/images/showcase.png
[6]: https://github.com/ReaTeam/ReaScripts/tree/master/Development/Lokasenna_GUI%20v2
[7]: https://www.paypal.me/Lokasenna
