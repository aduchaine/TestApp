import QtQuick 2.3
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: contentpagebegin

    property int pageID
    property int responseID

    pageID: 0

    anchors {
        left: mainWindow.left
        right: mainWindow.right
    }

    function isVKenabled() {
        if (stackView.vkEnabled === true) {
            vkToggleButton.propertyChange(true);
        }
        else {
            vkToggleButton.propertyChange(false);
        }
    }

    Spacer { boxHeight: vkToggleButton.height; opacity: 0 }
    ReadOnlyText {
        txtText: "" //"Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus."
        txtSize: 24
        textID: 1
    }
    Spacer { boxHeight: vkToggleButton.height; opacity: 0 }
    ReadOnlyText {
        txtText: ""  //"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa."
        textID: 2
    }
    Spacer { boxHeight: vkToggleButton.height; opacity: 0 }
    ReadOnlyText {
        id: vkToggleInquiry
        txtText: "" //"If you wish to use the touch keyboard as the mode for text input, select the option below."
        textID: 3
    }
    Spacer { boxHeight: vkToggleButton.height * .5; opacity: 0 }
    RowLayout {
        Layout.alignment : Qt.AlignHCenter

        VKtoggle {
            id: vkToggleButton
        }
    }

    // -------  testing area  ------- //

    Spacer { boxHeight: vkToggleButton.height; opacity: 0; }
    NextButton {
        id: buttonStart        
        butColor: Qt.darker("blue", .7)
        butTxt: "Begin"
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
    }
    Connections {
        target: uiProcess        
        onValidData: {
            buttonStart.color = Qt.darker("green", .8)
        }
    }
    KeyboardProp1 {
        id: keyproppage0
    }

    Component.onCompleted: {
        //console.log("  **onCompleted** page:0 ? (" + pageID + ")")
        uiProcess.sendPromptData(pageID);
        isVKenabled();
        if (buttonError.state === "on") {
            buttonError.toggle()
        }
        uiProcess.pageNum = pageID;
        keyproppage0.forceActiveFocus();
    }
}
