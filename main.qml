import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.0

import DataType 1.0

Item {
    id: mainScene

    width: 400
    height: 600

    Connections {
        target: control

        function onFileFeadFinish(countLine) {
            _internal.messageInfo = _internal.messageInfo + "\n File read. Lines to send: " + countLine;
        }

        function onSendMessageFinish(countMessage) {
            _internal.messageInfo = _internal.messageInfo + "\n Count messages sent to the broker: " + countMessage;
            _buttonSendAdd.visible = true
        }

        function onStatusMqttChanged() {
            if ( _internal.statusBroker == DataType.CONNECT)
            {
                _internal.showInfoBox()
            }
        }
    }

    QtObject {
        id: _internal

        property int margins: 10
        property real heightBlock: mainScene.height / 7
        property real widthPropertyBlock: _dataBackground.width / 2 - margins
        property int statusBroker: control ? control.statusMqtt : 0
        property string messageInfo: ""

        onStatusBrokerChanged: {
            var messageAdd = _internal.statusBroker == DataType.DISSCONNECTED ? "Broker disconnected" :
                                _internal.statusBroker == DataType.CONNECTED ?  "Broker connected" :
                                                                               "Broker connecting..."

            messageInfo = messageInfo + "\n " + messageAdd;
        }

        function resetFocusProperty ()
        {
            _hostData.resetFocus();
            _portData.resetFocus();
            _usernameData.resetFocus();
            _passwordData.resetFocus();
            _topicData.resetFocus();
            _fileData.resetFocus();
        }

        function showInfoBox()
        {
            _dataBackground.enabled = false
            _info.visible = true
            _runButton.enabled = false
            _buttonSendAdd.visible = false
        }

        function hideInfoBox()
        {
            _dataBackground.enabled = true
            _runButton.enabled = true
            _info.visible = false
            _internal.messageInfo = ""
        }
    }

    Rectangle
    {
        anchors.fill: parent

        color: "#dfdfdf"
        opacity: 0.3
    }

//    FileDialog {
//        id: fileDialog

//        title: "Please choose a file"
//        folder: shortcuts.home
//        nameFilters: "Text files (*.txt)"
//        onAccepted: {
//            //console.log("You chose: " + fileDialog.fileUrl)
//            var path = fileDialog.fileUrl.toString();
//            // remove prefixed "file:///"
//            path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
//            _fileData.setData(path)
//            close()
//        }
//        onRejected: {
//            console.log("Canceled")
//            close()
//        }
//    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            _internal.resetFocusProperty()
        }
    }

    Text {
        id: _title

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        height: _internal.heightBlock
        enabled: _internal.statusBroker == DataType.DISSCONNECTED

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: height - _internal.margins * 2
        color: "#888888"

        text: qsTr("MQTT")
    }

    Rectangle {
        anchors.left: _title.right
        anchors.leftMargin: _internal.margins
        anchors.verticalCenter: _title.verticalCenter

        width: _title.contentHeight / 3
        height: _title.contentHeight / 3
        radius: width / 2

        color: _internal.statusBroker == DataType.DISSCONNECTED ? "#FF0000" :
                    _internal.statusBroker == DataType.CONNECTED ?  "#00FF00" : "#FFFF00"

    }

    Item {
        id: _dataBackground

        anchors {
            left: parent.left
            right: parent.right
            top: _title.bottom
            topMargin: -_internal.margins
            bottom: _runButton.top
        }

        CustomDataField {
            id: _hostData

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: _internal.margins
            }
            width: _internal.widthPropertyBlock
            height: _internal.heightBlock
            enabled: _internal.statusBroker == DataType.DISSCONNECTED

            textData: "Host"
            defaultData: "test.mosquitto.org"
            type: DataType.MQTT_HOST
        }

        CustomDataField {
            id: _portData

            anchors {
                top: parent.top
                left: _hostData.right
                leftMargin: _internal.margins
                right: parent.right
                rightMargin: _internal.margins
            }

            height: _internal.heightBlock
            enabled: _internal.statusBroker == DataType.DISSCONNECTED

            textData: "Port"
            defaultData: "1883"
            type: DataType.MQTT_PORT
            errorsMessage: "The HOST field can contain only integer values."
        }

        CustomDataField {
            id: _usernameData

            anchors {
                top: _hostData.bottom
                topMargin: _internal.margins
                left: parent.left
                leftMargin: _internal.margins
            }

            width: _internal.widthPropertyBlock
            height: _internal.heightBlock
            enabled: _internal.statusBroker == DataType.DISSCONNECTED

            textData: "UserName"
            type: DataType.MQTT_USERNAME
            defaultData: ""
        }

        CustomDataField {
            id: _passwordData

            anchors {
                top: _portData.bottom
                topMargin: _internal.margins
                left: _usernameData.right
                leftMargin: _internal.margins
                right: parent.right
                rightMargin: _internal.margins
            }

            height: _internal.heightBlock
            enabled: _internal.statusBroker == DataType.DISSCONNECTED

            textData: "Password"
            type: DataType.MQTT_PASSWORD
            defaultData: ""
        }

        CustomDataField {
            id: _topicData

            anchors {
                top: _usernameData.bottom
                topMargin: _internal.margins
                left: parent.left
                leftMargin: _internal.margins
                right: parent.right
                rightMargin: _internal.margins
            }

            height: _internal.heightBlock

            textData: "Topic"
            type: DataType.MQTT_TOPIC
            defaultData: "piklema/test"
        }

        CustomDataField {
            id: _fileData

            anchors {
                top: _topicData.bottom
                topMargin: _internal.margins
                left: parent.left
                leftMargin: _internal.margins
                right: parent.right //_fileOpen.left
                rightMargin: _internal.margins
            }

            height: _internal.heightBlock

            textData: "FilePath"
            type: DataType.FILE_PATH
            defaultData: ""
        }

