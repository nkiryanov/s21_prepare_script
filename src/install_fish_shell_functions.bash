#!/bin/bash

get_fish_app_latest_download_link() {
  # Get the latest version of macOS fish.app
  # It could be used to copy shell executable to user's binary dirrectory
  local fish_last_release="https://api.github.com/repos/fish-shell/fish-shell/releases/latest"
  local fish_download_link

  fish_download_link=$(curl --silent "${fish_last_release}" | grep "browser_download_url.*app\.zip" | grep --only-matching "https.*app\.zip")
  
  echo "${fish_download_link}"
}

install_fish_shell_binaries() {
  # Copy fish binaries form 'fish.app' to 'fish_binary_prefix'
  # After that you could add 'fish_binary_prefix' to PATH and use fish shell without 'fish.app'
  #
  # Mostly copypasted form the 'fish.app/Contents/Resources/install.sh'

  # Die if anything has an error
  set -e

  local fish_app_directory="${1:?Fish app dirrectory was not provided}"
  local fish_binary_prefix="${2:?Fish binary prefix was not provided}"
  local fish_resource_directory
  local fish_binary_directory

  fish_resource_directory="${fish_app_directory}/fish.app/Contents/Resources"
  fish_binary_directory="${fish_binary_prefix}/usr/local/bin/"

  echo_info "Installing fish shell from the '${fish_app_directory}.fish.app' to the '${fish_binary_directory}'"

  # Ditto the base directory to the right place
  mkdir -p "${fish_binary_prefix}"
  ditto "${fish_resource_directory}/base" "${fish_binary_prefix}"

  # Add fish_binary_prefix directory to zsh path
  add_path_to_zsh_path_env "${fish_binary_directory}" "Add manually installed fish location to PATH"

  # Announce our success
  echo_info "Fish succeffully installed to '${fish_binary_directory}' and added to path. Run 'fish' to start it"
}

install_fish_shell_app() {
  # Download fish macos executable and save it to '$application' dirrectory
  local applications="${1:?Applications dirrectory has to be set}"

  echo_info "Installing fish shell app to '${applications}' directory"

  mkdir -p "${applications}"

  local fish_app_link
  local fish_app_archive
  local status
  fish_app_link="$(get_fish_app_latest_download_link)"
  fish_app_archive="${applications}/fish_app.zip"

  # Set hardcoded fish app link if actual app version could not captured.
  # It may happened if to many API requests executed and github throttle the requests
  if [[ -z "${fish_app_link}" ]]; then
    fish_app_link="https://github.com/fish-shell/fish-shell/releases/download/3.6.4/fish-3.6.4.app.zip"
  fi

  curl --silent --location "${fish_app_link}" --output "${fish_app_archive}"
  unzip -uq "${fish_app_archive}" -d "${applications}"
  rm "${fish_app_archive}"; status=$?

  if [[ ${status} -eq 0 ]]; then
    echo_info "fish app successfully installed"
  else 
    echo_error "Some errors occuried while installing fish"
  fi
}

copy_fish_dot_files() {
  local fish_dot_files_path="${1:?The fish dot files location is required}"
  local fish_dot_files_to_copy_to="${HOME}/.config/fish"

  cp -R "${fish_dot_files_path}" "${fish_dot_files_to_copy_to}"

  echo_info "Fish dot files copyed from '${fish_dot_files_path}' to '${fish_dot_files_to_copy_to}'"
}
