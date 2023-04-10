# YHM Configuration
A list of all configuration that can be used to configure how YHM works. Configuration file must be placed inside `sys/` directory as `yhm-config.json` (`sys/yhm-config.json`).

## messages
Settings that configure messages for each team.<br><br>

---
### `messages.T`
<br>

| Type | Default |
| :-: | :-: |
| `Array<String>` | `[]` |

An array of strings that will be displayed as message for T (Terrorist) team.

---
### `messages.CT`
<br>

| Type | Default |
| :-: | :-: |
| `Array<String>` | `[]` |

An array of strings that will be displayed as message for CT (Counter-Terrorist) team.

---
## colorMessage
Settings that add foreground RGB color if the prefix (e.g `Tips:` prefix is `tips`) same as key, then set RGB color using key value (`colorMessage[prefix] -> RGB color value`). RGB color must be separated with comma and no space, e.g `"234,0,39"`.<br><br>

---
### `colorMessage.defaultColor`
<br>

| Type | Default |
| :-: | :-: |
| `String` | `"255,255,255"` |

Default color if can't match any key prefix or if the message doesn't have prefix.

---
### `colorMessage.tips`
<br>

| Type | Default |
| :-: | :-: |
| `String` | `"255,239,145"` |

Preset color for `"Tips:"` prefix.

---
### `colorMessage.hint`
<br>

| Type | Default |
| :-: | :-: |
| `String` | `"255,145,145"` |

Preset color for `"Hint:"` prefix.

---
### `colorMessage./^[a-z0-9]+$/`
<sub>Note: `/^[a-z0-9]+$/` regex pattern restrict key to only use lower characters and number, see the [schema file](/schema/yhm-config.schema.json#L42-L45) for context.</sub><br><br>

| Type | Default |
| :-: | :-: |
| `String` | `"255,255,255"` |

A string containing comma-separated RGB value. If key does match with message prefix, use the key value (which is RGB color value) as the foreground color of that message. (The default value is same as `defaultColor` value.)
