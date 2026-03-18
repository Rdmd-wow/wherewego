# WhereWeGo

A lightweight World of Warcraft addon that displays a persistent on-screen frame showing which dungeon or raid your group was formed for — so you always know where you're headed.

## Features

- Shows dungeon/raid name with English translation
- Shows zone location with `[위치]` label
- Shows current party leader with `[파티장]` label
- Automatically updates when party leader changes
- Draggable, persistent frame (position saved across sessions)
- Works with premade Group Finder (LFG), direct invites, and automated LFG queue

## Supported Content

**WoW Midnight dungeons:** Windrunner Spire, Magisters' Terrace, Death's Row, Nalorakk's Den, Maisara Caverns, Nexus-Point Xenas, Shining Vale, Voidscar Arena

**Legacy rotation:** Algeth'ar Academy, Pit of Saron, Seat of the Triumvirate, Skyreach

**The War Within:** Ara-Kara, The Stonevault, City of Threads, Darkflame Cleft, The Dawnbreaker, Atal'Dazar, Siege of Boralus, Karazhan (Upper/Lower)

**Raids:** Liberation of Undermine, Nerub-ar Palace

## Installation

1. Download and unzip
2. Copy the `WhereWeGo` folder into:
   ```
   World of Warcraft/_retail_/Interface/AddOns/
   ```
3. Enable the addon in the character select screen

## Commands

| Command | Description |
|---|---|
| `/wwg show` | Show the current group note |
| `/wwg hide` | Hide the frame |
| `/wwg clear` | Clear saved note (use if note looks stale) |
| `/wwg reset` | Reset frame position to center |
| `/wwg debug` | Print debug info to chat |

## Interface

- Drag the frame anywhere on screen — position is saved
- The note appears automatically when you join a group and hides when you leave

## Requirements

- WoW Midnight (Interface 120000+)
- Korean or English client

## License

MIT — see [LICENSE](LICENSE)
