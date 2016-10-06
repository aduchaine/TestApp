import QtQuick 2.7

// ACT = auto complete text edit
// DropDownText.qml contains layout and list functions
// WriteLineText.qml, KeyboardProp1.qml are required for focus items
// some functions and signals at the page level in "TesMultInputPage.qml" are required
DropDownText {
    id: actmenu

    property int fieldID: shownItem.fieldID                 // enumerated fieldID
    property int responseID                                 // responce ID for what the user input
    property string textSelected                            // selected user text input

    property variant autoItems                              // auto complete array items
    property bool newMenu                                   // autocomplete switch - each fresh navigation gets a fresh menu

    property int word_count: 0                              //  used to verify menu population completion
    property int word_count_incr: 0                         //  used to verify menu population completion

    property variant autocompleteOn                         // toggles insertion of words into the menu and text line - similar to mutex.lock() switch
    property variant autocomSelectOn                        // toggles whether or not text in the input field will be actively selected and highlighed


    signal processSelection(int p_index);
    signal saveField(bool navigate);

    onSaveField: {
        saveInput();
        if (actmenu.state === "dropDown") {
            actmenu.state = "";
        }
        if (navigate === true) {
            //console.log(" onTabPressed  navigateSideways " + fieldID)
            navigateSideways(fieldID)
        }
    }
    onProcessSelection: {
        actmenu.state = ""
        responseID = p_index;
        //console.log("ACTMenu pageID-fieldID-responseID:  " + pageID + "-" + fieldID + "-" + responseID)
        uiProcess.pi_data2 = fieldID;
        uiProcess.pi_data1 = responseID;
        uiProcess.pi_data3 = menuID;
        uiProcess.processClick();
    }

    // this needs to occur if the entry was typed
    function saveInput() {
        txtEdit.selectAll();
        textSelected = txtEdit.selectedText;
        shownItemText = textSelected;
        txtEdit.deselect();
        //console.log("textSelected-shownItem.txlTxt-shownItemText ->" + textSelected + "-" + shownItem.txlTxt + "-" + shownItemText);
        // if we have a text string to process, we should send it over correctly - if it doesn't exist in "items[]", it's invalid
        if (responseID === 2) {
            uiProcess.pi_data2 = fieldID;
            uiProcess.ps_data1 = textSelected;
            uiProcess.checkString();
            //console.log("textSelected-fieldID = " + textSelected + "-" + fieldID);
        }
        else {
            //console.log("ACT getIndexLocation: textSelected-fieldID = " + textSelected + "-" + fieldID);
            getIndexLocation()
        }
    }
    // these two are for menu data populating from c++ (memory or external files)
    function saveWordCount(menu_id, w_count) {
        //console.log("saveWords: menuID-w_count = " + menu_id + "-" + w_count);
        word_count = w_count;
        menuID = menu_id;
        if (w_count === 0) { // if state is default "open" and there is no data
            txtEdit.cursorVisible = true
            actmenu.state = ""
        }
    }
    function saveWords(string_data) {
        if (newMenu === false) {            
            //console.log("Initial saveWords: word-position " + string_data + "-" + word_count_incr);
            items[word_count_incr] = string_data;
            ++word_count_incr;
            if (word_count_incr === word_count && word_count != 0) {
                //var first_word = items[0] //  for testing
                //doAutoComplete(first_word) // for testing
                listviewArray = items; //
                newMenu = true;
                //actmenu.state = "dropDown"; // for testing
                //console.log("Initial items saveWords: word_count = " + word_count);
            }
        }
        else {            
            console.log("AC saveWords: word-position " + string_data + "-" + word_count_incr);
            autoItems[word_count_incr] = string_data;
            ++word_count_incr;
            if (word_count_incr === word_count && word_count != 0) {
                var first_word = autoItems[0]
                doAutoComplete(first_word)
                listviewArray = autoItems
                actmenu.state = "dropDown"
                //console.log("AC autoItems saveWords: word_count = " + word_count);
            }
        }
    }
    // every menu where a selection is made will use this
    function menuPropertyChange(menu_data, menu_id) {
        if (menu_id === menuID) { // for menu state
            //console.log("menu item #" + menu_data + "-" + items[menu_data]);
            shownItemText = items[menu_data]
            curIndex = menu_data
        }
    }
    // every menu where a selection is made will use this
    function getIndexLocation() {
        for (var i = 0; i < items.length; i++) {
            if (items[i] === shownItemText) {
                var selection_pos = i //  <- chosen item index for processing - possibly not needed
                //console.log("ACT getIndexLocation: " + shownItemText + " (item)chosen(ID) " + i)
                processSelection(selection_pos) // program specific - process data function
                break;
            }
            else {
               // break; // invalid in most cases - optional: could throw an error message here
            }
        }
    }

    /*      /////   Auto Complete functions  /////

        - some of these are used in "TestTxtInput.qml"
        - different platforms/keyboards may cause some issues
        - a standard should be set which works on most keyboards

        Main process below described here: <function doAutoComplete(input_text)>
            *** this function is called directly after receiving the final word from c++
            - turn autocomplete switch on - this is used in "checkString()" - it won't check the new text inserted below and mess it all up
            - get the cursor pos
            - create a substr of input_text
            - set "class variable" to this subsrt to be used in a different function
            - insert the substr into the input field
            - select the second portion
            - set a switch to on to allow other areas to know something is selected - turn it off with most keypresses
            - make the cursor invisible to not confuse the user
            - turns autocomplete switch off to allow real user input to determine outcomes

        Function <acCursorLeft(key_delete)> is used for keyboard events which should move the cursor to the left
            - without this function, left arrow and backspace do not perform their normal functions
    */

    // if auto complete is used only for a ext line and not as a menu, "enter/return" key should be altered
    // a different inputStatus should be noted - this provides the reason to separate the auto complete functions
    function doAutoComplete(input_text) {
        var firstportion = shownItemText
        var secondportion;
        var cursor_pos;

        autocompleteOn = true
        cursor_pos = firstportion.length
        secondportion = input_text.substring(cursor_pos, input_text.length)
        //console.log("doAutoComplete: pos-first-second(" + cursor_pos + "-" + firstportion + "-" + secondportion + ")");
        txtEdit.insert(cursor_pos, secondportion)
        txtEdit.select(firstportion.length, input_text.length)
        autocomSelectOn = true
        txtEdit.cursorVisible = false
        autocompleteOn = false
    }
    function acCursorLeft(key_delete) {
        if (autocomSelectOn === false) {
            return;
        }
        var cursor_pos;
        var selected_text;
        cursor_pos = txtEdit.cursorPosition
        selected_text = txtEdit.selectedText        

        if (key_delete === true) {
            if (selected_text === txtEdit.selectedText) {
                //console.log(" acCursorLeft: cursor_pos-selected_text " + cursor_pos + "-" + selected_text.length)
                txtEdit.remove((cursor_pos - 1), (cursor_pos + selected_text.length))

                //console.log(" acCursorLeft: cursor_pos " + cursor_pos)

                    // this kinda works to show text when deleting
                //shownItem.autocomSelectOn = false
                //shownItem.autocompleteOn = false
                //shownItem.checkString()
                //shownItem.autocompleteOn = true
                //shownItem.autocomSelectOn = true
            }
        }
        else {
            txtEdit.cursorPosition = cursor_pos - selected_text.length
            txtEdit.deselect()
        }
        autocomSelectOn = false // remove this when trying to imporve this function
    }   
}

