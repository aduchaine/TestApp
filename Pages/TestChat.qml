import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: pageinputname

    property int pageID

    // this will be used to send messages
    signal savepageInput ()
    onSavepageInput: {
     //   txt1.saveInput()
     //   txt2.saveInput()
    }

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "chat dialog"
        txtSize: 24
        txtColor: "beige"
    }
    Spacer { id: topchat ; boxHeight: butprev.height * 1.5; opacity: .0}
    WriteLineText {
        id: chatin
        inputStatus: 3 // does not recv user input
        txlTxtSz: 14
        txtLine.readOnly:  true
        Layout.alignment : Qt.AlignHCenter

        Layout.minimumWidth: 250
        Layout.preferredWidth: 350
        Layout.maximumWidth: 450
        Layout.minimumHeight: 250
        Layout.preferredHeight: 300
        Layout.maximumHeight: 350

        Layout.fillWidth: true
        Layout.fillHeight: true

        txlLabelTxt: "incoming messages"
    }
    Spacer { boxHeight: butprev.height * .25; opacity: .0}
    WriteLineText {
        id: chatout
        fieldID: 3
        inputStatus: 2 // chat messages
        txlTxtSz: 14
        txlLabelTxt: "outgoing messages"
        Layout.alignment : Qt.AlignHCenter

        Layout.minimumWidth: 250
        Layout.preferredWidth: 350
        Layout.maximumWidth: 450
        Layout.minimumHeight: 40
        Layout.preferredHeight: 70
        Layout.maximumHeight: 100

        // VKboard integration
        txtLine.onFocusChanged: {
            if (stackView.vkEnabled === true) {
                if (chatout.txtLine.cursorVisible === true) {
                    chatout.txtLine.cursorVisible = false
                    //chatout.saveInput()
                }
                //  txt2.txtLine.cursorVisible = true;
                txtBuffer.setVKboard(fieldID)
                nbutton.mouseNext.enabled = false;
                butprev.mousePrev.enabled = false;
            }
        }
    }

    Spacer { id: spacer2; boxHeight: butprev.height * 1; opacity: .0}
    RowLayout {
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
        spacing: 20

        PreviousButton {
            id:butprev
        }
        NextButton {
            id: nbutton

            mouseNext.onClicked: {
             //   savepageInput()
            }
        }
    }
    Connections {
        target: stackView

        // VKboard signal
        onShowLine: {
            switch(field_id) {
            case 3:
                console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                chatout.doVKfill(field_id, c_pos, k_text);
                break;
            case 2:
                //console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                chatout.doVKfill(field_id, c_pos, k_text);
                break;
            }
        }
    }
    Connections {
        target: uiProcess

        // VKboard signal - eventually turn this into a switch for multiple page input
        onSendFocusType: {
            //console.log("onSendFocusType: type: " + s_data);
            if (s_data == 1) { // s_data = focus type; 1 = page focus
                chatout.txtLine.cursorVisible = false;
                keyproppagechat.forceActiveFocus();
                nbutton.mouseNext.enabled = true;
                butprev.mousePrev.enabled = true;
            }
        }
        onStringData: { // use in conjunction with "uiProcess.getNextData(pageID);" but call it something  different
            switch(str_pos) { // str_pos = fieldID
            case 3:
                chatout.textChange(str_data, str_pos);
                break;
            case 4:
                //txt2.textChange(str_data, str_pos);
                break;
            }
        }
        onValidData: { // use for navigation
            nbutton.color = Qt.darker("tan", 1.2);
        }
        onPreviousPage: {
            butprev.color = Qt.darker("yellow", .7);
        }
    }

    KeyboardProp1 {
        id: keyproppagechat
        Keys.onRightPressed: {
         //   savepageInput()
        }
    }
    Component.onCompleted: {
        if (buttonError.state === "on") {
            buttonError.toggle();
        }

        //stackvCol.genericROTxt1.visible = false;

        keyproppagechat.forceActiveFocus();
    }
}
