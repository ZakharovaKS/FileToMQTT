#include "kernel.h"
#include "info.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

Kernel::Kernel(QObject *parent): QObject(parent)
{

}

void Kernel::start()
{
    QQmlContext *ctxt = m_view.rootContext();

    ctxt->setContextProperty("control", &m_control);
    qmlRegisterType<Info>("DataType", 1, 0, "DataType");

    m_view.setTitle("MQTT");
    m_view.setResizeMode(QQuickView::SizeRootObjectToView);
    m_view.setMinimumHeight(400);
    m_view.setMinimumWidth(600);
    m_view.setMaximumHeight(400);
    m_view.setMaximumWidth(900);
    m_view.setFlags(Qt::Window | Qt::CustomizeWindowHint | Qt::WindowTitleHint | Qt::WindowCloseButtonHint | Qt::WindowSystemMenuHint);
    m_view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    m_view.show();
}
