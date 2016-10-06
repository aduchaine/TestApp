import QtQuick 2.3
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: contentpagetestcol  

    property int pageID
    property int responseID

    pageID: 4

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "Fusce tincidunt, lorem nev dapibusconsectetuer, leo orci mollis ipsum, eget suscipit erospurus in ante."       
        textID: 7
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    ColumnLayout {
        Layout.alignment : Qt.AlignHCenter
        spacing: 20        

        GreyButton {
            id: but1
            butTxt: "Yes"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 8
            responseID: 7
        }
        GreyButton {
            id: but2
            butTxt: "No"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 8
            responseID: 8
        }
        GreyButton {
            id: but3
            butTxt: "Maybe"
            Layout.alignment : Qt.AlignHCenter
            fieldID: 8
            responseID: 9
        }
    }
    Spacer { boxHeight: butprev.height * .75; opacity: .0}
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
        id: keyproppage4        
    }
    Component.onCompleted: {
        uiProcess.sendPromptData(pageID);
        uiProcess.sendFieldData(pageID);
        uiProcess.getNextData(pageID);
        if (buttonError.state === "on") {
            buttonError.toggle();
        }
        uiProcess.pageNum = pageID;
        keyproppage4.forceActiveFocus();
    }
}
