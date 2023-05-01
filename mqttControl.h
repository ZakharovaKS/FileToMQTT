#ifndef MQTTCONTROL_H
#define MQTTCONTROL_H

#include <QObject>
#include <QMqttClient>

#include "info.h"

class MqttControl : public QObject
{
    Q_OBJECT
public:
    explicit MqttControl(QObject *parent = nullptr);

    bool setData(Info::TYPE_DATA _type, const  QString _data);
    bool publishMessage(const QString _message);
    void connectMqtt();
    void disconnectMqtt();

signals:
    void sentMessageError(const QString errorMessage);
    void disconected();
    void connected();
    void connecting();

private slots:
    void updateStateMqttSlot();
    void disconectedMqtt();
    void errorMqtt(QMqttClient::ClientError error);

private:
    QMqttClient *m_client;
    QString m_topincMqtt;

    bool setPort(const QString _port);
};

#endif // MQTTCONTROL_H
