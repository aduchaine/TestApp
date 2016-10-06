import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: spacer
    color: "red"
    opacity: .25
    width: boxWidth
    height: boxHeight

    Layout.fillWidth : true
    Layout.fillHeight : true

    property int boxWidth: spacer.width
    property int boxHeight: spacer.height
    property alias boxColor: spacer.color
    property alias boxProp: spacer
    property alias boxtxtVisible: spacerText.visible

    Text {
        id: spacerText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        color: "black"
        font.pixelSize: 36
        font.bold: false
        text: spacer.width + " width-height " + spacer.height
    }
}
