import QtQuick 2.3
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: contentpageend

    property int pageID
    property int responseID

    pageID: 7

    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    ReadOnlyText {
        txtText: "" // "remove quit from this last page so people don't think to click it and erase everything"
        textID: 10
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}    
    ReadOnlyText {
        txtText: "" // "Thank you message"
        txtSize: 24
        textID: 11
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    ReadOnlyText {
        txtText: "" // "Instructions to get on with your life now that you are done with this."
        textID: 12
    }
    Spacer { boxHeight: butprev.height * 1; opacity: .0}
    RowLayout {
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
        spacing: 20

        PreviousButton {
            id:butprev
        }
        NextButton {
            id: endbutton
            butColor: Qt.darker("blue", .7)
            butTxt: "Finish"                             
        }
    }
    Connections {
        target: uiProcess

        onValidData: {
            endbutton.color = Qt.darker("purple", .8);
        }
        onInvalidData: {
            buttonError.changeText("Invalid name.\nPlease check your input.")
        }
        onPreviousPage: {
            butprev.color = Qt.darker("yellow", .7);
        }
    }
    KeyboardProp1 {
        id: keyproppageEnd
    }
    Component.onCompleted: {
        //console.log("  **onCompleted** pg(" + pageID + ")");
        uiProcess.sendPromptData(pageID);
        buttonQuit.visible = false;
        if (buttonError.state === "on") {
            buttonError.toggle()
        }
        uiProcess.pageNum = pageID;
        keyproppageEnd.forceActiveFocus();
    }
}
