import QtQuick 2.7
import "Buttons/"


Item {
    id: interpagenav

    function checkActiveFocus() { // this is for testing only and could take "menu_id" as a variable if done differently
        if (ddDays.kbpropDDmenu.activeFocus === true) { console.log("ActiveFocus   ddDays.kbpropDDmenu ") }
        else if (ddMonths.kbpropDDmenu.activeFocus === true) { console.log("ActiveFocus   ddMonths.kbpropDDmenu ") }
        else if (ac1Menu.txtEdit.activeFocus === true) { console.log("ActiveFocus   ac1Menu.txtEdit") }
        else if (ac2Menu.txtEdit.activeFocus === true) { console.log("ActiveFocus   ac2Menu.txtEdit") }
    }

    Connections {
        target: stackView

        // this is done for anything which accepts text input
        onSavepageInput: {
            switch(page_id) {
            case 1:
                txt1.saveInput()
                txt2.saveInput()
                break;
            case 2:
                ac1Menu.saveInput()
                ac2Menu.saveInput()
                break;
            }
        }
        // this could probably be better
        // TAB interpage navigation
        onNavigateSideways: {
            switch(field_id) {
            case 1:
                txt2.txtLine.cursorVisible = true;
                txt2.txtLine.forceActiveFocus();
                break;
            case 2:
                txt1.txtLine.cursorVisible = true;
                txt1.txtLine.forceActiveFocus();
                break;
            case 3:
                //ddDays.state = ""; // unecessary with closeMenu() signal
                ddDays.shownItem.color = ddMonths.shownItemColor
                ddMonths.state = "dropDown";
                ddMonths.shownItem.color = Qt.darker(ddMonths.shownItemColor, 1.25)
                ddMonths.kbpropDDmenu.forceActiveFocus()
                //checkActiveFocus()
                break;
            case 4:
                //ddMonths.state = "";
                ddMonths.shownItem.color = ddMonths.shownItemColor
                ac1Menu.txtEdit.cursorVisible = true;
                ac1Menu.txtEdit.forceActiveFocus();
                //checkActiveFocus()
                break;
            case 5:
                ac2Menu.txtEdit.cursorVisible = true;
                ac2Menu.txtEdit.forceActiveFocus();
                //checkActiveFocus()
                break;
            case 6:
                ddDays.state = "dropDown";
                ddDays.shownItem.color = Qt.darker(ddDays.shownItemColor, 1.25)
                ddDays.kbpropDDmenu.forceActiveFocus();
                //checkActiveFocus()
                break;
            }
        }
    }

    signal closeMenu(int field_id)
    onCloseMenu: {
        switch(field_id) {
        case 3:
            ddDays.state = "";
            break;
        case 4:
            ddMonths.state = "";
            break;
        case 5:
            ac1Menu.state = "";
            break;
        case 6:
            ac2Menu.state = "";
            break;
        }
    }


}
