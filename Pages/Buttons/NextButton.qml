import QtQuick 2.3

ButtonProp1 {
    id: buttonNext
    radius: 24
    butTxt: "Next"
    butColor: Qt.darker("green", .8)

    property alias mouseNext: mouseareaNext

    MouseProp1 {
        id: mouseareaNext
        onEntered: doHover(3)
        onExited: doHover(4)
        onClicked: {
            keyinputStackView.processTimer.start();
            //console.log("NextButton: MouseProp1 onClicked signal")
        }
    }
}
