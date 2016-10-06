import QtQuick 2.3
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: content2buttons

    property string nextPageURL: Qt.resolvedUrl("ContentPage4Buttons.qml")

    property int pageID
    property int responseID

    pageID: 5

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "At ipsum vitae est lacinia tincidunt. Maecenas elit orci,gravida ut, molestie non, venenatis vel, lorem. Sedlacinia. Suspendisse potenti. Sed ultricies cursuslectus."
        textID: 8
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    RowLayout {
        Layout.alignment : Qt.AlignHCenter
        spacing: 25

        GreyButton {
            id: but1
            butTxt: "Yes"
            fieldID: 9
            responseID: 10
        }
        GreyButton {
            id: but2
            butTxt: "No"
            fieldID: 9
            responseID: 11
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
        id: keyproppage5
    }
    Component.onCompleted: {
        uiProcess.sendPromptData(pageID);
        uiProcess.sendFieldData(pageID);
        uiProcess.getNextData(pageID);        
        if (buttonError.state === "on") {
            buttonError.toggle();
        }
        uiProcess.pageNum = pageID;
        keyproppage5.forceActiveFocus();
    }
}
