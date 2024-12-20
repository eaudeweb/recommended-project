#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/web/themes/custom/frontend"
SCRIPT_VERSION=0.1
echo -e "${C_LIME}Theme compilation script, version: ${SCRIPT_VERSION}${NO_FORMAT}"
C_LIME="\033[38;5;10m"
C_YELLOW="\033[38;5;11m"
C_RED="\033[38;5;9m"
NO_FORMAT="\033[0m"
NVM_HOME="$HOME/.nvm"

validate_node () {
    REQUIRED_VERSION=$(awk '/^[0-9][0-9]/' "${SCRIPT_DIR}/.nvmrc")
    ACTUAL_VERSION=$(echo "${NODE_VERSION}" | sed -n "s/^v\?\([0-9][0-9]\).*/\1/p")
    if [ "${ACTUAL_VERSION}" == "${REQUIRED_VERSION}" ];
    then
      echo -e "${C_LIME}Using existing node version ${ACTUAL_VERSION} for compilation ...${NO_FORMAT}"
    else
      echo -e "${C_RED}Incompatible node version, to compile the theme you need version ${REQUIRED_VERSION}, and you have ${ACTUAL_VERSION}. ${NO_FORMAT}"
      exit 1
    fi
}

echo -ne "${C_LIME}Looking for nvm: ${NO_FORMAT}"

if [ -d "${NVM_HOME}" ];
then
    echo -e "${C_LIME}found${NO_FORMAT}"
    echo -e "${C_LIME}Enabling Node ...${NO_FORMAT}"
    source $NVM_HOME/nvm.sh;
    cd "${SCRIPT_DIR}" && nvm install && nvm use
else
    echo -e "${C_YELLOW}not found${NO_FORMAT}"
    echo -ne "${C_LIME}Looking for existing node: ${NO_FORMAT}"
    if command -v node 2>&1 >/dev/null
    then
        NODE_VERSION=$(node -v)
        echo -e "${C_LIME}found (${NODE_VERSION})${NO_FORMAT}"
        validate_node
    else
        echo -e "${C_RED}not found${NO_FORMAT}"
        echo ""
        echo -e "${C_RED}To compile the theme you need to install node or nvm tool ${NO_FORMAT}"
        exit 1
    fi
fi

echo -e "${C_LIME}Installing packages using npm ...${NO_FORMAT}"
cd ${SCRIPT_DIR} && npm install --no-audit --silent

echo -e "${C_LIME}Compiling theme ...${NO_FORMAT}"
cd ${SCRIPT_DIR} && which node && npm run build --silent

echo -e "${C_LIME}Done.${NO_FORMAT}"
