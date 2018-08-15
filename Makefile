PROJECT=dalmatinerdb
VERSION=10.5
PROJECT_VERSION=${VERSION}
DOWNLOAD_SRC=https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
LOCAL_SRC_TAR=src.tar.gz2
LOCAL_SRC=postgresql-${VERSION}
RELEASE_DIR=src/_build/default/rel

PREFIX=build/postgresql
TARGET_DIRECTORY=/opt/postgresql-${VERSION}
export TARGET_DIRECTORY

CONFIGURE_OPTS="--enable-thread-safety --enable-debug --with-openssl --with-libxml --prefix=${PREFIX} --with-readline"


clone:
	curl ${DOWNLOAD_SRC} -o ${LOCAL_SRC_TAR}
	tar -xf ${LOCAL_SRC_TAR}
	@ls

build:
	cd ${LOCAL_SRC}; ./configure "${CONFIGURE_OPTS}"
	cd ${LOCAL_SRC}; make -j 4

