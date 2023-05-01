#ifndef INFO_H
#define INFO_H

#include <QObject>

class Info : public QObject
{
    Q_GADGET
public:
    enum TYPE_DATA {
        UNDEFINED = 0,
        MQTT_HOST,
        MQTT_PORT,
        MQTT_USERNAME,
        MQTT_PASSWORD,
        MQTT_TOPIC,
        FILE_PATH
    };
    Q_ENUM(TYPE_DATA)

    enum STATUS_MQTT {
        DISSCONNECTED = 0,
        CONNECT,
        CONNECTED
    };
    Q_ENUM(STATUS_MQTT)
};

#endif // INFO_H
