include( breakpad.pro.inc )
include( debug.pro.inc )
#win32:include( manifest.pro.inc )
include( QtOverride.pro.inc )

# for #include <lastfm/*.h>
INCLUDEPATH += $$ROOT_DIR/lib

linux*:CONFIG += link_pkgconfig

CONFIG( service ) {
    CONFIG += plugin
    TARGET = $$TARGET.service
}

CONFIG( extension ) {
    CONFIG += plugin
    TARGET = $$TARGET.extension
}

CONFIG( core ):LIBS += -lcore
CONFIG( ws ) {
    LIBS += -lws
    QT += xml network
}
CONFIG( types ):LIBS += -ltypes
CONFIG( unicorn ):LIBS += -lunicorn
CONFIG( moose ):LIBS += -lmoose
CONFIG( radio ):LIBS += -lradio
CONFIG( scrobble ):LIBS += -lscrobble
CONFIG( fingerprint ):LIBS += -lfingerprint

CONFIG( qtestlib ) {
    DESTDIR = $$DESTDIR/tests
}

CONFIG( taglib ) {
    CONFIG += link_pkgconfig
    PKGCONFIG += taglib
    win32:debug:LIBS += tagd.lib    # tagd.lib will precede PKGCONFIG added libs
}

CONFIG( mad ) {
    win32: LIBS += -L$$COMMON_LIBS_DIR/libmad -lmad
    else {
        CONFIG += link_pkgconfig
        PKGCONFIG += mad
    } 
}


CONFIG( fftw3f ) {
    win32: LIBS += -L$$COMMON_LIBS_DIR/libfftw -lfftw3f
    else {
        CONFIG += link_pkgconfig
        PKGCONFIG += fftw3f
    }
}


CONFIG( samplerate ) {
    win32: LIBS += -L$$COMMON_LIBS_DIR/libsamplerate -lsamplerate
    else: {
        CONFIG += link_pkgconfig
        PKGCONFIG += samplerate
    }
}

CONFIG( sqlite3 ) {
    !macx*{
        CONFIG += link_pkgconfig
        PKGCONFIG += sqlite3
    }
    else:LIBS += -lsqlite3
}

defineTest( generateVersionHeader ) {
	DEFINE = $${LITERAL_HASH}define

	win32 {
		# Windows is different for some reason :( *cries*
	    system( echo '$$DEFINE VERSION "$$VERSION"' > version.h )
	}
	else {
	    system( echo \\'$$DEFINE VERSION \\\"$$VERSION\\\"\\' > version.h )
	}
}


defineReplace( findSources ) {
    return( $$system( perl $$ROOT_DIR/common/qmake/findSources.pl $$1 $$2 ) )
}


# you also need to QMAKE_EXTRA_INCLUDES += Makefile.dmg sadly
defineReplace( generateInstallerMakefile ) {
	macx*:!macx-xcode:release:contains( TEMPLATE, app ) {
		system( QT=\'$$QT\' QMAKE_LIBDIR_QT=\'$$QMAKE_LIBDIR_QT\' $$ROOT_DIR/common/dist/mac/Makefile.dmg.pl $$DESTDIR $$VERSION $$LIBS > Makefile.dmg )
		return( Makefile.dmg )
	}
}


# for install stuff
target.path = $$INSTALL_DIR/lib


linux*:contains( QT, phonon ) {
    # use KDE phonon if installed in preference
    LIBS += -L$$system( kde4-config --prefix )/lib
}
