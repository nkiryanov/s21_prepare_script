#!/bin/bash

#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)/"
LIB_FUNCTIONS="${SCRIPT_ROOT}functions.bash"

source "$LIB_FUNCTIONS"

USER_GOINFRE="/opt/goinfre/${USER}"

install_brew_if_needed "${USER_GOINFRE}"
install_brew_packages

move_docker_data "${USER_GOINFRE}"

