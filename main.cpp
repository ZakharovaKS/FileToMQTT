#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "kernel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Kernel kernel;
    kernel.start();

    return app.exec();
}
