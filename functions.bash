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
  # Install brew to provided location
  # The script just do the steps https://docs.brew.sh/Installation#untar-anywhere-unsupported
  local homebrew_location="$1"

  git clone https://github.com/Homebrew/brew "$homebrew_location"

  eval "$("${homebrew_location}"/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
}

set_brew_available_at_new_shell_opened() {
  # Add the line to run 'brew shellenv' on every interactive shell
  # It adds 'brew prefix' to PATH under the hood
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
}

install_brew_if_needed() {
  local install_location="$1"
  local homebrew_location="${install_location}/homebrew"

  if [[ ! -e $homebrew_location ]]; then
    echo_info "It's looks like homewbrew not installed. Do it"
    echo_info "Install location ${homebrew_location}"

    install_brew "$homebrew_location"
  else
    echo_info "It's looks like homebrew installed already"
  fi

  set_brew_available_at_new_shell_opened "${homebrew_location}"
}

move_docker_data_to_location() {
  # Move Docket library directories to 'move_locaction' directory
  local move_location="$1"
  local new_docker_data_location="${move_location}/Docker"
  local default_docker_data_location="${HOME}/Library/Containers/com.docker.docker/Data"

  mkdir -p "${new_docker_data_location}"
  mkdir -p "${default_docker_data_location}"

  rm -rf "${default_docker_data_location}"
  ln -s "${new_docker_data_location}" "${default_docker_data_location}"

  echo_info "Docker library directrories moved to goinfre"
}

get_fish_app_latest_download_link() {
  local fish_last_release="https://api.github.com/repos/fish-shell/fish-shell/releases/latest"
  local fish_download_link

  fish_download_link=$(curl --silent "${fish_last_release}" | grep "browser_download_url.*app\.zip" | grep --only-matching "https.*app\.zip")
  
  echo "$fish_download_link"
}

install_fish_shell_binaries() {
  # Copy fish binaries form 'fish.app' to 'fish_binary_prefix'
  # After that you could add 'fish_binary_prefix' to PATH and use fish shell without 'fish.app'
  #
  # Mostly copypasted form the 'fish.app/Contents/Resources/install.sh'

  # Die if anything has an error
  set -e
  local fish_app_directory="$1"
  local fish_binary_prefix="$2"
  local fish_resource_directory

  fish_resource_directory="${fish_app_directory}/fish.app/Contents/Resources"

  # Ditto the base directory to the right place
  mkdir -p "${fish_binary_prefix}"
  ditto "${fish_resource_directory}/base" "${fish_binary_prefix}"

  # Announce our success
  echo_info "fish has been installed under ${fish_binary_prefix}/"
  echo_info "To start fish, run:"
  echo_info "    ${fish_binary_prefix}/bin/fish"
}

install_fish_shell_app() {
  # Download fish macos executable and save it to 'location/Applications'
  local applications="${1}"

  mkdir -p "${applications}"

  local fish_app_link
  local fish_app_archive
  local status
  fish_app_link="$(get_fish_app_latest_download_link)"
  fish_app_archive="${applications}/fish_app.zip"

  if [[ -z "$fish_app_link" ]]; then 
    fish_app_link="https://github.com/fish-shell/fish-shell/releases/download/3.6.4/fish-3.6.4.app.zip"
  fi

  curl --silent --location "${fish_app_link}" --output "${fish_app_archive}"
  unzip -uq "${fish_app_archive}" -d "${applications}"
  rm "${fish_app_archive}"; status=$?

  if [[ $status -eq 0 ]]; then
    echo_info "fish app successfully installed"
  else 
    echo_error "Some errors occuried while installing fish"
  fi
}
