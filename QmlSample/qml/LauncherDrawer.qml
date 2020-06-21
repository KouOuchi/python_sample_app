import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import MyOperationPanel 1.0

Drawer {
    id: drawer
    width : 300
    height : parent.height
    visible: false

    property alias op_panel: op_panel
    //property alias pro: pro

    function deactivate() {
        close()
        visible = false
    }
    function activate() {
        visible = true
        open()
    }

    ToolBar {
        id : toolbar
        width : parent.width
        RowLayout {
            anchors.fill: parent
            Label {
                text: "Discharger Drawer"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                id:back
                anchors.top: parent.Top
                x : 0
                text: "<"
                onClicked: {
                    drawer.deactivate()
                }
            }
        }

    }

    function my_callback() {
        var ret = op_panel.is_running()

        console.debug("my_callback() called. is_runnning returns : " + ret)

        if((ret & 1<<0) == 1<<0) {

            // runnning
            busy.running = true
            note.text = "Running..."
            pro.text = op_panel.progress_text()
        } else {
            busy.running = false
            initialize()

            if((ret & 1<<1) == 1<<1) {
                note.text = op_panel.get_result() + " Primes found."
            } else {
                note.text = "Canceled."
            }
        }
    }

    function setTimeout(callback, delay, repeat) {
        if (timer.running) {
            console.error("nested calls to setTimeout are not supported!");
            return;
        }
        timer.callback = callback;
        // note: an interval of 0 is directly triggered, so add a little padding
        timer.interval = delay + 1;
        timer.running = true;
        timer.repeat = repeat
    }

    MyOperationPanel {
        id: op_panel

        anchors.fill: parent

        ColumnLayout {
            anchors.centerIn: parent
            Text {
                id:pro
                Layout.alignment: Qt.AlignHCenter
                visible: busy.running
                color:"yellow"
            }
            Button {
                id:btn
                text:"!!!Boost!!!"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    busy.running = true
                    enabled = false
                    setTimeout(my_callback, 100, true)

                    if(op_panel.boost())
                        console.debug('boost is accepted.')
                    else
                        console.debug('boost is denied.')
                }
            }
            Text {
                id:cancel_link
                textFormat: Text.StyledText
                Layout.alignment: Qt.AlignHCenter
                linkColor: "yellow"
                visible: busy.running

                onLinkActivated: {
                    console.debug('linkActivated.')
                    if(op_panel.cancel_boost()) {
                        console.debug('cancel is accepted.')

                        enabled = false
                        text = "<html><style type=\"text/css\"></style><a href=\".\">try to cancel ...</a></html>"
                    } else {
                        console.debug('cancel is denied.')
                    }
                }
            }
        }
        BusyIndicator {
            anchors.centerIn: parent
            id: busy
            width: 190
            height: 190
        }
        Timer {
            id: timer
            running: false
            repeat: true

            property var callback

            onTriggered: my_callback()
        }
    }

    function initialize() {
        btn.enabled = true

        busy.running = false

        timer.repeat = false
        timer.running = false
        timer.callback = null

        cancel_link.text = "<html><style type=\"text/css\"></style><a href=\".\">cancel</a></html>"
        cancel_link.enabled = true

        pro.text = ""
    }

    Component.onCompleted: {
        initialize()
    }
}
