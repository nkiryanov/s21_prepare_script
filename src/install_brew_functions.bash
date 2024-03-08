#!/bin/bash

set_brew_available_at_new_shell_opened() {
  # Add the line to run 'brew shellenv' on every interactive shell
  # It adds 'brew prefix' to PATH under the hood
  local homebrew_location="${1:?the location of the homewbrew must provided}"

  local brew_eval_cmd
  local brew_eval_commnet

  # 'brew_eval_cmd' should looks like 'eval "$(/opt/goinfre/username/homebrew/bin/brew shellenv)"'
  brew_eval_cmd="eval \"\$(${homebrew_location}/bin/brew shellenv)\""
  brew_eval_commnet="The command to set brew to the environment variables. The defualt installation script do that."

  # Add brew_eval command to run on every interactive Z-shell (as it default in macos)
  # https://zsh.sourceforge.io/Guide/zshguide02.html
  add_line_to_file "${HOME}/.zshrc" "${brew_eval_cmd}" "${brew_eval_commnet}"
}

install_brew() {
  local homebrew_location="${1:?Homewbrew location has to be set}"

  git clone https://github.com/Homebrew/brew "${homebrew_location}"

  eval "$("${homebrew_location}"/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
}

install_brew_if_needed() {
  local install_location="${1:?Install brew location has to be set}"
  local homebrew_location="${install_location}/homebrew"
  local -i is_brew_found

  command --search brew &> /dev/null
  is_brew_found=$?

  if [[ $is_brew_found -ne 0 ]]; then
    echo_info "It's looks like homewbrew not installed. Do it"
    echo_info "Install location ${homebrew_location}"

    install_brew "${homebrew_location}"
  
    set_brew_available_at_new_shell_opened "${homebrew_location}"
  else
    echo_info "It's looks like homebrew installed already (at least the 'brew' executable found in PATH)"
  fi
}
