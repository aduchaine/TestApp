import QtQuick 2.7

// some functions and signals at the page level in "InputDataStringPage.qml" are required
// WriteLineText.qml is required for text input function and focus items
WriteLineText {
    id: sltext
    txlBoxColor: Qt.darker("tan", .9)
    txlBoxBrdrColor: "white"
    maxLineLen: 20

    inputStatus: 0                      // 0 = standard line length text editing, 1 - drop down autocomplete word/line length

    property int responseID             // responce ID for what the user input - signifies which text field is processed
    property string textSelected        // selected user text input

    signal saveField(bool navigate);
    onSaveField: {
        saveInput();
        if (navigate === true) {
            navigateSideways(fieldID)
        }
    }
    function saveInput() {
        txtLine.selectAll();
        textSelected = txtLine.selectedText;
        txtLine.deselect();
        txtLine.cursorVisible = false;
        uiProcess.pi_data1 = responseID;
        uiProcess.pi_data2 = fieldID;
        uiProcess.ps_data1 = textSelected;
        uiProcess.checkString();
        console.log("textInputString = " + textSelected);
    }
}
