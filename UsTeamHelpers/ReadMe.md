# Nutzen des Sortier-Hooks

[Git Hooks](https://www.atlassian.com/git/tutorials/git-hooks) sind Skripte, die i. d. R. _lokal_
auf jedem einzelnen Entwickler-Rechner vorliegen. So kann jeder Entwickler sein eigenes (für ihn sinvolles)
Vorgehen realisieren.

Git Hooks liegen üblicherweise als ausführbare [Bash-Skripte](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-2.html)
in dem "versteckten" Git-Ordner eines Repositories: ``.git``

Bei mir liegt der Ordner z. B. hier: ``C:\Users\doppelpussy\Documents\Dev\ultraschall-portable\.git``.
Dieser ist auf unixoiden Systemen ["versteckt"](https://de.wikipedia.org/wiki/Versteckte_Datei),
weil unter Unix Ordner und Dateien mit führendem Punkt standardmäßig nicht angezeigt werden.

## Ablage im Git-Ordner

Ein Git-Ordner hat üblicherweise [folgende Struktur](https://githowto.com/git_internals_git_directory):

```sh
$  ls -C .git
COMMIT_EDITMSG  description  HEAD    index  logs/     ORIG_HEAD    refs/
config          FETCH_HEAD   hooks/  info/  objects/  packed-refs
```

Im Ordner ``hooks`` sind Beispiel-Dateien, die man als Vorlage für eigene Anwendungen nutzen kann.

```sh
$ ls -C .git/hooks/
applypatch-msg.sample*      pre-applypatch.sample*      pre-rebase.sample*
commit-msg.sample*          pre-commit.sample*          pre-receive.sample*
fsmonitor-watchman.sample*  prepare-commit-msg.sample*  update.sample*
post-update.sample*         pre-push.sample*
```

(Anmerkung: Der Stern hinter der Datei besagt unter Linux / der Bash, dass die Datei als "ausführbar" markiert ist.)

In genau dieses Verzeichnis kopiere ich alle Dateien, die zu meinem "pre-commit-Hook" gehören.
Dann wird er durch git "automatisch" bei jedem commit angewendet.

``$ cp UsTeamHelpers/pre-commit UsTeamHelpers/sort_reaper_kb_ini.sh .git/hooks/``

Danach liegen die zwei Dateien _zusätzlich_ in diesem lokalen Ordner:

```sh
$ ls -C .git/hooks/
applypatch-msg.sample*      pre-commit*                 pre-receive.sample*
commit-msg.sample*          pre-commit.sample*          sort_reaper_kb_ini.sh*
fsmonitor-watchman.sample*  prepare-commit-msg.sample*  update.sample*
post-update.sample*         pre-push.sample*
pre-applypatch.sample*      pre-rebase.sample*
```

Wenn man nun einen Commit ausführt, der Änderungen an der reaper-kb.ini beinhaltet,
wird eine sortierte reaper-kb.ini Datei _zusätzlich_ im Unterordner "niceDiff" abgelegt.
Falls der Ordner nicht existiert wird er erstellt. Die zusätzlich erzeugte Datei wird zu
dem Commit hinzugefgt, so dass man dann mindestens zwei Dateien commited:

``reaper-kb.ini`` und ``niceDiff/reaper-kb.ini``

## Reapers Eigenwilligkeit ignorieren

Wenn man entwickelt und Reaper irgendwas an der reaper-kb.ini ändert, aber man sich definitiv sicher ist,
dass das jetzt keine "wichtige" Änderung ist, sondern nur an "Reapers Exzentrik" liegt,
dann darf man die Änderungen an der reaper-kb.ini auch ruhig ignorieren.
In so einem Fall fügt man die reaper-kb.ini gar nicht zu dem Commit hinzu. Also stellt man sie gar nicht für den Commit bereit (stagen). Falls man vorher alle Änderungen bereitgestellt hat, kann man dann mit einem
``$ g reset HEAD reaper-kb.ini``
die Bereitstellung der reaper-kb.ini vor dem Commit wieder zurück nehmen.

## Vorschlag zum Testen des Git-Hooks

1. Auschecken des Entwicklungsbranches "#30-sortiere-reaper-kb-ini-per-git-hook". Z. B. durch ``git fetch --prune``, ``git checkout #30-sortiere-reaper-kb-ini-per-git-hook``, ``git pull``
2. Erstellen eines Branches zum Testen, der _von diesem_ Branch abzweigt.
Z. B. durch ``$ git branch teste-die-sortierung`` und einem anschließenden ``$ git checkout teste-die-sortierung``
3. Änderungen an der reaper-kb.ini vornehmen und einen (lokalen) Commit (ohne pushen) ausführen
4. weitere dreckige Tests, um das Skript "kaputt zu machen"... ;-)