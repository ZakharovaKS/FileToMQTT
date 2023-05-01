#ifndef CONTROL_H
#define CONTROL_H

#include <QObject>
#include "mqttControl.h"
#include "fileControl.h"
#include "info.h"


class Control : public QObject
{
    Q_OBJECT

public:
    explicit Control(QObject *parent = nullptr);

    Q_PROPERTY(int statusMqtt READ statusMqtt NOTIFY statusMqttChanged)

    Q_INVOKABLE bool setData(int _type, const QString _data);
    Q_INVOKABLE void run();
    Q_INVOKABLE void disconnectBroker();

    int statusMqtt() const;

signals:
    void statusMqttChanged();
    void fileFeadFinish(int countLine);
    void sendMessageFinish(int countMessage);

private:
    MqttControl *m_mqttControl;
    FileControl m_fileControl;
    int m_statusMqtt;

    Info::TYPE_DATA convertIntData(int _data);
    void sentDataFile();
    void connectedBroker();
    void connectingBroker();
    void disconnectedBroker();

};

#endif // CONTROL_H
