--|
--|    YouHelpMe
--| +=============+
--|
--| YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.
--| Made just for fun and intended to be replacement for TipsSpawner.
--|

local json = require "json"

--> Misc. funcs <--

--- @param str string
--- @return string
local function append_0_rgb(str)
    local rgb = {}
    for s in str:gmatch "([^,]+)" do
        rgb[#rgb+1] = #s == 1 and "00"..s or
                      #s == 2 and "0"..s or s
    end
    return table.concat(rgb)
end

--- @param cmd string
--- @return fun(...: any)
local function p(cmd)
    return function(...)
        local p_cmd = cmd
        for i = 1,select('#',...) do
            local v = select(i,...)

            p_cmd = p_cmd..' "'..v..'"'
        end
        parse(p_cmd)
    end
end

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
        if i <= n then return self._config_table.team[tostring(team_id)][i] end
    end
end

--[[
Get config messages from all team (T, CT, VIP), return an iterator function.
]]
--- @return fun(): integer,string
--- @see YHM.get_messages_from_team
function YHM:get_all_messages()
    local tmp = {}
    local tmp_team = {}
    for i,v in pairs(self._config_table.team) do
        tmp[tonumber(i)] = v
        tmp_team[#tmp_team+1] = tonumber(i)
    end

    local t = 1
    local m = 0

    --- @return integer
    --- @return string
    return function()
        local mn = table.maxn(tmp[t] or {})
        m = m + 1
        if m <= mn then
            local tmp_m = m
            local tmp_t = t
            if m == mn then
                m = 0
                t = t + 1
                mn = table.maxn(tmp[tmp_t]) -- luacheck: ignore
            end
            return tmp_team[tmp_t], tmp[tmp_t][tmp_m]
        end --- @diagnostic disable-line: missing-return
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

local config_colors = YHM._config_table.colors or {}
local default_no_color = append_0_rgb(config_colors["no_color"] or "255,255,255")
local default_tips_color = append_0_rgb(config_colors["tips"] or "255,145,145")
local default_hint_color = append_0_rgb(config_colors["hint"] or "255,239,145")

function YHM_clear_hudtxt2(id)
    p"hudtxt2" (id,10,"",0,0)
end

addhook("spawn","YHM_spawn_hook")
function YHM_spawn_hook(id)
--    math.randomseed(os.time())

    local team_id = player(id,"team")
    local team_config = YHM._config_table.team[tostring(team_id)]

    if team_config then
        local n = table.maxn(team_config)
        ---@type string
        local yhm_msg = team_config[math.random(1,n)]
        local prefix_msg = (yhm_msg:match "^(%w+):" or ""):lower()

        p"hudtxt2" (id,10,
                   "\169"..
                   (prefix_msg == "tips" and default_tips_color or
                    prefix_msg == "hint" and default_hint_color or
                    config_colors[prefix_msg] and append_0_rgb(config_colors[prefix_msg]) or
                    default_no_color)
                    ..yhm_msg,
                   850/2,480/2,
                   0,0,18)
        timer(3000,"YHM_clear_hudtxt2",tostring(id))
    end
end

--
