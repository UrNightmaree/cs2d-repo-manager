#!/bin/sh

LUAROCKS_SYSCONFDIR='/usr/local/etc/luarocks' exec '/usr/local/bin/lua' -e 'package.path="/home/snake_naree/project/cs2d-repo/.luarocks/share/lua/5.4/?.lua;/home/snake_naree/project/cs2d-repo/.luarocks/share/lua/5.4/?/init.lua;"..package.path;package.cpath="/home/snake_naree/project/cs2d-repo/.luarocks/lib/lua/5.4/?.so;"..package.cpath;local k,l,_=pcall(require,"luarocks.loader") _=k and l.add_context("amalg","0.8-1")' '/home/snake_naree/project/cs2d-repo/.luarocks/lib/luarocks/rocks-5.4/amalg/0.8-1/bin/amalg.lua' "$@"
