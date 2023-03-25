--|
--|    YouHelpMe
--| +=============+
--|
--| YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.
--| Made just for fun and intended to be replacement for TipsSpawner.
--|

local json = require "json"

local function error_nfconfig(v)
    if v == nil then
        error "cannot find `yhm-config.json` in `sys`"
    end
end

YHM = {}
YHM._version = "0.1"

local config_table

local f = io.open("sys/ymh-config.json",'r')
if f then
    config_table = json.decode(f:read "*a")
    f:close()
end

function YHM.get_messages_from_config(team_id)
    error_nfconfig(config_table)

    if type(team_id) ~= "number" then
        error("invalid type: "..type(team_id)..", expected number")
    end

    if team_id < 0 or team_id > 3 then
        error("invalid team id: "..team_id)
    end

    local i = 0
    local n = table.maxn(config_table[tostring(team_id)])
    return function()
        i = i + 1
        if i <= n then return config_table[tostring(team_id)][i] end
    end
end

function YHM.overwrite_config(tbl)
    if type(tbl) ~= "table" then
        error("invalid type: "..type(tbl)..", expected table")
    end

    config_table = tbl
end

function YHM.get_config()
    return config_table
end
