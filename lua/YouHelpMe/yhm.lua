--|
--|    YouHelpMe
--| +=============+
--|
--| YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.
--| Made just for fun and intended to be replacement for TipsSpawner.
--|

local json = require "json"

--> API stuff <--

YHM = { _version = "0.1", _config_table = {} }

local f = io.open("sys/yhm-config.json",'r')

if f then
    YHM._config_table = json.decode(f:read "*a")
    f:close()
end

function YHM:get_messages_from_team(team_id)
    if team_id < 0 or team_id > 3 then
        error("invalid team id: "..team_id)
    end

    local i = 0
    local n = table.maxn(self._config_table[tostring(team_id)])
    return function()
        i = i + 1
        if i <= n then return self._config_table[tostring(team_id)][i] end
    end
end

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

function YHM:overwrite_config(tbl)
    self._config_table = tbl or {}
end

function YHM:get_config()
    return self._config_table
end

--> Main section <--

addhook("spawn","YHM_spawn_hook")

function YHM_spawn_hook(id)
    local team_id = player(id, "team")
    local team_config = YHM._config_table[tostring(team_id)]

    if team_config then
        local n = table.maxn(team_config)
        msg2(id,"\169255026026Tips: "..team_config[math.random(n)].."@C")
    end
end

