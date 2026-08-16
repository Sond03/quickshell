import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    property string exclusion: ""
    property bool kbFocus: false
    property string nameSpace: "undefined.qs"
    property string layerName: ""

    implicitWidth: 600
    implicitHeight: 600
    WlrLayershell.layer: validLayerNames(layerName)
    WlrLayershell.namespace: nameSpace
    exclusionMode: validExclusion(exclusion)
    WlrLayershell.keyboardFocus: kbFocus ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    color: "transparent"

    function validLayerNames(layerName) {
        switch(layerName.toLowerCase()){
            case "overlay":
            return WlrLayer.Overlay;
            case "top":
            return WlrLayer.Top;
            case "background":
            return WlrLayer.Background;
            case "bottom":
            return WlrLayer.Bottom;
            default:
            return WlrLayer.Top;
        }
    }
    function validExclusion(exclusion){
        switch(exclusion.toLowerCase()){
            case "auto":
            return ExclusionMode.Auto;
            case "ignore":
            return ExclusionMode.Ignore;
            case "normal":
            return ExclusionMode.Normal;
            default: 
            return ExclusionMode.Auto;
        }
    }
}
