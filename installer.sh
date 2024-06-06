#!/bin/bash

function show_help
{
  local target_dir=$1
  shift 1
  local files=("$@")
  local name=${BASH_SOURCE[0]}
  echo "
$name [-f] [-h]

Install the following files to $target_dir:
${files[*]}

Options:
-f: Remove existed file before installing a new one
-h: Show help
  "
}

function test_files
{
  local target_dir=$1
  shift 1
  local files=("$@")
  for f in "${files[@]}"; do
    # Test "-a" || "-L" for the case that a symbolic link exists but is invalid.
    if [[ -a "$target_dir/$f" ]] || [[ -L "$target_dir/$f" ]]; then
      echo "$target_dir/$f already exists! Remove it before installation or run with option '-f'."
      exit 1
    fi
  done
}

function remove_files
{
  local target_dir=$1
  shift 1
  local files=("$@")
  for f in "${files[@]}"; do
    # Test "-a" || "-L" for the case that a symbolic link exists but is invalid.
    if [[ -a "$target_dir/$f" ]] || [[ -L "$target_dir/$f" ]]; then
      echo "Removing $target_dir/$f"
      rm -rf "$target_dir/$f"
    fi
  done
}

# Override the function by caller of process_cmd_line
function copy_files
{
  local target_dir=$1
  shift 1
  local files=("$@")

  for f in "${files[@]}"; do
    echo "Installing $target_dir/$f"
  done
}

function process_cmd_line
{
  local target_dir=$1
  shift 1
  local files=("$@")

  while getopts "fh" opt; do
    case $opt in
      f ) force=1 ;;
      h ) show_help "$target_dir" "${files[@]}" && exit ;;
      ? ) show_help "$target_dir" "${files[@]}" && exit 1 ;;
    esac
  done

  if [[ -z "$force" ]]; then
    test_files "$target_dir" "${files[@]}"
  else
    remove_files "$target_dir" "${files[@]}"
  fi

  copy_files "$target_dir" "${files[@]}"
}