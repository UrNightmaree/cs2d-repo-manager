#!/usr/bin/env bash

script_name="$1"
root_dir="$(dirname "$(realpath "$0")")/.."

lr_deps_ins() {
    echo "luarocks install --tree \"$root_dir/.luarocks\" --deps-only $1"
    luarocks install --tree "$root_dir/.luarocks" --deps-only "$1"
}
# shellcheck disable=SC2120 # for concat
concat() {
    local IFS="$1"; shift
    echo "$*"
}

if command -v lua >/dev/null; then
    lua_bin=lua
else
    # use luarocks config
    lua_bin="$(luarocks config variables.LUA)"
fi
lua_ver="$("$lua_bin" -e 'print(_VERSION)')"
lua_ver="${lua_ver##Lua }"

# shellcheck disable=SC2034 # it is used
declare -g ROOT_SCRIPT="$root_dir/lua/$script_name"
eval "$(cat "$root_dir/lua/$script_name/info.sh")"

unset LUA_PATH_"${lua_ver//./_}" LUA_PATH

if [[ "${lua_ver##5.}" != 1 ]]; then
    declare -gx LUA_PATH_"${lua_ver//./_}"="$(concat ';' "${SCRIPT_PATH[@]}");$root_dir/.luarocks/share/lua/$lua_ver/?.lua;$root_dir/.luarocks/share/lua/$lua_ver/?/init.lua"
else
    declare -gx LUA_PATH
    # shellcheck disable=SC2034 # it is used
    LUA_PATH="$(concat ';' "${SCRIPT_PATH[@]}");$root_dir/.luarocks/share/lua/$lua_ver/?.lua;$root_dir/.luarocks/share/lua/$lua_ver/?/init.lua"
fi

[[ -e "$root_dir/lua/$script_name/${script_name,,}-deps-1.rockspec" ]] &&
    lr_deps_ins "$root_dir/lua/$script_name/${script_name,,}-deps-1.rockspec"

cat << EOF
$root_dir/deps/lua-amalg/src/amalg.lua \\
    -s "$root_dir/lua/$script_name/$SCRIPT_FILE" -o "$root_dir/out/amalg-$SCRIPT_FILE" -- ${SCRIPT_DEPS[@]}
EOF

"$root_dir/deps/lua-amalg/src/amalg.lua" \
    -s "$root_dir/lua/$script_name/$SCRIPT_FILE" -o "$root_dir/out/amalg-$SCRIPT_FILE" -- "${SCRIPT_DEPS[@]}" &
