import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.3

ApplicationWindow {
    id:app_window
    width:800
    height:600

    property alias drawer : drawer
    property alias note : note
    property alias toolbutton : toolbutton

    Page {
        padding: 10

        TopToolButton {
            id : toolbutton
            button_icon_alternative_text : "Dis"
            button_text: "Discharge Test!"

            onButton_clicked : {
                drawer.activate()
            }
        }

        LauncherDrawer {
            id: drawer
            height : parent.height
        }


    }
    Page {
        id: mini_view
        implicitHeight : 200
        implicitWidth : 200
        x : Math.round(app_window.width / 2)
        y : Math.round(app_window.height / 2)

        background: Rectangle {
            anchors.fill: parent
            color:"black"
        }

        header : ToolBar {
            id : toolbar
            width : parent.width
            height: 40

            background: Rectangle {
                anchors.fill: parent

                color: mouse.drag.active ?
                           Universal.color(Universal.accent) :
                           Universal.color(Universal.Olive)
            }

            RowLayout {
                anchors.fill: parent
                Label {
                    text: "Drag Me!"
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                id:mouse
                drag.target: mini_view
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.maximumX: app_window.width - mini_view.width
                drag.minimumY: 0
                drag.maximumY: app_window.height - mini_view.height
            }
        }


        Text {
            anchors.centerIn: parent
            color: "white"
            font.bold: true
            id: note
            font.pixelSize: 20
        }


    }
}
