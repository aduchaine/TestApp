import QtQuick 2.7

Item {
    // for button UI states after going next/previous and switching buttons on the same fieldID
    function propertyChange(pc_data, switch_on) {
        if (switch_on === true) {
            if (pc_data === responseID) {

                greyButton.state = ""
                greyButton.state = "on";
                //console.log("button #" + pc_data + " turned on");
            }
        }
        else { // for button pages where only one answer is accepted
            if (pc_data === responseID) {
                greyButton.state = "off";
                //console.log("button #" + pc_data + " turned off");
            }
        }
    }

}
