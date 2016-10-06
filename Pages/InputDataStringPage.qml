import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: pageinputname  

    property int pageID
    property int responseID

    pageID: 1


    // see "TesMultInputPage.qml"
    // TAB interpage navigation - these could possibly go in a different qml where all app menus could be processed in this way
    signal navigateSideways(int field_id);
    onNavigateSideways: {
        switch(field_id) {
        case 1:
            txt2.txtLine.cursorVisible = true;
            txt2.txtLine.forceActiveFocus();
            break;
        case 2:
            txt1.txtLine.cursorVisible = true;
            txt1.txtLine.forceActiveFocus();
            break;
        }
    }
    // this is a good way to do it in one spot for variable input
    signal savepageInput ()
    onSavepageInput: {
        txt1.saveInput()
        txt2.saveInput()
    }

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "" // "Please enter your name."
        txtSize: 24
        txtColor: "beige"
        textID: 4
    }
    Spacer { boxHeight: butprev.height * .5; opacity: .0}
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 25  

        anchors {
            bottom: spacer2.top
        }

        SLText {
            id: txt1
            fieldID: 1
            inputStatus: 0
            responseID: 2
            txlLabelTxt: "first name, mi"

            // VKboard integration
            txtLine.onFocusChanged: {
                if (stackView.vkEnabled === true) {
                    if (txt2.txtLine.cursorVisible === true) {
                        txt2.txtLine.cursorVisible = false
                        txt2.saveInput()
                    }
                    txt1.txtLine.cursorVisible = true;
                    txtBuffer.setVKboard(fieldID)
                    nbutton.mouseNext.enabled = false;
                    butprev.mousePrev.enabled = false;
                }
            }
        }
        SLText {
            id: txt2
            fieldID: 2
            inputStatus: 0
            responseID: 2
            txlLabelTxt: "last name"

            // VKboard integration
            txtLine.onFocusChanged: {
                if (stackView.vkEnabled === true) {
                    if (txt1.txtLine.cursorVisible === true) {
                        txt1.txtLine.cursorVisible = false
                        txt1.saveInput()
                    }
                    txt2.txtLine.cursorVisible = true;
                    txtBuffer.setVKboard(fieldID)
                    nbutton.mouseNext.enabled = false;
                    butprev.mousePrev.enabled = false;
                }                
            }
        }
    }
    Spacer { id: spacer2; boxHeight: butprev.height * 2; opacity: .0}
    RowLayout {
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
        spacing: 20

        PreviousButton {
            id:butprev
        }
        NextButton {
            id: nbutton

            mouseNext.onClicked: {
                savepageInput()
            }
        }
    }
    Connections {
        target: stackView

        // VKboard signal
        onShowLine: {
            switch(field_id) {
            case 1:
                //console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                txt1.doVKfill(field_id, c_pos, k_text);
                break;
            case 2:
                //console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                txt2.doVKfill(field_id, c_pos, k_text);
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
                txt1.txtLine.cursorVisible = false;
                txt2.txtLine.cursorVisible = false;
                keyproppage1.forceActiveFocus();
                nbutton.mouseNext.enabled = true;
                butprev.mousePrev.enabled = true;
            }
        }
        onStringData: {
            switch(str_pos) { // str_pos = fieldID
            case 1:
                txt1.textChange(str_data, str_pos);
                break;
            case 2:
                txt2.textChange(str_data, str_pos);
                break;
            }
        }
        onValidData: {
            nbutton.color = Qt.darker("tan", 1.2);
        }
        onInvalidData: {
            nbutton.color = Qt.darker("green", .8);
            buttonError.changeText("Invalid name.\nPlease check your input.")
        }
        onPreviousPage: {
            butprev.color = Qt.darker("yellow", .7);
        }       
    }

    KeyboardProp1 {
        id: keyproppage1
        Keys.onRightPressed: {
            savepageInput()
        }
    }
    Component.onCompleted: {
        //console.log("  **onCompleted** page:1 ? (" + pageID + ")")
        uiProcess.sendPromptData(pageID);
        uiProcess.getNextData(pageID);
        if (buttonError.state === "on") {
            buttonError.toggle();
        }
        uiProcess.pageNum = pageID;
        keyproppage1.forceActiveFocus();
    }
}
