#include "control.h"

Control::Control(QObject *parent)
    : QObject{parent}
{
    m_mqttControl = new MqttControl(this);
    m_statusMqtt = Info::STATUS_MQTT::DISSCONNECTED;

    connect(m_mqttControl, MqttControl::disconected, this, Control::disconnectedBroker);
    connect(m_mqttControl, MqttControl::connecting, this, Control::connectingBroker);
    connect(m_mqttControl, MqttControl::connected, this, Control::connectedBroker);
}

bool Control::setData(int _type, const QString _data)
{
    Info::TYPE_DATA type = convertIntData(_type);

    qDebug()<<"Control::setData: type:"<< type <<", data"<< _data;

    bool result = true;

    if (type == Info::TYPE_DATA::FILE_PATH)
        result = m_fileControl.setPathFile(_data);
    else
        result = m_mqttControl->setData(type,_data);

    return result;
}

void Control::run()
{
    if (m_statusMqtt == Info::STATUS_MQTT::DISSCONNECTED)
    {
        m_mqttControl->connectMqtt();
    }
    else
        sentDataFile();
}

void Control::disconnectBroker()
{
    m_mqttControl->disconnectMqtt();
}


Info::TYPE_DATA Control::convertIntData(int _data)
{
    if((_data < static_cast<int>(Info::TYPE_DATA::UNDEFINED)) || (static_cast<int>(Info::TYPE_DATA::FILE_PATH) < _data))
        return Info::TYPE_DATA::UNDEFINED;

    return static_cast<Info::TYPE_DATA>(_data);
}

void Control::sentDataFile()
{
    QQueue<QString> fileData = m_fileControl.readFile();
    int countMessage = 0;

    //qDebug()<< fileData;

    emit fileFeadFinish(fileData.length());

    while (!fileData.isEmpty()) {
        if (!m_mqttControl->publishMessage(fileData.dequeue()))
        {
            break;
        }
        countMessage++;
    }

    emit sendMessageFinish(countMessage);
}

void Control::connectedBroker()
{
    m_statusMqtt = Info::STATUS_MQTT::CONNECTED;
    emit statusMqttChanged();
    sentDataFile();
}

void Control::connectingBroker()
{
    m_statusMqtt = Info::STATUS_MQTT::CONNECT;
    emit statusMqttChanged();
}

void Control::disconnectedBroker()
{
    m_statusMqtt = Info::STATUS_MQTT::DISSCONNECTED;
    emit statusMqttChanged();
}

int Control::statusMqtt() const
{
    return m_statusMqtt;
}
