/*
#include <QCoreApplication>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QDebug>

int main(int argc, char ** argv)
{
    QCoreApplication app(argc, argv);

    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl("qrc:main.qml"));

    return 0;
}
*/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "uiprocess.h"
#include "processdata.h"

//#include "datacodes.h"

int main(int argc, char *argv[])
{
    ProcessData Pdata;
    Pdata.CreateDirectories();
    Pdata.PrepareUIData();    
    Pdata.CheckFiles();

   // DataCodes DC; // hold here for testing
   // DC.PrepareFileData();


    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<UIProcess>("UIProcess", 1, 0, "UIProcess");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
