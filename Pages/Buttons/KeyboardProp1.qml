import QtQuick 2.7

// this is the root keyboard focus at the page level - it does more of the page processes
// this will get trumped by TextEdit occasionally
// implemetation of ACTMenu.qml requires function "setPageFocus()" and how it's used here
Item {
    id: keyproperties

    property alias processTimer: processDelayTimer

    // any page which uses this qml should be added to this function
    function setPageFocus(page_id) {
        switch(page_id) {
        case 1:
            keyproppage1.forceActiveFocus()
            break;
        case 2:
            keyproppage2.forceActiveFocus()
            break;
        }
    }
    // probably need to alter what this does based on pageID or feildsID/dataCodeID/menuID != 0 when the situation arises
    Keys.onRightPressed: {
        //console.log(" Root KeyboardProp1: onRightPressed page - " + uiProcess.pageNum);
        if (uiProcess.pageNum < 7) {
            processDelayTimer.start();
        }
    }
    Keys.onLeftPressed: {
        //console.log(" Root KeyboardProp1: onLeftPressed page - " + uiProcess.pageNum);
        uiProcess.getPreviousPage(uiProcess.pageNum);
    }
    Keys.onEscapePressed: {        
        console.log(" Root KeyboardProp1: onEscapePressed--> pageNum (" + pageID + ")")
        setPageFocus(pageID)
    }    

    // before this timer triggers all the page data must be saved and ready to confirm
    Timer {
        id: processDelayTimer
        interval: 50
        onTriggered: {
            //console.log(" Root processDelayTimer: trigger signal - page-page = " + pageID + "-" + uiProcess.pageNum + " -> confirmData()")
            uiProcess.confirmData(uiProcess.pageNum);
        }
    }
}
