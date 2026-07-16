pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

Singleton {
    id: root
    readonly property bool ready: Pipewire.ready
    readonly property var sinks: ready ? Pipewire.nodes.values.filter(node => node.isSink && !node.isStream) : []
    readonly property var sources: ready ? Pipewire.nodes.values.filter(node => !node.isSink && !node.isStream) : []
    readonly property var streams: ready ? Pipewire.nodes.values.filter(node => node.isStream) : []

    readonly property PwNode defaultSink:  ready ? Pipewire.defaultAudioSink : null
    readonly property PwNode defaultSource:ready ? Pipewire.defaultAudioSource : null

    readonly property var players: Mpris.players

    PwObjectTracker {
        objects: [...sinks, ...sources, ...streams]
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
}
