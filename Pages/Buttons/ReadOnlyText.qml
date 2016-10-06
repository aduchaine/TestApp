import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: rotextBox
    color: "transparent"

    Layout.leftMargin: 30
    Layout.rightMargin: 30
    Layout.fillWidth : true
    Layout.fillHeight : true

    property alias txtBox: rotextBox
    property alias txtBoxColor: rotextBox.color
    property alias txtProp: justText    
    property alias txtText: justText.text
    property alias txtSize: justText.font.pixelSize
    property alias txtBold: justText.font.bold
    property alias txtColor: justText.color
    property alias txtWrap: justText.wrapMode

    property int textID                   // text field ID - possibly the question ID

    Connections {
        target: uiProcess
        onSendToPrompt: {
            getPromptData(n_data, str_data);
        }
    }
    // probably need to define text size based on char#
    function getPromptData(text_id, string_data) {
        if (text_id === textID) {
            txtText = string_data;
        }
    }

    Text {        
        id: justText
        horizontalAlignment: Text.AlignHCenter
        anchors {
            left: parent.left
            right: parent.right
        }        
        opacity: 1
        font.bold: false
        font.pixelSize: 20
        wrapMode: Text.WordWrap        
        color: "black"
        text: "justText"
    }
}
