--|
--|    YouHelpMe
--| +=============+
--|
--| YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.
--| Made just for fun and intended to be replacement for TipsSpawner.
--|

local json = require "json"

--> API stuff <--

--- @class YHM
--- @field private _config_table table
--- @field _version string Version of YHM (in semver)
YHM = { _version = "0.1", _config_table = {} }

local f = io.open("sys/yhm-config.json",'r')

if f then
    YHM._config_table = json.decode(f:read "*a")
    f:close()
end

--[[
Get messages from team, return an iterator function.
]]
--- @param team_id integer
--- @return function
--- @see YHM.get_all_messages
function YHM:get_messages_from_team(team_id)
    if team_id < 1 or team_id > 3 then
        error("invalid team id: "..team_id)
    end

    local i = 0
    local n = table.maxn(self._config_table[tostring(team_id)])
    return function()
        i = i + 1
        if i <= n then return self._config_table[tostring(team_id)][i] end
    end
end

--[[
Get messages from all team (T, CT, VIP), return an iterator function.
]]
--- @return function
--- @see YHM.get_messages_from_team
function YHM:get_all_messages()
    local tmp = {}
    for _,v in pairs(self._config_table) do
        tmp[#tmp+1] = v
    end

    local i = 0
    local j = 1
    local n = table.maxn(tmp)
    return function()
        local jn = table.maxn(tmp[j])
        i = i + 1
        if i <= n then
            if j == jn then
               j = j + 1
               jn = table.maxn(tmp[j]) -- luacheck: ignore
            end
            return tmp[j][i]
        end
    end
end

--[[
Overwrite the config, replaces current config if `sys/yhm-config.json` found.
If omit `tbl`, it'll set the config as empty table.
]]
--- @param tbl? any
--- @see YHM.get_config
function YHM:overwrite_config(tbl)
    self._config_table = tbl or {}
end

--[[
Get the current config.
]]
--- @return table
--- @see YHM.overwrite_config
function YHM:get_config()
    return self._config_table
end

--> Main section <--

addhook("spawn","YHM_spawn_hook")

function YHM_spawn_hook(id)
    math.randomseed(os.time())

    local team_id = player(id,"team")
    local team_config = YHM._config_table[tostring(team_id)]

    if team_config then
        local n = table.maxn(team_config)
        msg2(id,"\169255026026Tips: "..team_config[math.random(n)].."@C")
    end
end
