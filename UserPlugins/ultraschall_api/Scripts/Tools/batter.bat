cd C:\Ultraschall-Hackversion_3.2_US_beta_2_79/UserPlugins/
del c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\ultraschall_api4.00_beta2.79.zip
zip.exe -r c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\ultraschall_api4.00_beta2.79.zip *.lua *.txt ultraschall_api

del c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\Reaper-Internals-Ultraschall-Api-Docs.zip
cd ultraschall_api

..\zip.exe -r c:\Ultraschall-Api-Git-Repo\Ultraschall-Api-for-Reaper\Reaper-Internals-Ultraschall-Api-Docs.zip Documentation\* Reaper-Internals-readme.txt c:\Reaper-Internal-Docs-Miscellaneous_Maybe_Helpful_Files
del Reaper-Internals-readme.txt
del Scripts\Tools\batter.bat
