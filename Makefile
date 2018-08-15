PROJECT=dalmatinerdb
VERSION=10.5
PROJECT_VERSION=${VERSION}
DOWNLOAD_SRC=https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
LOCAL_SRC_TAR=src.tar.gz2
TARGET_DIRECTORY=/opt/dalmatinerdb
RELEASE_DIR=src/_build/default/rel

export TARGET_DIRECTORY

clone:
	curl ${DOWNLOAD_SRC} -o ${LOCAL_SRC_TAR}
	tar -xf ${LOCAL_SRC_TAR}
	@ls
