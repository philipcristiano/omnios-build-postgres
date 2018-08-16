PROJECT=postgresql
VERSION=10.5
SAFE_VERSION=105
PROJECT_NAME=${PROJECT}-${SAFE_VERSION}
PROJECT_VERSION=${VERSION}
DOWNLOAD_SRC=https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
LOCAL_SRC_TAR=src.tar.gz2
LOCAL_SRC=postgresql-${VERSION}

USERNAME=postgres
GROUPNAME=postgres

PREFIX="${HOME}/build/postgresql-${VERSION}"
PKG_BUILD_DIR="${PREFIX}"
LD_RUN_PATH="$ORIGIN/../lib"
export LD_RUN_PATH

CONFIGURE_OPTS="--enable-thread-safety --enable-debug --with-openssl --with-libxml --prefix=${PREFIX} --with-readline --disable-rpath"


clone:
	curl ${DOWNLOAD_SRC} -o ${LOCAL_SRC_TAR}
	tar -xf ${LOCAL_SRC_TAR}
	@ls

build:
	cd ${LOCAL_SRC}; ./configure "${CONFIGURE_OPTS}"
	cd ${LOCAL_SRC}; make -j 8 world
	cd ${LOCAL_SRC}; make install-world

package:
	@echo do packagey things!
	mkdir -p ${IPS_BUILD_DIR}/opt/ ${IPS_TMP_DIR}
	cp -r ${PREFIX} ${IPS_BUILD_DIR}/opt

	# SMF
	mkdir -p ${IPS_BUILD_DIR}/lib/svc/manifest/database/
	mkdir -p ${IPS_BUILD_DIR}/lib/svc/method/
	cp smf.xml ${IPS_BUILD_DIR}/lib/svc/manifest/database/${PROJECT_NAME}.xml
	cp method ${IPS_BUILD_DIR}/lib/svc/method/${PROJECT_NAME}

publish: ips-package
ifndef PKGSRVR
	echo "Need to define PKGSRVR, something like http://localhost:10000"
	exit 1
endif
	pkgsend publish -s ${PKGSRVR} -d ${IPS_BUILD_DIR} ${IPS_TMP_DIR}/pkg.pm5.final
	pkgrepo refresh -s ${PKGSRVR}

include ips.mk
