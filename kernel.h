#ifndef KERNEL_H
#define KERNEL_H

#include <QtQuick/qquickview.h>
#include <QObject>
#include "control.h"

class Kernel: public QObject
{
    Q_OBJECT

public:
    Kernel(QObject *parent = nullptr);
    void start();

private:
    QQuickView m_view;
    Control m_control;
};

#endif // KERNEL_H
