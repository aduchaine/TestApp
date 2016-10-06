import QtQuick 2.3
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: content4buttons

    property int pageID
    property int responseID

    pageID: 6

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "In id magna sit amet nibh suspicit euismod.Integer enim. Donec sapien ante, accumsan ut,sodales commodo, auctor quis, lacus."      
        textID: 9
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    ColumnLayout {
        Layout.alignment : Qt.AlignHCenter
        spacing: 20

        GreyButton {
            id: but1
            butTxt: "Yes"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 10
            responseID: 12 // all responseID will need to get changed or in these types of fields, send the position value starting at 0
        }
        GreyButton {
            id: but2
            butTxt: "No"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 10
            responseID: 13
        }
        GreyButton {
            id: but3
            butTxt: "Maybe"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 10
            responseID: 14
        }
        GreyButton {
            id: but4
            butTxt: "No means Yes"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 10
            responseID: 15
        }
    }
    Spacer { boxHeight: butprev.height * .5; opacity: .0}
    RowLayout {
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
        spacing: 20

        PreviousButton {
            id:butprev
        }
        NextButton {
            id: nbutton
        }
    }
    Connections {
        target: uiProcess

        onValidData: {
            nbutton.color = Qt.darker("tan", 1.2);
        }
        onNoData: {
            nbutton.color = Qt.darker("green", .8);
        }
        onPreviousPage: {
            butprev.color = Qt.darker("yellow", .7);
        }
    }
    KeyboardProp1 {
        id: keyproppage6
    }
    Component.onCompleted: {
        uiProcess.sendPromptData(pageID);
        uiProcess.sendFieldData(pageID);
        buttonQuit.visible = true;
        uiProcess.getNextData(pageID);
        if (buttonError.state === "on") {
            buttonError.toggle();
        }
        uiProcess.pageNum = pageID;
        keyproppage6.forceActiveFocus();
    }
}