//        CustomButton {
//            id: _fileOpen

//            anchors {
//                right: parent.right
//                rightMargin: _internal.margins
//                bottom: _fileData.bottom
//            }

//            height: _internal.heightBlock / 4 * 3 - 5
//            width: 70
//            visible: false

//            text: "File"

//            onClicked: {
//                fileDialog.open()
//                _internal.resetFocusProperty()
//            }
//        }
    }

    Rectangle {
        id: _info

        width: parent.width / 3 * 2
        height: parent.height / 2
        radius: 10
        anchors.centerIn: parent

        visible: false

        Text {
            anchors.fill: parent
            anchors.margins: _internal.margins

            font.pointSize: 12
            text: _internal.messageInfo
        }

        Item {

            anchors.bottom: parent.bottom
            anchors.bottomMargin: _internal.margins * 2
            anchors.horizontalCenter: parent.horizontalCenter

            width: 250

            CustomButton {
                id: _buttonSendAdd

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: _internal.margins
                }

                height: _internal.heightBlock / 2
                width: 100

                text: "Send more"
                visible: false

                onClicked: {
                    _internal.hideInfoBox()
                }
            }

            CustomButton {
                id: _buttonDisconnect

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: _internal.margins
                }

                height: _internal.heightBlock / 2
                width: 100

                text: _internal.statusBroker == DataType.CONNECTED ?
                          "Disconnect" : "Cancel"

                onClicked: {
                    control.disconnectBroker()
                    _internal.hideInfoBox()
                }
            }
        }
    }


    CustomButton {
        id: _runButton

        anchors {
            bottom: parent.bottom
            bottomMargin: _internal.margins * 2
            horizontalCenter: parent.horizontalCenter
        }

        height: _internal.heightBlock / 4 * 3 - 5
        width: 70

        text: "RUN"

        onClicked: {
            _internal.resetFocusProperty()
            if ( _internal.statusBroker == DataType.CONNECTED)
                _internal.showInfoBox()
            control.run()
        }
    }
}

