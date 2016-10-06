import QtQuick 2.7

// DDMenu = drop down menu
// DropDownMenu.qml contains layout, list and menu focus items and functions
// KeyboardProp1.qml is required for page focus items
// some functions and signals at the page level in "TesMultInputPage.qml" are required
DropDownMenu {
    id: ddmenu

    property int fieldID: shownItem.fieldID
    property int responseID                                 // responce ID for what the user input

    property int word_count: 0                              //  used to verify menu population completion
    property int word_count_incr: 0                         //  used to verify menu population completion

    signal processSelection(int p_index);

    onProcessSelection: { // do processing stuff
        if (p_index === -1) {
            navigateSideways(fieldID)
        }
        else {
            console.log("pageID-fieldID-responseID:  " + pageID + "-" + fieldID + "-" + responseID)
            responseID = p_index;
            uiProcess.pi_data2 = fieldID;
            uiProcess.pi_data1 = responseID;
            uiProcess.pi_data3 = menuID;
            uiProcess.processClick();
        }
    }
    // these two are for menu data populating from c++ (memory or external files)
    function saveWordCount(menu_id, w_count) {
        //console.log("saveWords: menuID-w_count = " + menu_id + "-" + w_count);
        word_count = w_count;
        menuID = menu_id; // this isn't needed, menuID will already be known
        if (w_count === 0) { // if state is default "open" and there is no data
            ddmenu.state = ""
        }
    }
    function saveWords(string_data) {
        //console.log("saveWords: string_data = " + string_data);
        items[word_count_incr] = string_data;
        ++word_count_incr;
        if (word_count_incr === word_count && word_count != 0) {
            listviewArray = items;
            //ddmenu.state = "dropDown"; // for testing
            //console.log("saveWords: word_count_incr = " + word_count_incr);
        }
    }
    // every menu where a selection is made will use these two
    function menuPropertyChange(menu_data, menu_id) {
        if (menu_id === menuID) { // for menu state
            console.log("menu item #" + menu_data + "-" + items[menu_data]);
            shownItemText = items[menu_data]
            curIndex = menu_data
        }
    }
    function getIndexLocation() {
        for (var i = 0; i < items.length; i++) {
            if (items[i] === shownItemText) {
                var selection_pos = i //  <- chosen item index for processing - possibly not needed
                //console.log(shownItemText + " (item)chosen(ID) " + i);
                processSelection(selection_pos); // program specific process data function
                break;
            }
        }
    }
}

/*   // --- ------ these items do not work w/o messing with focus  ------- ----- //
           // secondary focus on object
   KeyboardProp1 {
       id: keypropDDMenu

       Keys.onTabPressed: {
           //console.log(" DropDownMenu: onTabPressed--> pageNum " + pageID)
           //navigateSideways(menuID)
       }
     onFocusChanged: {
         console.log(" keypropDDMenu onFocusChanged " + focus)
         if (keypropDDMenu.activeFocus === false) {
             shownItem.color = shownItemColor;
             ddmenu.state = ""
         }
         else {
             shownItem.color = Qt.darker(shownItemColor, 1.25); // highlights when tabbed to, mostly
         }
     }
      Keys.onReturnPressed: {
          if (ddmenu.state === "") {
              ddmenu.state = "dropDown";
              ddmenu.listview.positionViewAtIndex(curIndex, ListView.Center)
          }
          else {
              ddmenu.state = "";
              shownItemText = items[curIndex]; // does the same as <shownItem.butTxt = modelData> in mouse area
              getIndexLocation()
          }
          console.log(shownItemText + " (chosen_item)(chosen_itemID) " + curIndex);
      }
      Keys.onDownPressed: {
          if (ddmenu.state === "") { // doesn't move the selector if item is focused
              return;
          }
          if (curIndex < ddmenu.items.length - 1) {
              curIndex = curIndex + 1;
          }
      }
      Keys.onUpPressed: {
          if (ddmenu.state === "") {
              return;
          }
          if (curIndex > 0) {
              curIndex = curIndex - 1;
          }
      }
   }
*/
