#!/bin/bash

echo_error() {
  local message=$1

  local clear="\033[0m"
  local red_bold="\033[1;31m"

  echo -e "${red_bold}Error: ${message}${clear}" >&2
}

echo_info() {
  local message=$1

  local clear='\033[0m'
  local green='\033[3;32m'

  echo -e "${green}$message${clear}"
}

install_brew() {
  local homebrew_location="$1"

  git clone https://github.com/Homebrew/brew "$homebrew_location"

  eval "$("${homebrew_location}"/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
}

set_brew_available_at_new_shell_opened() {
  local homebrew_location="$1"
  local zshrc_location="${HOME}/.zshrc"

  local brew_eval_cmd
  local -i is_eval_in_config_already

  # 'brew_eval_cmd' should looks like 'eval "$(/opt/goinfre/username/homebrew/bin/brew shellenv)"'
  brew_eval_cmd="eval \"\$(${homebrew_location}/bin/brew shellenv)\""
  is_eval_in_config_already=0

  while read -r line; do
    if [[ "$line" == "$brew_eval_cmd" ]]; then
      is_eval_in_config_already=1
      break
    fi
  done <"${zshrc_location}"

  if [[ $is_eval_in_config_already -eq 1 ]]; then
    echo_info "It's looks '${brew_eval_cmd}' in .zshrc already"
  else
    echo_info "Copy ${brew_eval_cmd} in .zshrc..."
    echo "${brew_eval_cmd}" >>"${zshrc_location}"
  fi
}

install_brew_packages() {
  brew install pkg-config
  brew install pyenv
  brew install fish
}

install_brew_goinfree() {
  local goinfre="/opt/goinfre/${USER}"
  local homebrew_location="${goinfre}/homebrew"

  if [[ ! -e $homebrew_location ]]; then
    echo_info "It's looks like homewbrew not installed. Do it"
    echo_info "Install location ${homebrew_location}"

    install_brew "$homebrew_location"
    install_brew_packages
  else
    echo_info "It's looks like homebrew installed already"
  fi

  set_brew_available_at_new_shell_opened "${homebrew_location}"
}
