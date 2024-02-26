#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)"
LIB_COMMON_FUNCTIONS="${SCRIPT_ROOT}/src/common_functions.bash"
LIB_INSTALL_BREW_FUNCTIONS="${SCRIPT_ROOT}/src/install_brew_functions.bash"
LIB_INSTALL_FISH_SHELL_FUNCTIONS="${SCRIPT_ROOT}/src/install_fish_shell_functions.bash"

source "$LIB_COMMON_FUNCTIONS"
source "$LIB_INSTALL_BREW_FUNCTIONS"
source "$LIB_INSTALL_FISH_SHELL_FUNCTIONS"

USER_GOINFRE="/opt/goinfre/${USER}"
BREW_PACKAGES_TO_INSTALL=(
  'pkg-config'
  'pyenv'
)

install_fish_shell_app "${USER_GOINFRE}/Applications"
install_fish_shell_binaries "${USER_GOINFRE}/Applications" "${USER_GOINFRE}"
move_docker_data_to_location "${USER_GOINFRE}"
add_user_docker_binary_to_zsh_path_env
add_vs_code_binary_zsh_path_env

install_brew_if_needed "${USER_GOINFRE}"
brew install "${BREW_PACKAGES_TO_INSTALL[@]}"
