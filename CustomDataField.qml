import QtQuick 2.6
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1
import DataType 1.0

Item {
    id: root

    property string textData: ""
    property string defaultData: ""
    property int type: DataType.UNDEFINED
    property string errorsMessage: ""

    function resetFocus() {
        if (data.focus)
            data.focus = false;
    }

    function setData(_data){
        data.text = _data;
        if (_internal.setDataControl())
            _internal.isDefaultData = false;
    }

    MessageDialog {
        id: messageDialog
        title: "Error when setting data"
        text: errorsMessage
        onAccepted: {
            Qt.quit()
        }
    }

    QtObject
    {
        id: _internal

        property bool isDefaultData: true;

        function setDataControl()
        {
            var result = true;
            if (type !== -1)
            {
                if (!control.setData(type,data.text))
                {
                    result = false;
                    messageDialog.visible = true;
                    data.text = defaultData;
                }
                else
                    defaultData = data.text;
            }
            return result;
        }
    }

    Component.onCompleted: {
        if (!_internal.setDataControl()) {
            defaultData = "";
            data.text = defaultData;
        }
//        if (type == DataType.MQTT_PORT)
//            data.validator = RegExpValidator { regExp: /[0-9A-F]+/ }
    }

    Text {
        id: _name

        anchors {
            top: root.top
            left: root.left
            leftMargin: 10
            right: root.right
        }
        height: root.height / 4

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: _name.height
        color: "#888888"

        text: root.textData
    }
    Rectangle {
        id: background

        anchors {
            top: _name.bottom
            topMargin: 5
            left: root.left
            right: root.right
            bottom: root.bottom
        }

        border.color: data.focus ? "#FFFFFF" : "#000000"
        border.width: 1
        radius: 10
        color: root.enabled ? "#c4c4c4" : "#333333"
        opacity: data.focus ? 0.6 : 0.3
    }

    TextInput {
        id: data

        anchors.fill: background
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        clip: true

        font.pixelSize: data.height * 0.5
        color: focus ? "#FFFFFF" : "#888888"

        text: root.defaultData

        Keys.onPressed: {
            if (focus &&
                    (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)) {
                focus = false;
            }
        }

        onFocusChanged: {
            if (focus && _internal.isDefaultData) {
                text = ""
            }
            if (!focus) {
                if (_internal.isDefaultData)
                    if (text == "") text = root.defaultData;
                    else _internal.isDefaultData = false;
                _internal.setDataControl();
                cursorPosition = 0;
            }
        }
    }
}

