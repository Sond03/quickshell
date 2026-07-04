pragma Singleton
import QtQuick 

QtObject{
    id: colors

    property color bg: "#1a1b26"
    property color fg: "#32344a"
    property color muted: "#444b6a"
    property color cyan: "#0db9d7"
    property color blue: "#7aa2f7"
    property color bgModules: "#1d1e2f"
    property color yellow: "#e0af68"
    property color crimson: "#DC143C"
    property color emerald: "#73daca"
    property color white: "#eeeeee"
    property color green:  "#9ece6a"
    property color orange: "#e0af68"
    property color red: "#f7768e"


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

}

