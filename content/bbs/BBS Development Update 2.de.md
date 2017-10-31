+++
title = "Skycoin BBS Entwicklungsupdate #2"
tags = [
    "Development",
    "BBS",
    "CXO",
]
date = "2017-08-31"
categories = [
    "Development Updates",
]
+++

Es ist mehr als ein Monat vergangen, seitdem die Version 0.1 veröffentlicht wurde und 0.2 wird schon bald fertig sein!

Die Änderungen sind wie folgt:

- Nutzen der aktuellen CXO-Version (Peer-zu-Peer selbstreplizierende Datenbanken).
- Reimplementierung der CXO-Objekte und Bäume (In Vorbereitung für neue Feature).
- Vorstellung eines `Views`-Modul, für die einfache Implementierung von verschiedenen Wegen, Inhalte zu "betrachten".
- Erste Implementierung für das Folgen oder Vemeiden von Usern.
- Komplette Neuaufsetzung der Benutzeroberfläche (UI).

## CXO-Änderungen

CXO wurde graviend refaktorisiert um schneller und stabiler zu sein. 

Die API funktioniert nun besser mit Hash-Arrays - mit Zugriff in konstanter Zeit, schnellerer Replikation und die Möglichkeit, Elemente mit gegebenem Hash direkt abzurufen.

Diese Änderungen haben das BBS dazu veranleited, die Mehrheit seiner Codestruktur ebenso zu verändern.

[Schaut hier in das CXO-Repository.](https://github.com/skycoin/cxo)

## CXO-Datenstrukturänderungen

Änderungen der Datenstruktur um folgende Probleme zu addressieren:
1. Implementieren einer Struktur, in der User in Zukunft zu ihrer eigenen Wurzel migrieren können.
2. Leichtes Bestimmen von "diffs" zwischen Root-Sequenzen (auch genannt Änderungen). Das wird dem Kompilieren der Views nützlich sein und Echtzeitupdates für den Endnutzer bereitstellen.
3. Leichtes Bestimmen des Typs eines Root-Objektes für verschiedene Root-Typen.

![Skycoin BBS v0.2 CXO-Datenstrukturen](/bbs/img/bbs_cxo_datastructure_v0.2.png)

Die `Wurzelseite`-Objekt (`RootPage`) bestimmt den Typ der Wurzel. Vorerst werden alle Daten unter einer Wurzel pro Board angehäuft. 
In der Zukunft werden User und Threads ihre individuellen Wurzeln haben.

Zukünftig wird `Brettseite`(`BoardPage`) eine Liste der öffentlichen Schlüssel haben, anstatt die href für die Threads, da diese ihre eigenen Wurzeln haben werden. Das wird das Umziehen von Threads zwischen Boards einfach machen.

Die `Änderungsseite` (`DiffPage`) wird verwendet von Änderungen der Root-Sequenzen zu bestimmten, um diese auf der `Brettseite`-Wurzel einzutragen. Dies ist im Grunde genommen, ein Satz von sich stets-erhöhenden Arrays, bei denen eine Erhöhung der Länge, als Änderung interpretiert werden.
`Userseite` (`UserPage`) wird letztendlich eine Liste von öffentlichen Schlüsseln werden (diese werden wie "Teilnehmer" eines Bretts sein). Jeder User wird seine eigenen Wurzel haben.

## Ansichtmodulimplementation

Eine Ansicht (view) ist grundsätzlich nur eine Oberfläche:

```go
type View interface {

	// Init erstellt die Ansicht.
	Init(pack *skyobject.Pack, headers *pack.Headers, mux *sync.Mutex) error

	// Update aktualisiert die Ansicht.
	Update(pack *skyobject.Pack, headers *pack.Headers, mux *sync.Mutex) error

	// Get erhält Informationen von der Ansicht.
	Get(id string, a ...interface{}) (interface{}, error)
}
```

Aktuell werden alle kompilierten Ansichten im Speicher abgespeichert. Dies wird allerdings unpraktisch werden, sobald unsere Userbasis sich vergrößert. Ansichten werden in küpnftigen Veröffentlichungen schlüsselwertbasiert (key-value), auf der Festplatte, abgespeichert werden.
Für Version 0.2 gibt es zwei Implementierungen der `Ansicht`; eine für den Inhalt (Bretter/Threads/Posts/Votes) und eine für das Kompilieren einer Follower/Vermeiderliste pro User.

## Eine neue Usererfahrung

Während dieser Post verfasst wird, ist dies fast fertig gestellt. Hier ist ein Youtubevideo des Fortschritts:

[![Skycoin BBS Vorzeigeprojekt 4](https://i.ytimg.com/vi/Oue3WVkmGh4/0.jpg)](https://youtu.be/Oue3WVkmGh4)

Um auf dem Stand der Dinge der Skycoin BBS-Entwicklung zu bleiben, schaut hier regelmäßig rein und tretet unserer [Skycoin BBS Community](https://t.me/skycoinbbs) bei, sowie unserer Gruppe auf Telegram.
