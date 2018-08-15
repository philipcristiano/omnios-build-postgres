PROJECT=postgres
VERSION=10.5
SAFE_VERSION=105
PROJECT_NAME=${PROJECT}-${SAFE_VERSION}
PROJECT_VERSION=${VERSION}
DOWNLOAD_SRC=https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
LOCAL_SRC_TAR=src.tar.gz2
LOCAL_SRC=postgresql-${VERSION}

PREFIX="${HOME}/build/postgresql-${VERSION}"
TARGET_DIRECTORY=/opt/postgresql-${SAFE_VERSION}
PKG_BUILD_DIR="${PREFIX}"

export TARGET_DIRECTORY

CONFIGURE_OPTS="--enable-thread-safety --enable-debug --with-openssl --with-libxml --prefix=${PREFIX} --with-readline"


clone:
	curl ${DOWNLOAD_SRC} -o ${LOCAL_SRC_TAR}
	tar -xf ${LOCAL_SRC_TAR}
	@ls

build:
	cd ${LOCAL_SRC}; ./configure "${CONFIGURE_OPTS}"
	cd ${LOCAL_SRC}; make -j 8
	cd ${LOCAL_SRC}; make install

package:
	@echo do packagey things!
	mkdir -p ${IPS_BUILD_DIR}/opt/ ${IPS_TMP_DIR}
	cp -r ${PREFIX} ${IPS_BUILD_DIR}

	# SMF
	mkdir -p ${IPS_BUILD_DIR}/lib/svc/manifest/database/
	mkdir -p ${IPS_BUILD_DIR}/lib/svc/method/
	cp smf.xml ${IPS_BUILD_DIR}/lib/svc/manifest/database/${PROJECT}.xml
	cp method ${IPS_BUILD_DIR}/lib/svc/method/postgres-${SAFE_VERSION}

publish: ips-package
ifndef PKGSRVR
	echo "Need to define PKGSRVR, something like http://localhost:10000"
	exit 1
endif
	pkgsend publish -s ${PKGSRVR} -d ${IPS_BUILD_DIR} ${IPS_TMP_DIR}/pkg.pm5.final
	pkgrepo refresh -s ${PKGSRVR}

include ips.mk
