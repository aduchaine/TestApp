import QtQuick 2.3

ButtonProp1 {
    id: buttonPrevious
    radius: 24
    butTxt: "Previous"
    butColor: "lightblue"

    property alias mousePrev: mouseareaPrevious

    MouseProp1 {
        id: mouseareaPrevious
        onEntered: doHover(3)
        onExited: doHover(4)
        onClicked: {
            uiProcess.getPreviousPage(uiProcess.pageNum);
            //console.log("PreviousButton: MouseProp1 onClicked signal - > page# " + pageID);
        }
    }
}
