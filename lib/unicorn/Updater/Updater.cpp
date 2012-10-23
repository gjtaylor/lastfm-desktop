
#include "Updater.h"

#ifdef Q_OS_WIN
#include <qtsparkle/Updater>
#include <QCoreApplication>
#include <QStringList>
#endif //Q_OS_WIN

#if defined(Q_OS_WIN) || defined(Q_WS_X11)
unicorn::Updater::Updater(QObject *parent) :
    QObject(parent)
{
#if defined(Q_OS_WIN)
    QString appcast;

    if ( qApp->arguments().contains( "--update" ) )
        appcast = "http://users.last.fm/~michael/updates_win.xml";
    else if ( qApp->arguments().contains( "--update-static" ) )
        appcast = "http://static.last.fm/client/Win/updates.xml";
    else
        appcast = "http://cdn.last.fm/client/Win/updates.xml";

    m_updater = new qtsparkle::Updater( appcast, parent );
#endif
}
#endif

void
unicorn::Updater::checkForUpdates()
{
#ifdef Q_OS_WIN
    m_updater->CheckNow();
#endif
}

unicorn::Updater::~Updater()
{
}

