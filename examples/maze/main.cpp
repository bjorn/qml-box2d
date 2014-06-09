#include <QApplication>
#include <QtDeclarative>

#ifdef Q_WS_MAEMO_5
#include <QAccelerometer>
QTM_USE_NAMESPACE
#endif

#include "qmlapplicationviewer.h"

#include "box2dplugin.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Box2DPlugin plugin;
    plugin.registerTypes("Box2D");

    // Maemo 5 doesn't have Qt Mobility 1.1 and hence no QML bindings for Accelerometer
#ifdef Q_WS_MAEMO_5
    qmlRegisterType<QSensorReading>();
    qmlRegisterType<QAccelerometer>("QtMobility.sensors", 1, 1, "Accelerometer");
    qmlRegisterType<QAccelerometerReading>("QtMobility.sensors", 1, 1, "AccelerometerReading");
#endif

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);

#if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6) || defined(Q_OS_SYMBIAN)
    viewer.setMainQmlFile(QLatin1String("qml/maze/main.qml"));
    viewer.showFullScreen();
#else
    viewer.setMainQmlFile(QLatin1String("qml/maze/desktop.qml"));
    viewer.show();
#endif

    return app.exec();
}
