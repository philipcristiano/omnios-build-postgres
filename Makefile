PROJECT=dalmatinerdb
VERSION=10.5
PROJECT_VERSION=${VERSION}
DOWNLOAD_SRC=https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2
LOCAL_SRC_TAR=src.tar.gz2
LOCAL_SRC=postgresql-${VERSION}
RELEASE_DIR=src/_build/default/rel

PREFIX=/opt/postgresql-${VERSION}
TARGET_DIRECTORY=${PREFIX}
export TARGET_DIRECTORY

CONFIGURE_OPTS="--enable-thread-safety
    --enable-debug
    --with-openssl
    --with-libxml
    --prefix=${PREFIX}
    --with-readline"


clone:
	curl ${DOWNLOAD_SRC} -o ${LOCAL_SRC_TAR}
	tar -xf ${LOCAL_SRC_TAR}
	@ls

build:
	cd ${LOCAL_SRC}; ./configure ${CONFIGURE_OPTS}
	cd ${LOCAL_SRC}; make

package:
	@echo do packagey things!
	mkdir -p ${IPS_BUILD_DIR}/opt/ ${IPS_TMP_DIR} "${IPS_BUILD_DIR}/etc"
	mkdir -p ${IPS_BUILD_DIR}/data/dalmatinerdb/etc
	mv ${RELEASE_DIR}/ddb/etc/ddb.conf ${IPS_BUILD_DIR}/data/dalmatinerdb/etc/ddb.conf

	# SMF
	mkdir -p ${IPS_BUILD_DIR}/lib/svc/manifest/application/
	cp smf.xml ${IPS_BUILD_DIR}/lib/svc/manifest/application/${PROJECT}.xml

  # Remove git files/dirs
	( find ${RELEASE_DIR} -type d -name ".git" && find ${RELEASE_DIR} -name ".gitignore" && find ${RELEASE_DIR} -name ".gitmodules" ) | xargs -d '\n' rm -rf
	cp -R ${RELEASE_DIR} ${IPS_BUILD_DIR}/opt/${PROJECT}
	rm -rf ${IPS_BUILD_DIR}/opt/${PROJECT}/${PROJECT}_release-*.tar.gz
	cp LICENSE.pkg ${IPS_BUILD_DIR}/

publish: ips-package
ifndef PKGSRVR
	echo "Need to define PKGSRVR, something like http://localhost:10000"
	exit 1
endif
	pkgsend publish -s ${PKGSRVR} -d ${IPS_BUILD_DIR} ${IPS_TMP_DIR}/pkg.pm5.final
	pkgrepo refresh -s ${PKGSRVR}

include erlang-ips.mk
