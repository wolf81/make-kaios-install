PORT_DEVICE = localfilesystem:/data/local/debugger-socket
PORT_LOCAL = 6000
XPCSHELL = ./xulrunner-sdk/bin/xpcshell
ADB = /usr/local/bin/adb
ID ?= ${shell basename ${FOLDER} | tr A-Z a-z}
PLATFORM = mac-x86_64
XULRUNNER_VERSION = 18.0.2
XULRUNNER_URL = https://ftp.mozilla.org/pub/xulrunner/releases/${XULRUNNER_VERSION}/sdk/xulrunner-${XULRUNNER_VERSION}.en-US.${PLATFORM}.sdk.tar.bz2

.PHONY: _default
_default: packaged install

xulrunner-sdk/bin/xpcshell:
	$(info Downloading xulrunner...)
	curl -o /tmp/xulrunner.tar.bz2 "${XULRUNNER_URL}"
	$(info Extracting xulrunner...)
	tar -xvf /tmp/xulrunner.tar.bz2

${FOLDER}/application.zip:
	$(info "ZIPPING ${FOLDER} into application.zip")
	cd ${FOLDER} && zip -Xr ./application.zip ./* -x application.zip *.appcache

.PHONY: packaged
packaged: ${FOLDER}/application.zip
	$(info "PUSHING *${ID}* as packaged app")
	${ADB} push ${FOLDER}/application.zip /data/local/tmp/b2g/${ID}/application.zip

.PHONY: hosted
hosted:
	$(info "PUSHING *${ID}* as hosted app")
	${ADB} push ${FOLDER}/manifest.webapp /data/local/tmp/b2g/${ID}/manifest.webapp
	${ADB} push ${FOLDER}/metadata.json /data/local/tmp/b2g/${ID}/metadata.json

.PHONY: install
install: xulrunner-sdk/bin/xpcshell
	$(info "FORWARDING device port ${PORT_DEVICE} to ${PORT_LOCAL}")
	${ADB} forward tcp:${PORT_LOCAL} ${PORT_DEVICE}
	LD_LIBRARY_PATH=${shell pwd}/xulrunner-sdk/bin ${XPCSHELL} install.js ${ID} ${PORT_LOCAL}
