
function output_color()
{
  if [ -p /dev/stdin ]; then
    while IFS= read line; do
      echo "Line: ${line}"
      _output_color_line $line
    done
  else
    local input=$*
    _output_color_line $input
  fi
}

# RED="$(tput setaf 1)"
# GREEN="$(tput setaf 2)"
# YELLOW="$(tput setaf 3)"
# BLUE="$(tput setaf 4)"
# MAGENTA="$(tput setaf 5)"
# CYAN="$(tput setaf 6)"
# WHITE="$(tput setaf 7)"
# ORANGE="$(tput setaf 9)"
# VIOLET="$(tput setaf 13)"
# BLACK="$(tput setaf 16)"
# UNDERLINE="$(tput smul)"
# EXIT_UNDERLINE="$(tput rmul)"
# RESET="$(tput sgr0)"

function _output_color_line()
{
  local _my_line=$*
  local RED="1"
  local GREEN="2"
  local YELLOW="3"
  local MAGENTA="5"
  local ORANGE="9"
  shopt -s nocasematch
  _my_line=$(_color_word_with "warn" ${YELLOW} "${_my_line}")
  _my_line=$(_color_word_with "err" ${RED} "${_my_line}")
  _my_line=$(_color_word_with "fail" ${ORANGE} "${_my_line}")
  _my_line=$(_color_word_with "undefined" ${MAGENTA} "${_my_line}")
  _my_line=$(_color_word_with "info" ${GREEN} "${_my_line}")
  echo "end _my_line = $_my_line"
  # c files
}

function _color_word_with()
{
  # echo "begin"
  local word=$1
  # local color=$2
  local color="$(tput setaf $2)"
  local _my_line=$3
  # echo "word = $word"
  # echo "color = $color"
  # echo "_my_line = $_my_line"
  regex="^(.*)($word[A-z]+)(.*)$"
  if [[ $input =~ $regex ]]; then
    local before="${BASH_REMATCH[1]}"
    local error="${BASH_REMATCH[2]}"
    local after="${BASH_REMATCH[3]}"
    local RESET="$(tput sgr0)"
    _my_line="${before}${color}${error}${RESET}${after}"
    # echo "_my_line = $_my_line"
  fi
  return $_my_line
}
