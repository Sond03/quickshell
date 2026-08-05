pragma Singleton
import QtQuick 

QtObject{
    id: colors

    property color bg: "#1a1b26"
    property color base: "#1e1e2e"
    property color border: "#11111b"
    property color border2: "#181825"
    property color surface1: "#45475a"
    property color overlay1: "#6c7086"
    property color fg: "#32344a"
    property color muted: "#444b6a"
    property color cyan: "#0db9d7"
    property color sapphire: "#74c7ec"
    property color sky: "#89dceb"
    property color blue: "#7aa2f7"
    property color cBlue: "#89b4fa"
    property color lavender: "#b4befe"
    property color purple: "#cba6f7"
    property color bgModules: "#1d1e2f"
    property color yellow: "#f9e2af"
    property color orange: "#fab387"
    property color red: "#f38ba8"
    property color crimson: "#DC143C"
    property color emerald: "#73daca"
    property color white: "#cdd6f4"
    property color green: "#a6e3a1"
    property color rose: "#f5e0dc"

    property color cpuLow: "#9ece6a"
    property color cpuMed: "#e0af68"
    property color cpuHigh: "#f7768e"
    property color cpuBar: "#2a2b3a"

    property color wsActive: "#2fbde7"
    property color wsPopulated: "#6f9eb7" 

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int tiny: 12
    property int small :14
    property int regular: 16
    property int large: 20
    property int huge: 24
}

