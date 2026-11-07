# Roblox Audio Beat Player Script

Roblox script for playing approved Roblox audio assets with a server synchronized 16 step beat clock. Players can enter a Roblox audio asset ID, a Roblox audio URL, or a configured song alias, choose a BPM, and start a looping in game song with beat signals and visual timing feedback.

## Install

1. Create a `Script` inside `ServerScriptService` named `SongBeatServer`.
2. Copy the contents of `src/SongBeatServer.server.lua` into the script.
3. Create a `LocalScript` inside `StarterPlayer > StarterPlayerScripts` named `SongBeatClient`.
4. Copy the contents of `src/SongBeatClient.client.lua` into the LocalScript.
5. Publish the experience and test with an approved Roblox audio asset that the experience is allowed to use.

The server script automatically creates the `SongBeatRequest` and `SongBeatSignal` RemoteEvents in `ReplicatedStorage`. The client script automatically creates the user interface and looping `Sound` in `Workspace`.

## Use

1. Start the experience.
2. Enter one of the following in the song field:
   - A numeric Roblox audio asset ID, such as `1234567890`
   - A Roblox asset ID such as `rbxassetid://1234567890`
   - A Roblox audio URL ending with the asset ID
   - A name configured in the server script's `songAliases` table
3. Enter a BPM value. Values are rounded and limited to 60 through 180 BPM. The default is 92 BPM.
4. Select `LOAD SONG + START BEAT`.
5. The selected Roblox audio asset loops while the server sends beat signals to all clients.
6. The interface displays the current beat and 16 step position. Steps 1 and 9 receive accent feedback.

To add friendly song names, edit `songAliases` in `SongBeatServer`:

```lua
local songAliases = {
    ["my rap beat"] = "1234567890",
}
```

Use only audio assets approved for the experience. Roblox games cannot download arbitrary YouTube, Spotify, SoundCloud, or local audio files during play. This script also does not separate an existing song into kick, snare, bass, or vocal tracks. The beat clock creates timing signals from the selected BPM.

Implemented features:

- Server authoritative song requests and BPM values
- Looping Roblox `Sound` playback
- 16 step beat timing
- Accent signals on steps 1 and 9
- Roblox asset ID and common URL parsing
- Configurable name based song aliases
- BPM validation from 60 through 180
- Request throttling
- Client status messages and beat feedback

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/687bbcf7-5dbd-4e6f-b493-6673f8c2e0f1?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=687bbcf7-5dbd-4e6f-b493-6673f8c2e0f1
