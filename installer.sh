#!/bin/bash

function show_help
{
  local -n target_dir_ref=$1
  local -n files_ref=$2
  local name=${BASH_SOURCE[0]}
  echo "
$name [-f] [-h]

Install the following files to $target_dir_ref:
${files_ref[*]}

Options:
-f: Remove existed file before installing a new one
-h: Show help
  "
}

function test_files
{
  local -n target_dir_ref=$1
  local -n files_ref=$2
  for f in "${files_ref[@]}"; do
    # Test "-a" || "-L" for the case that a symbolic link exists but is invalid.
    if [[ -a "$target_dir_ref/$f" ]] || [[ -L "$target_dir_ref/$f" ]]; then
      echo "$target_dir_ref/$f already exists! Remove it before installation or run with option '-f'."
      exit 1
    fi
  done
}

function remove_files
{
  local -n target_dir_ref=$1
  local -n files_ref=$2
  for f in "${files_ref[@]}"; do
    # Test "-a" || "-L" for the case that a symbolic link exists but is invalid.
    if [[ -a "$target_dir_ref/$f" ]] || [[ -L "$target_dir_ref/$f" ]]; then
      echo "Removing $target_dir_ref/$f"
      rm -rf "$target_dir_ref/$f"
    fi
  done
}

