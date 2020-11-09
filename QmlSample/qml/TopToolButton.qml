import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.0

ColumnLayout {
    id:topb
    property string button_text : " "
    property string button_icon_alternative_text : ""
    property bool show_button : true
    property string icon_name : ""
    signal button_clicked()
    spacing: 3

    RoundButton {
        id:btn
        //icon.name: icon_name
        //Layout.fillHeight: true
        //Layout.fillWidth: true
        text: button_icon_alternative_text
        Layout.minimumHeight: 44
        Layout.maximumHeight: 44
        Layout.minimumWidth: 44
        Layout.maximumWidth:44
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        background: Rectangle {
            anchors.fill: parent
            radius: 22
            color: btn.pressed ? Universal.accent : Universal.background
            border.color: btn.hovered ? Universal.accent : "gray"
            border.width: (btn.hovered||btn.pressed) ? 4 : 2
        }

        onClicked: {
            button_clicked()
        }
    }
    Label {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.minimumHeight: 16
        Layout.maximumHeight: 16
        font.pixelSize: 10
        text: button_text
        visible:show_button
        clip:false
        elide:Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }

}
