import QtQuick 2.3

ButtonProp1 {
    id: quitbutton
    width: 50
    height: 30
    radius: 10
    butTxt: "Quit"
    butColor: "pink"
    butBrdrColor: "white"
    butHvrBrdrColor: "black"

    MouseProp1 {
        onEntered: doHover(3)
        onExited: doHover(4)
        onClicked: {
            uiProcess.processQuit();
            console.log(butTxt + " clicked")
            Qt.quit()
        }
    }
}
