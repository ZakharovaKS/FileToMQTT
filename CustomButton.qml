import QtQuick 2.6
import QtQuick.Controls 2.15

Item {
    id: root

    property string text: ""

    signal clicked()

    Rectangle {
        id: background

        anchors.fill: parent

        border.color: "#888888"
        border.width: 1
        radius: 10
        opacity: 0.6
        color: "#52dfda"
    }

    Text {
        id: _text

        anchors.fill: parent

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: root.height * 0.5
        text: root.text
        color: "#303030"
    }

    states: [
        State
        {
            name: "pressed"
            when: root.enabled && mouse_area.pressed

            PropertyChanges
            {
                target: _text
                anchors.topMargin: 1
                anchors.leftMargin: 1
            }

            PropertyChanges
            {
                target: background
                opacity: 1.0
            }
        }
    ]

    MouseArea
    {
        id: mouse_area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked:
        {
            root.clicked();
        }
    }
}

