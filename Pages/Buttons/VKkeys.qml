import QtQuick 2.3

Rectangle {
    id: keyButton
    color: keyColor
    border.width: 2
    border.color: butBrdrColor
    radius: 4
    width: 50
    height: 50

    property color keyColor: "grey"
    property int keyBrdrWidth: keyButton.border.width
    property color butBrdrColor: Qt.darker("grey", 1.5)
    property color butHvrBrdrColor: Qt.darker("beige", 1.5)
    property alias keyText: textKey.text
    property alias keyTxtColor: textKey.color
    property alias keyTxtSz: textKey.font.pixelSize
    property alias keyTxtBold: textKey.font.bold   

    property int keyType: 0
    property bool setInvis: false
    property bool on: false


/*    // cursor manipulation included
    function doTyping2(field_id, key) {
        if (field_id === fieldID) { // this identifies the field to type in
            //console.log("  --field_id = " + field_id);

            var t_len = textedit.text.length
            var cursor_pos = textedit.cursorPosition

            console.log("txtEdit.text.len--cursor_pos = " + t_len + "-" +cursor_pos);

            if (key === "BACKSPACE" || key === "LEFT" || key === "RIGHT") {
                textedit.cursorVisible = true
                if (key === "BACKSPACE") {
                    textedit.remove((cursor_pos - 1), (cursor_pos))
                    textedit.cursorPosition = cursor_pos - 1
                }
                else if (key === "LEFT") {
                    textedit.cursorPosition = cursor_pos - 1
                }
                else if (key === "RIGHT") {
                    textedit.cursorPosition = cursor_pos + 1
                }
            }
            else if (key === "ENTER") {
                saveInput();
                keyboard.capsOn = false;
                //uiProcess.setCaps(false);
                textedit.cursorVisible = false;
                keyboard.state = "fadeOut";
                keyboard.defaultSwitch();
                keyboard.disableVKtimer.start();
                keyboardinput.forceActiveFocus();
            }
            else if (key === "SHIFT") {
                keyboard.alphaShift()
            }
            else if (key === "&123") {
                keyboard.numSwitch()
            }
            else if (key === "ABC") {
                keyboard.defaultSwitch()
            }
            else if (key === "FCT2" || key === "FCT3") {
                return; // placeholder for more functions
            }
            else if (key === "SPACE") {
                textedit.cursorVisible = true
                cursor_pos = textedit.cursorPosition
                textedit.insert(cursor_pos, " ")
                textedit.cursorPosition = cursor_pos + 1
            }
            else {
                textedit.cursorVisible = true
                cursor_pos = textedit.cursorPosition
                textedit.insert(cursor_pos, key)
                textedit.cursorPosition = cursor_pos + 1
            }
        }
    }
*/

    // --------  fade in and out the actual text when doing the switch - disabled below
        // when switching, quickly fade out the text on the same timer as <from: "off"; to: "on">
        //   and fade the new chars in on <from: "on"; to: "off"> but maybe a bit longer
    function setInvisible() {
        if (setInvis === true) {
            keyColor = "transparent";
            butBrdrColor = "transparent";
            butHvrBrdrColor = "transparent";
            keyMouseArea.enabled = false;
        }
    }
    function toggle() {        
        if (keyButton.state === "on") {
            keyButton.state = "off";            
            //console.log("keyButton off");
        }
        else {
            keyButton.state = "on";
            //console.log("keyButton on");
        }
    }
    states: [
        State {
            name: "on"
            PropertyChanges { target: keyButton; on: true; color: Qt.darker("grey", .75); butBrdrColor: Qt.darker("beige", 2); keyTxtColor: "black" }
        },
        State {
            name: "off"
            PropertyChanges { target: keyButton; on: false; color: "grey"; butBrdrColor: Qt.darker("grey", 1.5); keyTxtColor: "white" }
        }
    ]
    transitions: [
        Transition {
            from: "off"; to: "on"
            ColorAnimation { target: keyButton; duration: 100; }
            //NumberAnimation { target: keyButton; properties: "color"; easing.type: Easing.OutExpo; duration: 1000; }
        },
        Transition {
            from: "on"; to: "off"
            ColorAnimation { target: keyButton; duration: 250; }
            //NumberAnimation { target: keyButton; properties: "color"; easing.type: Easing.OutExpo; duration: 1000; }
        }
    ]
    Timer { // for key shift effects - currently off
        id: keyTransitionTimer
        interval: 100
        onTriggered: {            
            toggle()
            //console.log("keyTransitionTimer")
        }
    }

    //  -----   most of this is for using shift/numlock/revert keys and effects
    signal caps(string s_char)
    signal numlock(string s_char)
    signal alphaswitch(string s_char)
    signal altswitch(string s_char) // with setting caps keys this may not be needed

    onCaps: {
        textKey.toggleShift(s_char)
    }
    onNumlock: {
        textKey.toggleNumSwitch(s_char)
    }
    onAlphaswitch: {
        textKey.toggleNumSwitch(s_char)
    }
    onAltswitch: {
        textKey.returnFunctionKeys(s_char)
    }

    Text {
        id: textKey
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 16
        font.bold: false
        text: "key"

        property bool shftOn: false
        property bool numOn: false

        function disableKey() {
            if (keyText === "") {
                keyMouseArea.enabled = false;
            }
            else {
                keyMouseArea.enabled = true;
            }
        }
        function returnFunctionKeys(s_key) {
            numOn = false;
            textKey.text = s_key;
            //keyTransitionTimer.start() // key shift effects off with comment
            //toggle()
            disableKey();
        }
        function toggleNumSwitch(s_key) {
            if (numOn === true) {
                textKey.state = "shftOff";
                numOn = false;
                textKey.text = s_key;             
                //keyTransitionTimer.start() // key shift effects off with comment
                //toggle()
            }
            else {
                numOn = true;
                textKey.text = s_key;
                //keyTransitionTimer.start()
                //toggle()
            }
            disableKey();
        }
        function toggleShift(s_key) {
            if (textKey.state === "shftOn") {
                textKey.state = "shftOff";
                textKey.text = s_key;
                //keyTransitionTimer.start() // key shift effects off with comment
                //toggle()
            }
            else {
                textKey.state = "shftOn";
                textKey.text = s_key;
                //keyTransitionTimer.start()
                //toggle()
            }
        }
        states: [
            State {
                name: "shftOn"
                PropertyChanges { target: textKey; shftOn: true; } // font.capitalization: Font.AllUppercase;
            },
            State {
                name: "shftOff"
                PropertyChanges { target: textKey; shftOn: false;  } // font.capitalization: Font.AllLowercase;
            }
        ]
    }
    MouseProp1 {
        id: keyMouseArea
        onEntered: doHover(3)
        onExited: doHover(4)
        onPressed: {
            recvKey(keyText);
        }
        onPressedChanged: {
            toggle(); // this works great for keypresses not on a timer
        }
        onClicked: {            
            //console.log(keyText);
        }
    }
    Component.onCompleted: { setInvisible(); }
}
