#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)"
LIB_COMMON_FUNCTIONS="${SCRIPT_ROOT}/src/common_functions.bash"
LIB_INSTALL_FISH_SHELL_FUNCTIONS="${SCRIPT_ROOT}/src/install_fish_shell_functions.bash"

source "${LIB_COMMON_FUNCTIONS}"
source "${LIB_INSTALL_FISH_SHELL_FUNCTIONS}"

USER_GOINFRE="/opt/goinfre/${USER}"
GOINFRE_APPLICATIONS="${USER_GOINFRE}/Applications"
FISH_DOT_FILES="${SCRIPT_ROOT}/config/fish"


install_fish_shell_app "${GOINFRE_APPLICATIONS}"
install_fish_shell_binaries "${GOINFRE_APPLICATIONS}" "${USER_GOINFRE}"
copy_fish_dot_files "${FISH_DOT_FILES}"
