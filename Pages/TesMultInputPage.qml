import QtQuick 2.7
import QtQuick.Layouts 1.3
import "Buttons/"
import UIProcess 1.0

ColumnLayout {
    id: testdropdowns

    property int pageID
    property int responseID    

    pageID: 2

    // TAB interpage navigation - these could possibly go in a different qml where all app menus could be processed in this way
    function checkActiveFocus() { // this is for testing only and could take "menu_id" as a variable if done differently
            if (ddDays.kbpropDDmenu.activeFocus === true) { console.log("ActiveFocus   ddDays.kbpropDDmenu ") }
            else if (ddMonths.kbpropDDmenu.activeFocus === true) { console.log("ActiveFocus   ddMonths.kbpropDDmenu ") }
            else if (ac1Menu.txtEdit.activeFocus === true) { console.log("ActiveFocus   ac1Menu.txtEdit") }
            else if (ac2Menu.txtEdit.activeFocus === true) { console.log("ActiveFocus   ac2Menu.txtEdit") }
    }
    signal navigateSideways(int menu_id);
    onNavigateSideways: {
        switch(menu_id) {
        case 1:
            ddDays.state = "";
            ddDays.shownItem.color = ddMonths.shownItemColor
            ddMonths.state = "dropDown";
            ddMonths.shownItem.color = Qt.darker(ddMonths.shownItemColor, 1.25)
            ddMonths.kbpropDDmenu.forceActiveFocus()
            //checkActiveFocus()
            break;
        case 2:
            ddMonths.state = "";
            ddMonths.shownItem.color = ddMonths.shownItemColor
            ac1Menu.txtEdit.cursorVisible = true;
            ac1Menu.txtEdit.forceActiveFocus();
            //checkActiveFocus()
            break;
        case 3:
            ac2Menu.txtEdit.cursorVisible = true;
            ac2Menu.txtEdit.forceActiveFocus();
            //checkActiveFocus()
            break;
        case 4:
            ddDays.state = "dropDown";
            ddDays.shownItem.color = Qt.darker(ddDays.shownItemColor, 1.25)
            ddDays.kbpropDDmenu.forceActiveFocus();
            //checkActiveFocus()
            break;
        }
    }    
    signal closeMenu(int menu_id)
    onCloseMenu: {
        switch(menu_id) {
        case 1:
            ddDays.state = "";
            break;
        case 2:
            ddMonths.state = "";
            break;        
        case 3:
            ac1Menu.state = "";
            break;
        case 4:
            ac2Menu.state = "";
            break;
        }
    }

    signal savepageInput ()
    onSavepageInput: {
        ac1Menu.saveInput()
        ac2Menu.saveInput()
    }

    Spacer { boxHeight: butprev.height * 1.5; opacity: .0}
    ReadOnlyText {
        txtText: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin pharetra nonummy pede. Mauris et orci."
        textID: 5
    }
    Spacer { boxHeight: butprev.height * .5; opacity: .0}
    RowLayout {
        id: ddownRow
        Layout.alignment: Qt.AlignHCenter
        spacing: 20       
        Layout.margins: 20       

        DDMenu {
            id: ddDays
            fieldID: 3
            responseID: 3
            menuID: 1
            shownItemText: "day"
            Layout.fillHeight: false
            kbpropDDmenu.onFocusChanged:  {
                if (kbpropDDmenu.activeFocus === false) {
                    closeMenu(menuID)
                }
            }
        }
        DDMenu {
            id: ddMonths
            fieldID: 4
            responseID: 3
            menuID: 2
            Layout.fillHeight: false
            shownItemText: "month"
            kbpropDDmenu.onFocusChanged:  {
                if (kbpropDDmenu.activeFocus === false) {
                    closeMenu(menuID)
                }
            }
        }
        ACTMenu {
            id: ac1Menu
            fieldID: 5
            responseID: 3
            menuID: 3
            wltLabel: "\"a\" -acc -> add+"
            shownItemText: ""
            Layout.fillHeight: false
            txtEdit.onFocusChanged: {
                if (txtEdit.activeFocus === false) {
                    closeMenu(menuID)
                }
            /*    // VKboard integration - omit if issues
                if (stackView.vkEnabled === true) {
                    if (ac2Menu.txtEdit.cursorVisible === true) {
                        ac2Menu.txtEdit.cursorVisible = false
                        ac2Menu.saveInput()
                    }
                    ac1Menu.txtEdit.cursorVisible = true;
                    txtBuffer.setVKboard(fieldID)
                    nbutton.mouseNext.enabled = false;
                    butprev.mousePrev.enabled = false;
                } */
            }
            //initialMenu: true // may need this to reset the menu when navigating back
        }      
        ACTMenu {
            id: ac2Menu
            fieldID: 6
            responseID: 3
            menuID: 4
            wltLabel: "\"a\" -all -> app+"
            shownItemText: ""
            Layout.fillHeight: false
            txtEdit.onFocusChanged: {
                if (txtEdit.activeFocus === false) {
                    closeMenu(menuID)
                }
            /*    // VKboard integration - omit if issues
                if (stackView.vkEnabled === true) {
                    if (ac1Menu.txtEdit.cursorVisible === true) {
                        ac1Menu.txtEdit.cursorVisible = false
                        ac1Menu.saveInput()
                    }
                    ac2Menu.txtEdit.cursorVisible = true;
                    txtBuffer.setVKboard(fieldID)
                    nbutton.mouseNext.enabled = false;
                    butprev.mousePrev.enabled = false;
                } */
            }
        }
    }
    Spacer { boxHeight: butprev.height * 2; opacity: .0}
    RowLayout {
        id: navBut
        Layout.alignment : Qt.AlignHCenter | Qt.AlignBottom
        spacing: 20        

        PreviousButton {
            id:butprev
        }
        NextButton {
            id: nbutton
            mouseNext.onClicked: {
                savepageInput()
            }
        }
    }
    Connections {
        target: stackView

        // VKboard signal
        onShowLine: {
            switch(field_id) {
            case 5:
                //console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                ac1Menu.shownItem.doVKfill(field_id, c_pos, k_text);
                break;
            case 6:
                //console.log("onShowLine: type: " + field_id + "-" + c_pos + "-" + k_text);
                ac2Menu.shownItem.doVKfill(field_id, c_pos, k_text);
                break;
            }
        }
    }
    Connections {
        target: uiProcess

        // VKboard signal - eventually turn this into a switch for multiple page input
        onSendFocusType: {
            //console.log(" menu page onSendFocusType: type: " + s_data);
            if (s_data == 1) { // s_data = focus type; 1 = page focus
                ac1Menu.txtEdit.cursorVisible = false;
                ac2Menu.txtEdit.cursorVisible = false;
                keyproppage2.forceActiveFocus();
                nbutton.mouseNext.enabled = true;
                butprev.mousePrev.enabled = true;
            }
        }
        onSendWordCount: {
            switch (n_data) { //  = data_code/menuID
            case 1:
                ddDays.saveWordCount(n_data, s_data)
                break;
            case 2:
                ddMonths.saveWordCount(n_data, s_data)
                break;
            case 3:
                ac1Menu.saveWordCount(n_data, s_data)
                break;
            case 4:
                ac2Menu.saveWordCount(n_data, s_data)
                break;
            }
            //console.log("Connections: onSendWordCount: qID-count " + n_data + "-" + s_data)
        }
        onSendWords: {
            switch (d_data) { //  = data_code/menuID
            case 1:
                ddDays.saveWords(str_data)
                break;
            case 2:
                ddMonths.saveWords(str_data)
                break;
            case 3:
                ac1Menu.saveWords(str_data)
                break;
            case 4:
                ac2Menu.saveWords(str_data)
                break;
            }
            //console.log("Connections: onSendWordCount: data_code-word " + d_data + "-" + str_data)
        }
        onDataCode: {
            switch(s_data) { // = data_code/menuID
            case 1:
                ddDays.menuPropertyChange(n_data, s_data)
                break;
            case 2:
                ddMonths.menuPropertyChange(n_data, s_data)
                break;
            case 3:
                ac1Menu.menuPropertyChange(n_data, s_data)
                break;
            case 4:
                ac2Menu.menuPropertyChange(n_data, s_data)
                break;
            }
            //console.log("Connections signal: onDataCode response-menuID(" + n_data + "-" + s_data + ")")
        }
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
        id: keyproppage2

        Keys.onRightPressed: {
            savepageInput()
            //console.log(" TesMultInputPage KeyboardProp1: onRightPressed page - " + pageID);
        }
        //Keys.onTabPressed: { console.log(" TesMultInputPage: onTabPressed--> pageNum " + pageID); }
    }
    Component.onCompleted: {
        //console.log("  **onCompleted** pg(" + pageID + ")")

         // sends data to various menus - these must be done before getNextData - # value is data_codeID
        uiProcess.sendPromptData(pageID);
        uiProcess.sendMenuData(pageID);
        uiProcess.getNextData(pageID)
        if (buttonError.state === "on") {
            buttonError.toggle()
        }
        uiProcess.pageNum = pageID;
        keyproppage2.forceActiveFocus();
    }
}
