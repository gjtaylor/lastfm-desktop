TARGET = listener
TEMPLATE = lib
QT = core xml network
CONFIG += unicorn

# basically not easy to support on other platforms, but feel free to fork
linux*:QT += dbus

include( $$ROOT_DIR/admin/include.qmake )

DEFINES += _LISTENER_DLLEXPORT LASTFM_COLLAPSE_NAMESPACE

win32:LIBS += Advapi32.lib

SOURCES += \
	PlayerMediator.cpp \
	PlayerListener.cpp \
	PlayerConnection.cpp \
	PlayerCommandParser.cpp \
	legacy/LegacyPlayerListener.cpp \
    DBusListener.cpp
    
HEADERS += \
	State.h \
	PlayerMediator.h \
	PlayerListener.h \
	PlayerConnection.h \
	PlayerCommandParser.h \
	PlayerCommand.h \
	legacy/LegacyPlayerListener.h \
	DBusListener.h