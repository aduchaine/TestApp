import QtQuick 2.3
import QtQuick.Layouts 1.3

ButtonProp1 {
    id: vktoggleButton
    radius: 16
    butColor: Qt.darker("yellow", .8)
    butTxt: "Keyboard Off"
    butTxtSz: 14

    Layout.maximumWidth: 130
    Layout.maximumHeight: 40

    property bool on: false

    function propertyChange(switch_on) {
        if (switch_on === true) {
            vktoggleButton.state = "on";
            stackView.vkEnabled = true;
        }
        else {
            vktoggleButton.state = "off";
            stackView.vkEnabled = false;
        }
    }
    function toggle() {
        if (vktoggleButton.state == "on") {
            vktoggleButton.state = "off";
            stackView.vkEnabled = false
            //console.log(stackView.vkEnabled + " vkEnabled")
        }
        else {
            vktoggleButton.state = "on";            
            stackView.vkEnabled = true
            //console.log(stackView.vkEnabled + " vkEnabled")
        }
    }
    states: [
        State {
            name: "on"
            PropertyChanges { target: vktoggleButton; on: true; color: Qt.darker("green", .8); butHvrBrdrColor: "yellow";
                butTxt: "Keyboard On"; butTxtColor: "white"; butTxtSz: 16; butTxtBold: true }
        },
        State {
            name: "off"
            PropertyChanges { target: vktoggleButton; on: false; color: "yellow"; butHvrBrdrColor: "green";
                butTxt: "Keyboard Off"; butTxtColor: "black"  ; butTxtSz: 14; butTxtBold: false }
        }
    ]

    MouseProp1 {
        onEntered: doHover(3)
        onExited: doHover(4)
        onClicked: { toggle() }
    }
}
