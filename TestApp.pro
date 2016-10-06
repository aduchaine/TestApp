QT += qml quick

CONFIG += c++11

HEADERS += \
    uiprocess.h \
    processdata.h \
    datacodes.h \
    datacodes_test.h


SOURCES += main.cpp \
    uiprocess.cpp \
    processdata.cpp \
    datacodes.cpp \
    datacodes_test.cpp


RESOURCES += qml.qrc

# windows icon
win32: RC_ICONS = Resources\ad_icon.ico

# apple icon
ICON = Resources\ad_icon.icns

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    ToDoList
