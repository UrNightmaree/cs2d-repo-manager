# YouHelpMe
YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.

## Index
 - [API](#api)
   - [`YHM._version`](#yhm_version)
   - [`YHM:get_messages_from_team`](#yhmget_messages_from_team)
   - [`YHM:get_all_messages`](#yhmget_all_messages)
   - [`YHM:get_color_by_prefix`](#yhmget_color_by_prefix)
   - [`YHM:get_all_colors`](#yhmget_all_colors)
   - [`YHM:get_config`](#yhmget_config)
   - [`YHM:overwrite_config`](#yhmoverwrite_config)
 - [JSON configuration](#json-configuration)
 - [TODO](#todo)
 - [Changelog](#changelog)

## API

All the API functions are in global `YHM`, you may need to `require` it in your script instead putting it in `sys/lua/autorun`.

---

### `YHM._version`

| Type     | Constant |
|:--------:|:--------:|
| `string` | ✔        |

Version of YHM (in semver)

---

### `YHM:get_messages_from_team`

| Parameter | Type                 | Optional |
|:---------:|:--------------------:|:--------:|
| team_id   | `integer` (`number`) |          |

Return an iterator function which iterate team messages. Iterator function return the message of the team.

**Return:** `fun(): string`

---

### `YHM:get_all_messages`

Return an iterator function which iterate all messages in `messages`, even if it's `T` or `CT`. Iterator function return name of the team and the message.

**Return:** `fun(): string, string`

---

### `YHM:get_color_by_prefix`

| Parameter   | Type      | Optional |
|:-----------:|:---------:|:--------:|
| prefix      | `string`  |          |
| append_zero | `boolean` | ✔        |

Return RGB color based on prefix. If passed boolean `true` on append_zero, append zero on each comma-separated value and return RGB color without comma separator.

**Return:** `string`

---

### `YHM:get_all_colors`

| Parameter   | Type      | Optional |
|:-----------:|:---------:|:--------:|
| append_zero | `boolean` | ✔        |

Return an iterator function which iterate over all `colorMessage` property. Iterator function returns prefix of the color and the RGB color value. If passed boolean `true` on append_zero, second return of iterator function appends zero on each comma-separated value and removes comma separator.

**Return:** `fun(): string, string`

---

### `YHM:get_config`

Get the current loaded config if `sys/yhm-config.json` found, if not return nil or return new loaded config by `YHM:overwrite_config`.

**Return:** `table`

---

### `YHM:overwrite_config`

| Parameter | Type    | Optional |
|:---------:|:-------:|:--------:|
| tbl       | `table` | ✔       |

Load a new config. If config from `sys/yhm-config.json` found, this function overwrite the loaded config (config file does not overwriten by this function).

**Return:** `none`/`nil`

## JSON configuration

JSON configuration used to handle how YHM configured, it is placed in `sys/yhm-config.json`. Here's the example.
```json
{
    "colorMessage": {
        "test": "0,255,255"
    },
    "messages": {
        "T": [
            "no color T",
            "Hint: hint color T",
            "Tips: tips color T",
            "Test: test color T"
        ],
        "CT": [
            "no color CT",
            "Hint: hint color CT",
            "Tips: tips color CT",
            "Test: test color CT"
        ]
    }
}
```

[A JSON schema file](/schema/yhm-config.schema.json) is available to help you on writing configuration.
```json
{
    "$schema": "https://raw.githubusercontent.com/UrNightmaree/cs2d-repo-manager/master/schema/yhm-config.schema.json"
}
```

Check out the [Documentation](/docs/YouHelpMe/yhm-config.md) also.

## TODO
 - [ ] More config
 - [ ] Release version `1.0`
 - [ ] `messages` for all team (T and CT)
 - [ ] `colorMessage` for specific team
 - [ ] Text configuration (e.g offset, align, etc.)
 - [x] Colorize the text if prefixed with Lua patttern `^(%w+):`
 - [x] Use CS2D command `hudtxt2` instead `msg2` function

## Changelog

### v0.2
- JSON parser now uses repository from PR [#46](https://github.com/rxi/json.lua/pull/46) of [rxi/json.lua](https://github.com/rxi/json.lua) to optimize parsing time.
- New API functions, `YHM:get_color_by_prefix` and `YHM:get_all_colors`.
- Config breaking changes, check the [docs](/docs/YouHelpMe/yhm-config.md).
- API docs improvement, both in markdown file and LuaLS annotation.

### v0.1
- Created YouHelpMe
