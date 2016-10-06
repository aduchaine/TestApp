import QtQuick 2.7
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: contentpagetestrow

    property int pageID
    property int responseID

    pageID: 3

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin pharetra nonummy pede. Mauris et orci."
        textID: 6
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    RowLayout {
        Layout.alignment: Qt.AlignHCenter     
        spacing: 25

        GreyButton {
            id: but1
            butTxt: "Yes"
            fieldID: 7
            responseID: 4
        }
        GreyButton {
            id: but2
            butTxt: "No"
            fieldID: 7
            responseID: 5
        }
        GreyButton {
            id: but3
            butTxt: "Maybe"
            fieldID: 7
            responseID: 6
        }
    }
    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
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
        id: keyproppage3        
    }
    Component.onCompleted: {        
        uiProcess.sendPromptData(pageID);
        uiProcess.sendFieldData(pageID);
        uiProcess.getNextData(pageID);
        if (buttonError.state === "on") {
            buttonError.toggle();
        }
        uiProcess.pageNum = pageID;
        keyproppage3.forceActiveFocus();
    }
}
