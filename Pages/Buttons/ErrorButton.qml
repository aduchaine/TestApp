import QtQuick 2.3

ButtonProp1 {
    id: buttonError
    width: 250
    height: 100
    radius: 10
    butColor: "lightgrey"
    butHvrBrdrColor: "black"
    anchors.centerIn: parent
    butTxt: {"Data invalid.\nPlease check your input." } // this is done first
    butTxtColor: "red"

    property bool on: false

    function changeText(string) {
        butTxt = string;
    }
    function toggle(nodata) {
        if (nodata === true) {
            errorTimer.start();
            buttonError.state = "on";
            return;
        }
        if (buttonError.state == "on") {
            buttonError.state = "off";
            errorTimer.stop();
            buttonError.changeText("Data invalid.\nPlease check your input.")
            //console.log("off");
        }
        else {
            errorTimer.start();
            buttonError.state = "on";
            //console.log("on");
        }
    }
    states: [
        State {
            name: "on"
            PropertyChanges { target: buttonError; on: true; visible: true; z:1000 }
        },
        State {
            name: "off"
            PropertyChanges { target: buttonError; on: false; visible: false }
        }
    ]
    MouseProp1 {
        onClicked: {
            toggle()
            errorTimer.stop()
            buttonError.changeText("Data invalid.\nPlease check your input.")
        }
    }
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: {
            toggle()
            buttonError.changeText("Data invalid.\nPlease check your input.")
        }
    }
    Component.onCompleted: visible = false
}
