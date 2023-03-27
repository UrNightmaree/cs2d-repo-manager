# YouHelpMe
YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.

## Index
 - [API](#api)
   - [`YHM._version`](#yhm_version)
   - [`YHM:get_messages_from_team`](#yhmget_messages_from_team)
   - [`YHM:get_all_messages`](#yhmget_all_messages)
   - [`YHM:get_config`](#yhmget_config)
   - [`YHM:overwrite_config`](#yhmoverwrite_config)
 - [TODO](#todo)

## API

All the API functions are in global `YHM`, you may need to `require` it in your script instead putting it in `sys/lua/autorun`.

---

### `YHM._version`

| Type     | Constant |
|----------|:--------:|
| `string` | ✔       |

Version of YHM (in semver)

---

### `YHM:get_messages_from_team`

| Parameter | Type                 | Optional |
|-----------|----------------------|:--------:|
| team_id   | `integer` (`number`) |          |

Get config messages from team, return an iterator function.

**Return:** `fun(): string`

---

### `YHM:get_all_messages`

Get config messages from all team (T, CT, VIP), return an iterator function.

**Return:** `fun(): string`

---

### `YHM:get_config`

Get the current config.

**Return:** `table`

---

### `YHM:overwrite_config`

| Parameter | Type    | Optional |
|-----------|---------|:--------:|
| tbl       | `table` | ✔       |

Overwrite the config, replaces current config if `sys/yhm-config.json` found.
If omit `tbl`, it'll set the config as empty table.

**Return:** `none`/`nil`

---

## TODO
 - [ ] More config
 - [ ] Custom color if prefixed with Lua patttern `^(%w+):`
 - [ ] Use CS2D command `hudtxt2` instead `msg2` function
 - [ ] Release version `1.0`
