pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

Singleton {
    id: root
    readonly property bool ready: Pipewire.ready
    readonly property var sinks: ready ? Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && mprisAndSink(node)) : []
    readonly property var sources: ready ? Pipewire.nodes.values.filter(node => !node.isSink && !node.isStream) : []
    readonly property var streams: ready ? Pipewire.nodes.values.filter(node => node.isStream && mprisAndSink(node)) : []

    readonly property PwNode defaultSink:  ready ? Pipewire.defaultAudioSink : null
    readonly property PwNode defaultSource: ready ? Pipewire.defaultAudioSource : null

    readonly property var players: Mpris.players.values

    readonly property var trackedNodes:[
        defaultSink,
        defaultSource,
        ...streams, 
        ...sources, 
        ...sinks
    ].filter(node => node && mprisAndSink(node))

    PwObjectTracker {
        objects: trackedNodes
    }

    function volumeIcon(node) {
        if (!node || !node.audio) {
            return "󰝟"
        }
        if (node.audio.muted || node.audio.volume === 0) {
            return "󰝟"
        }
        if (node.audio.volume < 0.25){
            return "󰕿"
        }
        if (node.audio.volume < 0.66){
            return "󰖀"
        } 
        return "󰕾"
    }
    function mprisAndSink(node){
        return !players.some(player => {
            const target = (player.desktopEntry || player.identity || "").toLowerCase()
            return (
                (node.description || "").toLowerCase() === target ||
                (node.nickname || "").toLowerCase() === target ||
                (node.name || "").toLowerCase() === target
            )
        })    
    }
}
