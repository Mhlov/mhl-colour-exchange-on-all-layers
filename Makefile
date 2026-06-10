CURRENT_DIR=$(shell pwd -P)
FILE_NAME=mhl-colour-exchange-on-all-layers.scm
TARGET_DIR=${HOME}/.config/GIMP/3.2/scripts

TARGET_FILE=${TARGET_DIR}/${FILE_NAME}

ORIGIN_FILE=${CURRENT_DIR}/${FILE_NAME}

help:
	@echo "Usage:"
	@echo "\tmake install | link | uninstall"


install:
	@test -e "${TARGET_FILE}" || \
		cp "${ORIGIN_FILE}" "${TARGET_FILE}"

link:
	@test -e "${TARGET_FILE}" || \
		ln -s "${ORIGIN_FILE}" "${TARGET_FILE}"

uninstall:
	@test -e "${TARGET_FILE}" && \
		rm "${TARGET_FILE}"

