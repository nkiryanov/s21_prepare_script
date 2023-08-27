#!/bin/bash

#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)/"
LIB_FUNCTIONS="${SCRIPT_ROOT}functions.bash"

source "$LIB_FUNCTIONS"


install_brew_goinfree
# install_brew_packages
