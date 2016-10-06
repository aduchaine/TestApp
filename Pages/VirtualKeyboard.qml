import QtQuick 2.7
import QtQuick.Layouts 1.3
import UIProcess 1.0
import "Buttons/"

Rectangle {
    id: keyboardLayout
    width: initialWidth
    height: 260 //initialHeight
    color: backgroundColor
    border.color: borderColor
    border.width: 5
    radius: 16
    opacity: 0
    visible: false
    z: 100    

    anchors {
        left: parent.left
        right: parent.right
      // bottom: parent.bottom
    }
    gradient: Gradient {
        GradientStop { position: 0; color: backgroundColor }
        GradientStop { position: 1; color: Qt.darker(backgroundColor, 2) }
    }

    property int initialWidth: 560
    property int initialHeight: 260
    property color backgroundColor: Qt.darker("darkgrey", 1.5)
    property color borderColor: Qt.darker("beige", 1.5)

    property bool capsOn: false
    property alias disableVKtimer: disableVKTimer
    property alias disableVKduration: disableVKTimer.interval

    property int fieldID: 0
    property variant fieldcharArray: new Array()
    property int bufferLength: 0
    property int cursorPos: 0
    property bool exceedMaxChar: false

    states: [
        State {
            name: "fadeIn"
            PropertyChanges { target: keyboardLayout; opacity: 1; anchors.bottom: fieldID === 3 ? null : parent.bottom; }
        },
        State {
            name: "fadeOut"
            PropertyChanges { target: keyboardLayout; opacity: 0; anchors.bottom: fieldID === 3 ? null : parent.bottom; }
        }
    ]
    transitions: Transition {       
        NumberAnimation { target: keyboardLayout; properties: "opacity"; easing.type: Easing.OutExpo; duration: disableVKduration * 3; }
    }
    Timer {
        id: disableVKTimer
        interval: 750
        onTriggered: {
            keyboardLayout.visible = false            
            //console.log("disableVKTimer")
        }
    }

    signal recvKey(string keyTxt)
    signal sendFieldID(int fieldID) // this seems redundant

    onRecvKey: {
        uiProcess.pi_data2 = fieldID;
        uiProcess.processVKey(keyTxt)
    }
    onSendFieldID: {
        getFieldID(fieldID);
    }

    function getFieldID(fID) {
        if (fieldID !== fID) {
            uiProcess.setCaps(false);
            defaultSwitch();
        }
        fieldID = fID;
    }

    // a different option to this is to gain access to the text edit field somehow and "doTyping" there    

    // keyboard output function
    // cursor manipulation included
    function doTyping(field_id, key) {
        if (field_id === fieldID) { // this identifies the field to type in
            var k_text;
            var c_pos;

            // 0 the array element of any amount over this number for each array element - the "client" will handle their own
            var max_len = getMaxFieldLength(field_id);

            txtBuffer.setCp = 0;
            txtBuffer.saveCp = 0;

            if (exceedMaxChar === true) {
                cursorPos = 0;
                exceedMaxChar = false;
            }

            if (key === "BACKSPACE" || key === "LEFT" || key === "RIGHT") {
                if (key === "BACKSPACE") {
                    if (bufferLength > 0) {
                        bufferLength -= 1;
                    }
                    if (cursorPos > 0) {
                        cursorPos -= 1;
                    }
                    k_text = "BACKSPACE";
                }
                else if (key === "LEFT") {
                    if (cursorPos > 0) {
                        cursorPos -= 1;
                    }
                    k_text = "LEFT";
                }
                else if (key === "RIGHT") {
                    if (cursorPos + 1 < bufferLength) {
                        cursorPos += 1;
                    }
                    k_text = "RIGHT";
                }
            }
            else if (key === "ENTER") {
                k_text = "ENTER";
                uiProcess.setCaps(false);
                state = "fadeOut";
                defaultSwitch();
                disableVKtimer.start();
                stackView.lockInput(true);
                uiProcess.setFocus(1);
            }
            else if (key === "SHIFT") {
                alphaShift(capsOn)
            }
            else if (key === "&123") {
                numSwitch()
            }
            else if (key === "ABC") {
                defaultSwitch()
            }
            else if (key === "FCT2" || key === "FCT3") {
                return; // placeholder for more functions
            }
            else if (key === "SPACE") {
                cursorPos += 1;
                bufferLength += 1;
                k_text = " ";
            }
            else {
                cursorPos += 1;
                bufferLength += 1;
                k_text = key;
            }

            if (bufferLength >= max_len) {
                bufferLength = 0;
                exceedMaxChar = true;
            }

            c_pos = cursorPos;

            //console.log("dotyping: field_id, pos, key " + field_id + "-" + c_pos + "-" + k_text);
            dotyping(field_id, c_pos, k_text);
        }
    }  
    function setCursorPosition(field_id) {
        if (txtBuffer.setCp > 0) {
            return;
        }
        if (fieldID < 1) {
            return;
        }
        if (fieldcharArray[field_id] > 0) { // possible issue here
            bufferLength = fieldcharArray[fieldID];
        }
        fieldcharArray[fieldID] = bufferLength; // this may be redundant

        cursorPos = bufferLength;

        console.log("setCursorPosition: pos " + cursorPos);

        txtBuffer.setCp++;
    }
    function saveBufferLength() {
        if (txtBuffer.saveCp > 0) {
            return;
        }
        if (fieldID < 1) {
            return;
        }
        fieldcharArray[fieldID] = bufferLength;

        bufferLength = 0;
        cursorPos = 0;
        exceedMaxChar = false;
        txtBuffer.saveCp++;
    }
    function getMaxFieldLength(field_id) {
        var max_len = 0;
        if (field_id > 0) {
            max_len = 20;
            // max_len is # of characters and add 1 because it erases when exceeded not at
            // the client will do 1 key press beyond max which erases that and the other 5 and goes to 0 char/cursor pos
            // so, max 5 actually means 6 typed cur_pos 6 then back to 0 after tha occurs don't send updated cur_pos until after
        }
        return max_len + 1;
    }


    function alphaShift(caps_on) {
        if (caps_on === true) {
            key1.caps("q"); key2.caps("w"); key3.caps("e"); key4.caps("r"); key5.caps("t"); key6.caps("y"); key7.caps("u"); key8.caps("i"); key9.caps("o");
            key10.caps("p"); key11.caps("a"); key12.caps("s"); key13.caps("d"); key14.caps("f"); key15.caps("g"); key16.caps("h"); key17.caps("j"); key18.caps("k");
            key19.caps("l"); key20.caps("z"); key21.caps("x"); key22.caps("c"); key23.caps("v"); key24.caps("b"); key25.caps("n"); key26.caps("m");
            capsOn = false;
        }
        else if (caps_on === false) {
            key1.caps("Q"); key2.caps("W"); key3.caps("E"); key4.caps("R"); key5.caps("T"); key6.caps("Y"); key7.caps("U"); key8.caps("I");
            key9.caps("O"); key10.caps("P"); key11.caps("A"); key12.caps("S"); key13.caps("D"); key14.caps("F"); key15.caps("G"); key16.caps("H");
            key17.caps("J"); key18.caps("K"); key19.caps("L"); key20.caps("Z"); key21.caps("X"); key22.caps("C"); key23.caps("V"); key24.caps("B");
            key25.caps("N"); key26.caps("M");
            capsOn = true;
        }
        //uiProcess.setCaps(capsOn);
        //console.log("alphaShift caps = " + capsOn);
    }
    function defaultSwitch() {
        key1.alphaswitch("q"); key2.alphaswitch("w"); key3.alphaswitch("e"); key4.alphaswitch("r"); key5.alphaswitch("t"); key6.alphaswitch("y");
        key7.alphaswitch("u"); key8.alphaswitch("i"); key9.alphaswitch("o"); key10.alphaswitch("p"); key11.alphaswitch("a"); key12.alphaswitch("s");
        key13.alphaswitch("d"); key14.alphaswitch("f"); key15.alphaswitch("g"); key16.alphaswitch("h"); key17.alphaswitch("j"); key18.alphaswitch("k");
        key19.alphaswitch("l"); key20.alphaswitch("z"); key21.alphaswitch("x"); key22.alphaswitch("c"); key23.alphaswitch("v");
        key24.alphaswitch("b"); key25.alphaswitch("n"); key26.alphaswitch("m");
        keyShift2.altswitch("SHIFT"); keyFct1.altswitch("&123"); keyShift1.altswitch("SHIFT"); keyFct2.altswitch("FCT2"); keyFct3.altswitch("FCT3");
        capsOn = false;
        //uiProcess.setCaps(capsOn)
        //console.log("defaultSwitch caps = " + capsOn)
    }
    function numSwitch() {
        key1.numlock("1"); key2.numlock("2"); key3.numlock("3"); key4.numlock("4"); key5.numlock("5"); key6.numlock("6"); key7.numlock("7");
        key8.numlock("8"); key9.numlock("9"); key10.numlock("0"); key11.numlock("<"); key12.numlock(">"); key13.numlock("/"); key14.numlock("-");
        key15.numlock("="); key16.numlock("+"); key17.numlock("*"); key18.numlock("("); key19.numlock(")"); key20.numlock("!"); key21.numlock("@");
        key22.numlock("#"); key23.numlock("$"); key24.numlock("%"); key25.numlock("^"); key26.numlock("&");
        keyShift2.numlock("\""); keyFct1.numlock("ABC"); keyShift1.numlock(""); keyFct2.numlock(""); keyFct3.numlock("");
        capsOn = false;
        //uiProcess.setCaps(capsOn)
        //console.log("numSwitch caps = " + capsOn)
    }
    ColumnLayout {
        id: keyLayout
        spacing: 2
        Layout.margins: 10

        anchors {
            left: parent.left
            right: parent.right
            centerIn: parent
        }

        RowLayout {
            id: toprowKeys
            spacing: 2

            VKkeys { // VKnoKey
                id: keyInvis1
                width: 7
                setInvis: true
                keyText: ""
            }
            VKkeys {
                id: key1
                keyType: 1
                keyText: "q"
            }
            VKkeys {
                id: key2
                keyType: 1
                keyText: "w"
            }
            VKkeys {
                id: key3
                keyType: 1
                keyText: "e"
            }
            VKkeys {
                id: key4
                keyType: 1
                keyText: "r"
            }
            VKkeys {
                id: key5
                keyType: 1
                keyText: "t"
            }
            VKkeys {
                id: key6
                keyType: 1
                keyText: "y"
            }
            VKkeys {
                id: key7
                keyType: 1
                keyText: "u"
            }
            VKkeys {
                id: key8
                keyType: 1
                keyText: "i"
            }
            VKkeys {
                id: key9
                keyType: 1
                keyText: "o"
            }
            VKkeys {
                id: key10
                keyType: 1
                keyText: "p"
            }
            VKkeys { // wide
                id: keywide1
                width: 85
                keyTxtSz: 12
                keyText: "BACKSPACE"
            }
            //Component.onCompleted: { console.log("VirtualKeyboard toprowKeys width-height " + toprowKeys.width + "-" + toprowKeys.height) }
        }
        RowLayout {
            id: middlerow1Keys
            spacing: 2

            VKkeys { // VKnoKey
                id: keyInvis2
                width: 25
                setInvis: true
                keyText: ""
            }
            VKkeys {
                id: key11
                keyType: 1
                keyText: "a"
            }
            VKkeys {
                id: key12
                keyType: 1
                keyText: "s"
            }
            VKkeys {
                id: key13
                keyType: 1
                keyText: "d"
            }
            VKkeys {
                id: key14
                keyType: 1
                keyText: "f"
            }
            VKkeys {
                id: key15
                keyType: 1
                keyText: "g"
            }
            VKkeys {
                id: key16
                keyType: 1
                keyText: "h"
            }
            VKkeys {
                id: key17
                keyType: 1
                keyText: "j"
            }
            VKkeys {
                id: key18
                keyType: 1
                keyText: "k"
            }
            VKkeys {
                id: key19
                keyType: 1
                keyText: "l"
            }
            VKkeys { // wide
                id: keySpec1
                keyText: "'"
            }
            VKkeys { // wide
                id: keywide2
                width: 85
                keyTxtSz: 12
                keyText: "ENTER"
            }
            //Component.onCompleted: { console.log("VirtualKeyboard middlerow1Keys width-height " + middlerow1Keys.width + "-" + middlerow1Keys.height) }
        }
        RowLayout {
            id: middlerow2Keys
            spacing: 2

            VKkeys { // wide
                id: keyShift1
                keyType: 0
                keyTxtSz: 12
                keyText: "SHIFT"
            }
            VKkeys {
                id: key20
                keyType: 1
                keyText: "z"
            }
            VKkeys {
                id: key21
                keyType: 1
                keyText: "x"
            }
            VKkeys {
                id: key22
                keyType: 1
                keyText: "c"
            }
            VKkeys {
                id: key23
                keyType: 1
                keyText: "v"
            }
            VKkeys {
                id: key24
                keyType: 1
                keyText: "b"
            }
            VKkeys {
                id: key25
                keyType: 1
                keyText: "n"
            }
            VKkeys {
                id: key26
                keyType: 1
                keyText: "m"
            }
            VKkeys { // wide
                id: keySpec2
                keyText: ","
            }
            VKkeys { // wide
                id: keySpec3
                keyText: "."
            }
            VKkeys { // wide
                id: keySpec4
                keyText: "?"
            }
            VKkeys { // wide
                id: keyShift2
                keyType: 0
                keyTxtSz: 12
                keyText: "SHIFT"
            }
            //Component.onCompleted: { console.log("VirtualKeyboard middlerow2Keys width-height " + middlerow2Keys.width + "-" + middlerow2Keys.height) }
        }
        RowLayout {
            id: bottomrowKeys
            spacing: 2

            VKkeys { // VKnoKey
                id: keyInvis3
                width: 10
                setInvis: true
                keyText: ""
            }
            VKkeys { // wide
                id: keyFct1
                width: 75
                keyText: "&123"
            }
            VKkeys { // wide
                id: keyFct2
                keyType: 0
                keyTxtSz: 12
                keyText: "FCT2"
            }
            VKkeys { // spacebar
                id: keySpace
                width: 295
                keyText: "SPACE"
            }
            VKkeys { // wide
                id: keySpec5
                keyTxtSz: 12
                keyText: "LEFT"
            }
            VKkeys { // wide
                id: keySpec6
                keyTxtSz: 12
                keyText: "RIGHT"
            }
            VKkeys { // wide
                id: keyFct3
                keyType: 0
                keyTxtSz: 12
                keyText: "FCT3"
            }
            //Component.onCompleted: { console.log("VirtualKeyboard bottomrowKeys width-height " + bottomrowKeys.width + "-" + bottomrowKeys.height) }
        }
        //Component.onCompleted: { console.log("VirtualKeyboard keyLayout width-height " + keyLayout.width + "-" + keyLayout.height) }
    }

    Text {
        horizontalAlignment: Text.AlignHCenter
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        padding: 5
        color: "white"
        font.pixelSize: 16
        font.bold: false
        opacity: .5
        text: "test mini keyboard"
    }
    Text {
        horizontalAlignment: Text.AlignHCenter
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        padding: 5
        color: "white"
        font.pixelSize: 16
        font.bold: false
        opacity: .5
        text: "test mini keyboard"
    }
    Keys.onPressed: {
        //console.log(" VKey:  Keypress-- ")
    }
    //Component.onCompleted: { console.log("VirtualKeyboard keyboardLayout width-height " + keyboardLayout.width + "-" + keyboardLayout.height) }
    Keys.onEscapePressed: {
        capsOn = false;
        uiProcess.setCaps(false);
        keyboardLayout.state = "fadeOut";
        keyboardLayout.defaultSwitch();
        disableVKTimer.start();
        stackView.lockInput(true);
        uiProcess.setFocus(1);
    }
}
