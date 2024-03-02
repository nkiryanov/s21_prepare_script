#!/bin/bash

# shellcheck disable=SC1090

SCRIPT_ROOT="$(cd "${0%/*}" && pwd)"
LIB_COMMON_FUNCTIONS="${SCRIPT_ROOT}/src/common_functions.bash"
LIB_INSTALL_BREW_FUNCTIONS="${SCRIPT_ROOT}/src/install_brew_functions.bash"

source "${LIB_COMMON_FUNCTIONS}"
source "${LIB_INSTALL_BREW_FUNCTIONS}"

USER_GOINFRE="/opt/goinfre/${USER}"
GOINFRE_APPLICATIONS="${USER_GOINFRE}/Applications"
BREW_PACKAGES_TO_INSTALL=(
  'pkg-config'
  'pyenv'
)
BREW_CASKS_TO_INSTALL=(
  'telegram'
  'postico'
  'yandex-music-unofficial'
)

# Run small configurations scripts
add_vs_code_binary_zsh_path_env
add_user_docker_binary_to_zsh_path_env
move_docker_data_to_location "${USER_GOINFRE}"

# Install brew
install_brew_if_needed "${USER_GOINFRE}"

# Install brew cask Applications
mkdir -p "${GOINFRE_APPLICATIONS}"
brew install --cask --appdir "${GOINFRE_APPLICATIONS}" "${BREW_CASKS_TO_INSTALL[@]}"

# Install brew command line utilities
brew install "${BREW_PACKAGES_TO_INSTALL[@]}"