/*// --- ------ these items do not work w/o messing with focus  ------- ----- //
        // secondary focus on object
    KeyboardInput {
        id: keyboardinput2
                  // tabKeyPress2 = signal at the page level to change states of items
        onTabKeyPress: { tabKeyPress2(); console.log(" onTabKeyPress "); }

        onFocusChanged: {
            //console.log(" onFocusChanged " + focus)
            if (keyboardinput2.activeFocus === false) {
                dropdownClick.state = ""
            }
        }
        Keys.onReturnPressed: {
            completerEdit.state = "";
            shownItemText = items[listView.currentIndex]; // does the same as <shownItem.butTxt = modelData> in mouse area
            //console.log(shownItemText + " (chosen_item)(chosen_itemID) " + listView.currentIndex)
            //responseID = listView.currentIndex // program specific
            getIndexLocation();
        }
        Keys.onDownPressed: {
            if (dropdownMenu.state === "") { // doesn't move the selector if item is focused
                return;
            }
            if (listView.currentIndex < dropdownMenu.items.length - 1) {
                listView.currentIndex = listView.currentIndex + 1;
            }
            //console.log("  CompleterEdit: onDownPressed")
        }
        Keys.onUpPressed: {
            if (dropdownMenu.state === "") {
                return;
            }
            if (listView.currentIndex > 0) {
                listView.currentIndex = listView.currentIndex - 1;
            }
            //console.log("  CompleterEdit: onUpPressed")
        }
    } */
