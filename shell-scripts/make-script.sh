#!/usr/bin/env bash

script_name="$1"

root_dir="$(dirname "$(realpath "$0")")/.."

lr_ins() {
    local pname="$1"; shift

    luarocks install --tree "$root_dir/.luarocks" "$pname" "$@"
}

lr_deps_ins() {
    luarocks install --tree "$root_dir/.luarocks" --deps-only "$1"
}

amalg() {
    exec "$root_dir/.luarocks/bin/amalg.lua" "$@"
}

if [[ ! -e "$root_dir/.luarocks/bin/amalg.lua" ]]; then
    lr_ins amalg
fi
lr_deps_ins "$root_dir/scripts/$script_name/$script_name-deps-1.rockspec"

eval "$(cat "$root_dir/scripts/$script_name/info.sh")"

# shellcheck disable=SC2086 # allow splitting
amalg -s "$root_dir/scripts/$script_name/$SCRIPT_FILE" -o "out/amalg-$SCRIPT_FILE" -- $SCRIPT_DEPS
