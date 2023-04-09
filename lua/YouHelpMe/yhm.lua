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
YHM = { _version = "0.2", _config_table = {
    messages = { T = {}, CT = {} },
    colorMessage = {}
}}

local f = io.open("sys/yhm-config.json",'r')

if f then
    YHM._config_table = json.decode(f:read "*a")
    f:close()
end

local config_colors = YHM._config_table.colorMessage
config_colors["defaultColor"] = config_colors["defaultColor"] or "255,255,255"
config_colors["tips"] = config_colors["tips"] or "255,145,145"
config_colors["hint"] = config_colors["hint"] or "255,239,145"

--[[
Return an iterator function which iterate team messages. Iterator function return the message of the team.
]]
--- @param team string
--- @return fun(): string
--- @see YHM.get_all_messages
function YHM:get_messages_from_team(team)
    local i = 0
    local n = #self._config_table.messages[team]
    --- @return string
    return function()
        i = i + 1
        --- @diagnostic disable-next-line:missing-return
        if i <= n then return self._config_table.messages[team][i] end
    end
end

--[[
Return an iterator function which iterate all messages in `messages`, even if it's `T` or `CT`. Iterator function return name of the team and the message.
]]
--- @return fun(): string, string
--- @see YHM.get_messages_from_team
function YHM:get_all_messages()
    local tmp = {}
    for i,v in pairs(self._config_table.messages) do
        tmp[#tmp+1] = {i,v}
    end

    local i = 0
    local n = #tmp
    --- @return string
    --- @return string
    return function()
        i = i + 1
        --- @diagnostic disable-next-line:missing-return
        if i <= n then return tmp[i][1], tmp[i][2] end
    end
end

--[[
Return RGB color based on prefix. If passed boolean `true` on append_zero, append zero on each comma-separated value and return RGB color without comma separator.
]]
--- @param prefix string
--- @param append_zero? boolean
--- @return string
--- @see YHM.get_all_colors
function YHM:get_color_by_prefix(prefix, append_zero)
    return not append_zero and
        self._config_table.colorMessage[prefix] or
        append_0_rgb(self._config_table.colorMessage[prefix])
end

--[[
Return an iterator function which iterate over all `colorMessage` property. Iterator function returns prefix of the color and the RGB color value. If passed boolean `true` on append_zero, second return of iterator function appends zero on each comma-separated value and removes comma separator.
]]
--- @param append_zero? boolean
--- @return fun(): string, string
--- @see YHM.get_color_by_prefix
function YHM:get_all_colors(append_zero)
    local tmp = {}
    for i,v in pairs(self._config_table.colorMessage) do
        tmp[#tmp+1] = {i, not append_zero and v or append_0_rgb(v)}
    end

    local i = 0
    local n = #tmp
    --- @return string
    --- @return string
    return function()
        i = i + 1
        --- @diagnostic disable-next-line:missing-return
        if i <= n then return tmp[i][1], tmp[i][2] end
    end
end

--[[
Overwrite the current loaded config if `sys/yhm-config.json` found, if not load new config.
]]
--- @param tbl? any
--- @see YHM.get_config
function YHM:overwrite_config(tbl)
    self._config_table = tbl or {}
end

--[[
Get the current loaded config if `sys/yhm-config.json` found, if not return nil or new loaded config by `YHM.overwrite_config`.
]]
--- @return table|nil
--- @see YHM.overwrite_config
function YHM:get_config()
    return self._config_table
end

--> Main section <--

local team = {"T","CT"}

function YHM_clear_hudtxt2(id)
    p"hudtxt2" (id,10,"",0,0)
end

addhook("spawn","YHM_spawn_hook")
function YHM_spawn_hook(id)
--    math.randomseed(os.time())

    local team_id = player(id,"team")
    local msg_config = YHM._config_table.messages[team[team_id]]

    if msg_config then
        local n = #msg_config
        ---@type string
        local yhm_msg = msg_config[math.random(1,n)]
        local prefix_msg = (yhm_msg:match "^(%w+):" or ""):lower()

        p"hudtxt2" (id,10,
                   "\169"..
                   append_0_rgb(config_colors[prefix_msg] or config_colors["defaultColor"])
                    ..yhm_msg,
                   player(id,"screenw")/2,(player(id,"screenh")/2) - 180,
                   1,1,18)
        timer(3000,"YHM_clear_hudtxt2",tostring(id))
    end
end
