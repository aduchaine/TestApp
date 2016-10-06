import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "Pages/Buttons/"
import "Pages/"
import UIProcess 1.0


ApplicationWindow {
    property int initialWidth: 800
    property int initialHeight: 550

    id: mainWindow
    width: initialWidth
    height: initialHeight
    minimumWidth: 400
    minimumHeight: 300
    maximumWidth: 1000
    maximumHeight: 750
    visible: true
    title: qsTr("App GUI")

    property string nextPageURL
    property string prevPageURL

    // all pages are relative paths to "qrc" - unsure if this will work outside of this
    function getPageURLstring(page_num) {
        var page_string;
        switch(page_num) {
        case 0:
            page_string = "Pages/BeginPage.qml";
            break;
        case 1:
            page_string = "Pages/InputDataStringPage.qml"; // InputDataStringPage // TestChat // Test_000
            break;
        case 2:
            page_string = "Pages/TesMultInputPage.qml";
            break;
        case 3:
            page_string = "Pages/TestContentPageRow.qml";
            break;
        case 4:
            page_string = "Pages/TestContentPageCol.qml";
            break;
        case 5:
            page_string = "Pages/ContentPage2Buttons.qml";
            break;
        case 6:
            page_string = "Pages/ContentPage4Buttons.qml"; // from here to the final page is pretty neat looking, almost disorienting
            break;
        case 7:
            page_string = "Pages/EndPage.qml";
            break;
        }
        return page_string;
    }

    Image {
        fillMode: Image.Stretch
        anchors.fill: parent
        source: "Resources/my_bckground.png"
    }

    // center lines for testing
    Spacer { id: vcenterline; visible: false; z: 1000; boxtxtVisible: false; anchors.centerIn: parent; boxHeight: mainWindow.height; boxWidth: 1; opacity: 1 }
    Spacer { id: hcenterline; visible: false; z: 1000; boxtxtVisible: false; anchors.centerIn: parent; boxWidth: mainWindow.width; boxHeight: 1; opacity: 1 }

    StackView {
        id: stackView
        anchors.fill: parent
        anchors.margins: 10
        Layout.fillWidth: true

        // interpage processes
        signal savepageInput (int page_id)
        signal navigateSideways(int field_id);

        // VKboard stuff
        property bool vkEnabled: false
        signal showLine(int field_id, int c_pos, string k_text);
        signal sendBuflen(int field_id, int buf_len);
        onSendBuflen: {
            keyboard.bufferLength = buf_len;
            keyboard.fieldcharArray[field_id] = buf_len;
            console.log("send buflen" + field_id + "-" + buf_len);
        }

        // for page transitions
        function getRandomNumber(scope, shift) {
            svDelegate.randnum = shift + (Math.random() * scope);
            return svDelegate.randnum;
        }
        function setSVDrannum() {
            svDelegate.ranDuration1 = getRandomNumber(200, 100);
            svDelegate.ranDuration2 = getRandomNumber(100, 100);
            svDelegate.ranX = getRandomNumber(mainWindow.width*2, (-mainWindow.width));
            svDelegate.ranY = getRandomNumber(mainWindow.height*2, (-mainWindow.height));
        }
        function lockInput(lock) {
            if (lock === true) {
                stackView.enabled = false;
                lockinputTimer.start();
            }
            else {
                stackView.enabled = true;
            }
        }
        delegate: Transitions {
            id: svDelegate
        }
        QuitButton {
            id: buttonQuit
            Layout.alignment : Qt.AlignTop
        }
        ErrorButton {
            id: buttonError
        }
        ColumnLayout {
            anchors.fill: parent
            id: stackvCol

            ReadOnlyText {
                id: genericROTxt1
                textID: -1
                txtText: "ph header text"
                txtSize: 24
                txtColor: "white"                
                Layout.alignment : Qt.AlignHCenter | Qt.AlignTop
                Layout.leftMargin: 60
                Layout.rightMargin: 60
            }
        }       
        UIProcess {
            id: uiProcess

            property int pageNum

            // --- // -- All of the page navigation done here -- // --- //

            onValidData: { // "valid data" signal for each page before navigating forward
                pageNum = n_data; // this may not be necessary
                nextPageURL = Qt.resolvedUrl(getPageURLstring(n_data))                
                stackView.lockInput(true);
                stackView.replace(nextPageURL)
                stackView.setSVDrannum();
                //console.log("stackView.UIProcess onValidData page-page-items("  + pageNum + "-" + n_data + "-" + stackView.depth + ")")
            }
            onPreviousPage: { // "previous page" signal for each page before navigating back
                pageNum = n_data; // this may not be necessary
                prevPageURL = Qt.resolvedUrl(getPageURLstring(n_data))                
                stackView.lockInput(true);
                stackView.replace(prevPageURL)
                stackView.setSVDrannum();
                //console.log("stackView.UIProcess: onPreviousPage page-page-items(" + pageNum + "-" + n_data + "-" + stackView.depth + ")")
            }
            onInvalidData: {
                buttonError.toggle(true)
            }
            onNoData: {
                buttonError.toggle(true)
            }
            onProcessedData: {
                Qt.quit()
            }
            // VKkeyboard signal
            onSendKeyToField: { // n_data = fieldID, str_data = text line
                keyboard.doTyping(n_data, str_data);
            }
        }
        KeyboardProp1 {
            id: keyinputStackView
        }        
        Timer {
            id: lockinputTimer
            interval: 800 // max transition duration
            onTriggered: {
                stackView.lockInput(false);
            }
        }
        // this is for testing the VKboard
        // nothing will be displayed hence - no text is printed
        // eventually the same process will go into an actual buffer, hopefully
        // some of the VKboard functions intertwined with UI functions should be separated somehow (page# functions, etc)
        WriteLineText {
            id: txtBuffer
            txlTxtColor: "white"
            anchors.top: buttonError.top
            visible: false

            property alias textEdit: txtBuffer.txtLine
            property int saveCp: 0
            property int setCp: 0

            function setVKboard(field_id) {
                if (field_id === 3) { keyboard.anchors.top = stackView.top; }
                keyboard.visible = true;
                keyboard.saveBufferLength();
                keyboard.sendFieldID(field_id);
                keyboard.forceActiveFocus();
                keyboard.state = "fadeIn";
                keyboard.setCursorPosition(field_id);
                //console.log(" field_id (" + field_id  + ")--" + "  saveCp(" + saveCp + "-" + setCp + ")setCp")
            }
        }
        VirtualKeyboard {
            id: keyboard

            signal dotyping(int field_id, int c_pos, string k_text)
            onDotyping: {
                stackView.showLine(field_id, c_pos, k_text);
                //console.log("showLine: field_id, pos, key " + field_id + "-" + c_pos + "-" + k_text);
            }
        }
        initialItem: BeginPage {
            Component.onCompleted: {
                keyinputStackView.forceActiveFocus()
                console.log("BeginPage.qml loaded")
            }
        }

/*                // --- these are all the signals sent from C++  --- //
                // data sending signals
                onChangeState: { console.log("UIProcess signal: onChangeState    Data(" + s_data + ")") }
                onStringData: { console.log("UIProcess signal: onStringData    string_data(" + str_data + ")") }
                onDataCode: { console.log("UIProcess signal: onDataCode response-menuID(" + n_data + "-" + s_data + ")"); }
                onSendWordCount: { console.log("UIProcess signal: onSendWordCount")  }
                onSendWords: { console.log("UIProcess signal: onSendWords") }

                // confirmation signals, for the most part
                onPreviousPage: { console.log("UIProcess signal: onPreviousPage") }
                onValidData: { console.log("UIProcess signal: onValidData") }
                onInvalidData: { console.log("UIProcess signal: onInvalidData") }
                onNoData: { console.log("UIProcess signal: onNoData") }
                onProcessedData: { console.log("UIProcess signal: onProcessedData - quit"); }

                // VK keyboard signals
                onSendKeyToField: { console.log("UIProcess signal: onSendKeyToField qID-string " + n_data + "-" + str_data); }
                onSendFocusType: { console.log("UIProcess signal: onSendFocusType focus_type " + s_data); }
*/

        /*         // --- these are all the important key signals --- //
            Keys.onReturnPressed: { console.log(" StackView: -KeyboardProp1- onReturnPressed " + uiProcess.pageNum); }
            Keys.onTabPressed: { console.log(" StackView: -KeyboardProp1- onTabPressed " + uiProcess.pageNum); }
            Keys.onEscapePressed: { console.log(" StackView: -KeyboardProp1- onEscapePressed"); }
            Keys.onUpPressed: { console.log(" StackView: -KeyboardProp1- onUpPressed " + uiProcess.pageNum); }
            Keys.onDownPressed: { console.log(" StackView: -KeyboardProp1- onDownPressed " + uiProcess.pageNum); }
            Keys.onRightPressed: { console.log(" StackView: -KeyboardProp1- onRightPressed " + uiProcess.pageNum); }
            Keys.onLeftPressed: { console.log(" StackView: -KeyboardProp1- onLeftPressed " + uiProcess.pageNum); }
            Keys.onPressed: {
                if (event.key === Qt.Key_Enter) { console.log(" StackView: -KeyboardProp1- onPressed: Key_Enter  page " + uiProcess.pageNum); }
                if (event.key === Qt.Key_Backspace) { console.log(" StackView: -KeyboardProp1- onPressed: Key_Backspace page " + uiProcess.pageNum); }
                console.log(" StackView: -KeyboardProp1- onPressed- uiProcess.pageNum " + uiProcess.pageNum)
            } */

    }
}
