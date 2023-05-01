#include "mqttControl.h"

MqttControl::MqttControl(QObject *parent)
    : QObject{parent}
{
    m_client = new QMqttClient(this);

    connect(m_client, &QMqttClient::stateChanged, this, &MqttControl::updateStateMqttSlot);
    connect(m_client, &QMqttClient::disconnected, this, &MqttControl::disconectedMqtt);
    connect(m_client, &QMqttClient::errorChanged, this, &MqttControl::errorMqtt);
}

bool MqttControl::setData(Info::TYPE_DATA _type, const QString _data)
{
    qDebug()<<"MqttControl::setData: type->"<<_type<<"data->"<<_data;

    bool result = true;
    switch (_type) {
        case Info::TYPE_DATA::MQTT_HOST:
            m_client->setHostname(_data);
            break;
        case Info::TYPE_DATA::MQTT_PORT:
            result = setPort(_data);
            break;
        case Info::TYPE_DATA::MQTT_USERNAME:
            m_client->setUsername(_data);
            break;
        case Info::TYPE_DATA::MQTT_PASSWORD:
            m_client->setPassword(_data);
            break;
        case Info::TYPE_DATA::MQTT_TOPIC:
            m_topincMqtt = _data;
            break;
        default:
            result = false;
    }
    return result;
}

bool MqttControl::publishMessage(const QString _message)
{
//    qDebug()<<"MqttControl::publishMessage topic: " << m_topincMqtt
//                 << ", message: " << _message;

    bool result = false;

    if (m_client->state() == QMqttClient::ClientState::Connected &&
        !m_topincMqtt.isEmpty() && !_message.isEmpty())
            if (m_client->publish(QMqttTopicName(m_topincMqtt), _message.toUtf8()) != -1)
                result = true;

    return result;
}

void MqttControl::connectMqtt()
{
    if (m_client->state() == QMqttClient::Disconnected && !m_client->hostname().isEmpty())
            m_client->connectToHost();
}

void MqttControl::disconnectMqtt()
{
    if (m_client->state() != QMqttClient::Disconnected)
            m_client->disconnectFromHost();
}

void MqttControl::updateStateMqttSlot()
{
    qDebug()<<"MqttControl::updateStateMqtt state: " << m_client->state();

    switch (m_client->state()) {
    case QMqttClient::Disconnected:
            emit disconected();
            break;
    case QMqttClient::Connecting:
            emit connecting();
            break;
    case QMqttClient::Connected:
            emit connected();
            break;
    default:
            break;
    }
}

void MqttControl::disconectedMqtt()
{
     qDebug()<<"MqttControl::disconectedMqtt";
}

void MqttControl::errorMqtt(QMqttClient::ClientError error)
{
     qDebug()<<"MqttControl::errorMqtt error: " << error;
}

bool MqttControl::setPort(const QString _port)
{
    bool result;
    int port = _port.toInt(&result);
    if (result) m_client->setPort(port);
    return result;
}

