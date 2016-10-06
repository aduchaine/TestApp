import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.2

// basic drop down text edit menu
// ACTMenu.qml contains most processing functions
// WriteLineText.qml, KeyboardProp1.qml are required for focus items
// some functions and signals at the page level in "TesMultInputPage.qml" are required
ButtonProp1 {
    id: dropdownText
    color: Qt.darker("tan", 2) // "transparent"
    radius: 6
    butTxt: ""

    Layout.minimumWidth: 50
    Layout.preferredWidth: 100
    Layout.maximumWidth: 150
    Layout.minimumHeight: 20
    Layout.preferredHeight: 25
    Layout.maximumHeight: 30
    Layout.fillWidth: true

    property int menuID                                     // identifies the menu and it's data set
    property variant items: ["dummy item1"]

    property alias txtEdit: shownItem.txtLine
    property alias shownItem: shownItem
    property alias shownItemText: shownItem.txlTxt          // current item in the "shownItem" button
    property string wltLabel: "label text"                  // text line label
    property color shownItemColor: "lightsteelblue"
    property color menuItemColor: Qt.darker("beige", 1.25)

    property alias curIndex: listView.currentIndex          // this value will be different than "index" if a selection is made before syncing them
    property alias listviewArray: listView.model


    WriteLineText {
        id: shownItem // change to wltItem/wltText
        width: parent.width
        height: parent.height
        txlBoxBrdrWidth: 1
        txlBoxColor: Qt.darker("beige", 1.1)
        radius: 6
        txlTxtSz: 12
        txlTxt: ""        
        txlLabelTxt: wltLabel
        txlLabelSz: 12
        txlLabelAnchor.verticalCenter: Item.verticalBottom        

        inputStatus: 1                          // 0 = standard line length text editing, 1 - drop down autocomplete word/line length txt editing

        txtLine.onTextChanged: {
            if (txtLine.text.length <= 0) {
                txlLabelTxt = wltLabel
            }
            else {
                txlLabelTxt = ""
            }
        }
        //Component.onCompleted: { console.log("shownItem width-height " + shownItem.width + "-" + shownItem.height); }
    }
    // opening of the menu should be allowed with certain commands, maybe return but not a click, doesn't make sense
    ButtonProp1 { // may need to use the 2nd variant if text issues arise
        id: ddMenuItems
        width: dropdownText.width
        color: menuItemColor
        butBrdrWidth: 1
        opacity: 0.75
        butTxt: ""
        radius: 6
        clip: true // false shows max height
        anchors.top: shownItem.bottom

        ScrollView {
            id: dropdownScroll
            //width: dropdownText.width // add width property to get a scrollbar - wider menus seem to add scroll automatically
            height: dropdownText.height * 4 // this value must equal the value in "PropertyChanges" below

            ListView {
                id:listView
                model: dropdownText.items
                currentIndex: 0
                highlight: Rectangle { color: Qt.darker("steelblue", 0.8); radius: 6; border.color: butBrdrColor }

                delegate: Item {
                    width: shownItem.width
                    height: shownItem.height * 1 // alos change the "state" prop. and ScrollView height when making changes to the list

                    Text {
                        id: ddmenuitemText
                        text: modelData
                        anchors.centerIn: parent
                        color: "black"
                    }
                    MouseProp1 { // anything coming here will be a "click", therefore, NOT a typed string
                        onEntered: ddMenuItems.color = Qt.darker(menuItemColor, 1.25)
                        onExited:  ddMenuItems.color = menuItemColor
                        onClicked: {
                            //console.log("previous_itemID - " + curIndex) // keep this here for accurate log description
                            dropdownText.state = "";
                            actmenu.autocompleteOn = true
                            shownItem.setPageFocus(uiProcess.pageNum);
                            shownItemText = modelData;
                            //console.log(shownItemText + " (chosen_item)(chosen_itemID) " + index);
                            curIndex = index;
                            getIndexLocation();
                        }
                    }
                }
            }
            //Component.onCompleted: { console.log("dropdownScroll width-height " + dropdownScroll.width + "-" + dropdownScroll.height); }
        }
        //Component.onCompleted: { console.log("ddMenuItems width-height " + ddMenuItems.width + "-" + ddMenuItems.height); }
    }
    //Component.onCompleted: { console.log("dropdownText width-height " + dropdownText.width + "-" + dropdownText.height); }
    states: State {
        name: "dropDown"
        PropertyChanges { target: ddMenuItems; height:dropdownText.height*4; } //dropdownClick.height*dropdownClick.items.length;
    }
    transitions: Transition {
        NumberAnimation { target: ddMenuItems; properties: "height"; easing.type: Easing.OutExpo; duration: 1000 }
    }
    Component.onCompleted: {
        dropdownText.state = "";
        txtEdit.deselect();
    }
}

/*  KeyboardProp1 {
      id: keypropDDText

      onFocusChanged: {
          console.log(" onFocusChanged " + focus)
          if (keypropDDText.activeFocus === false) {
              dropdownText.state = ""
          }
      }
      Keys.onReturnPressed: {
          dropdownText.state = ""
          shownItemText = items[curIndex]
          console.log(shownItemText + " (item)chosen(ID) " + curIndex)
          responseID = curIndex
          getIndexLocation()
      }      
      Keys.onRightPressed: {
          console.log("  dropdownText: onRightPressed pg(" + pageID + ")")
        //  keyboardinput.rightKeyPress()
      }
  } */
