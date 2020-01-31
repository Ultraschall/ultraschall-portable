Hotfix-Installer-Theme erstellen.
Version vom 1.2.2020

1.) Kopiere die zu installierenden Dateien in das Verzeichnis

    Hotfix-Folder/Scripts/Ultraschall_Installfiles/
    
2.) Schreibe einen beschreibenden Text in die Datei

    Hotfix-Folder/Scripts/Ultraschall_Install.me
    
3.) Führe das Theme-Ersteller-batch-script aus.
    
    Windows: Windows-Create_ThemeFile.bat
    Mac: fehlt noch
    Linux: fehlt noch
    
    
Es ist möglich die Themes für alle Systeme auf einem OS zu erstellen. Dazu müssen nur 
die OS-abhängigen Teile im Ordner Hotfix-Folder/Scripts/Ultraschall_Installfiles/
ersetzt werden, und die Datei neu erstellt mit Hilfe des Batchscripts.


Es existiert eine Demo.ReaperConfigZip, die die __startup.lua mit einer Version ersetzt, die "Works for Me" nach dem Start anzeigt.