#!/bin/bash

#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)/"
LIB_FUNCTIONS="${SCRIPT_ROOT}functions.bash"

source "$LIB_FUNCTIONS"

USER_GOINFRE="/opt/goinfre/${USER}"

install_brew_if_needed "${USER_GOINFRE}"
install_brew_packages
install_fish_shell_app "${USER_GOINFRE}/Applications"
install_fish_shell_binaries "${USER_GOINFRE}/Applications" "${USER_GOINFRE}"

move_docker_data_to_location "${USER_GOINFRE}"
