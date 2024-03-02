#!/bin/bash

# Commonly used functions

echo_error() {
  local message="${1:?Message has to be provided}"

  local clear="\033[0m"
  local red_bold="\033[1;31m"

  echo -e "${red_bold}Error: ${message}${clear}" >&2
}

echo_info() {
  local message="${1:?Message has to be provided}"

  local clear='\033[0m'
  local green='\033[3;32m'

  echo -e "${green}${message}${clear}"
}

add_line_to_file() {
  # Add the provided line to the file
  # The parameters:
  #    1. File location where the line should be added
  #    2. line_to_add
  #    3. optional: commnent that should be added before the line
  # The second argument may be a comment that should be added before line
  # 
  # Usage exmaple:
  #    add_line_to_file "${HOME}/.zshrc" "echo hello" "print hello when shell opened just for fun"

  local file_location="${1:?File location has to be provied}"
  local line_to_add="${2:?Second argument must be the line to add to the file}"
  local comment_before_line="${3:-not-set}"  # provided comment or 'not-set'

  local -i is_line_in_file_already
  is_line_in_file_already=0

  # Look for the variable '$line_to_add' in the file
  while read -r line; do
    if [[ "${line}" == "${line_to_add}" ]]; then
      is_line_in_file_already=1
      break
    fi
  done <"${file_location}"

  if [[ ${is_line_in_file_already} -eq 1 ]]; then
    echo "It's looks '${line_to_add}' in '${file_location}' already"
  else
    echo "Copying line '${line_to_add}' to the '${file_location}'"

    echo >> "${file_location}"

    if [[ "${comment_before_line}" != "not-set" ]]; then
      echo "# ${comment_before_line}" >> "${file_location}"
    fi

    echo "${line_to_add}" >> "${file_location}"
  fi
}

add_path_to_zsh_path_env() {
  # Add provided 'path' to zsh paths.
  # Actually it only add it to the {HOME}/.zshenv as documentation recommnds
  # https://zsh.sourceforge.io/Guide/zshguide02.html#l24
  #
  # Just if do not know what is $PATH for:
  # https://www.gnu.org/software/bash/manual/bash.html#Executing-Commands
  
  local path_to_add="${1:?The path has to be provided}"
  local comment_to_add="${2:-not-set}"
  local zshenv_location="${HOME}/.zshenv"
  local command_to_add

  if [[ ! -r "${zshenv_location}" ]]; then
    touch "${zshenv_location}"
  fi

  command_to_add="path=(${path_to_add} \$path)"

  # Use provided comment or use the default one
  if [[ "${comment_to_add}" == "not-set" ]]; then
    comment_to_add="Adding '${path_to_add}' to PATH varibles"
  fi

  add_line_to_file "${zshenv_location}" "${command_to_add}" "${comment_to_add}"
}

move_docker_data_to_location() {
  # Move Docket library directories to 'move_locaction' directory
  local move_location="${1:?The location where docker data have to be moved not set}"
  local new_docker_data_location="${move_location}/Docker"
  local default_docker_data_location="${HOME}/Library/Containers/com.docker.docker/Data"

  mkdir -p "${new_docker_data_location}"
  mkdir -p "${default_docker_data_location}"

  rm -rf "${default_docker_data_location}"
  ln -s "${new_docker_data_location}" "${default_docker_data_location}"

  echo_info "Docker library directrories moved to '${move_location}'"
}

add_user_docker_binary_to_zsh_path_env() {
  # If dirrectroy HOME/.docker/bin exists
  # then add it to PATH

  local user_docker_path_location="${HOME}/.docker/bin"
  local comment="Docker binaries in user space. Required if system wide binaries not installed."

  if [[ -d "${user_docker_path_location}" ]]; then
    add_path_to_zsh_path_env "${user_docker_path_location}" "${comment}"
  fi
}

add_vs_code_binary_zsh_path_env() {
  local vs_code_binary_path="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"
  local comment="VC Code binary dirrectory. Required for convenient 'code' command in shell"

  if [[ -d "${vs_code_binary_path}" ]]; then
    add_path_to_zsh_path_env "${vs_code_binary_path}" "${comment}"
  fi
}
