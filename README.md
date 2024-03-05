# Features

- [x] hi-customize theme color
- [x] customize zoom sign
- [x] auto set icon based-on window name using regex
- [ ] allow change keybinding via options
- [ ] auto set background of tmux session name by name

# Screenshots

![Icons](./assets/icons.png)
![window active red](./assets/color-red.png)
![window active orange](./assets/color-orange.png)
![window zoomed](./assets/window-zoomed.png)
![window zoomed with icon after](./assets/window-zoom-with-icon-after.png)
![window zoomed with icon before](./assets/window-zoom-with-icon-before.png)
![window index](./assets/window-index.png)

# Requirements

- [tpm](https://github.com/tmux-plugins/tpm) for install and load plugin
- [Nerd font](https://www.nerdfonts.com/#home) for display icons

# Setup

1. add below line to your `tmux.conf` with predefined icons for window name

```tmux
set -g @plugin 'dtanphat9388/tmux-theme'
set -g @tmux-theme-window-icon "
 (z|ba)?sh|term
 n?vim|code|tmux|book.*
 book|man(ual)?|docs?|cheat
󱃾 kube.*|k8s|helm(file)?
 ai|copilot
"
```

2. Reload tmux config with command `tmux source-file`.
3. press `<prefix>I` to install and boooom
4. If tmux theme not effect, relaunch tmux with command `tmux kill-server`
5. Remove following redundance options if you have:
   - remove status-position option

# Theme customize via options

```diff
set -g @plugin 'dtanphat9388/tmux-theme'
+set -g @tmux-theme-{option_name}
+ #...
```

| option name             |  default value   | desc                                   |
| ----------------------- | :--------------: | -------------------------------------- |
| `color-bg`              |     #101419      | status background                      |
| `color-active`          |     #17C3B2      | color on active (ex: window, border)   |
| `color-inactive`        |     #686868      | color on inactive (ex: window, border) |
| `left-color-bg`         |     #FFFFFF      |                                        |
| `left-length`           |        25        | length of left section                 |
| `right-color-bg`        |     #FFFFFF      |                                        |
| `right-length`          |        50        | length of right section                |
| `right-label`           |  #{host_short}   | length of right section                |
| `window-name-format`    |        #W        | length of right section                |
| `window-zoom-format`    |       [#W]       | length of right section                |
| `window-icon`           |                  | show icon by window name               |
| `border-color-active`   |  `color-active`  |                                        |
| `border-color-inactive` | `color-inactive` |                                        |

## Icons

![Icons](./assets/icons.png)

- icons will appear for window name match with regex
- window name is case-insensitive

```tmux
set -g @tmux-theme-window-icon "
 (z|ba)?sh|term
 n?vim|code|tmux|book.*
 book|man(ual)?|docs?|cheat
󱃾 kube.*|k8s|helm(file)?
 ai|copilot
"
```

## Window and border color

- set active color
  ![window active red](./assets/color-red.png)
  ![window active orange](./assets/color-orange.png)

```tmux
set -g @tmux-theme-color-active "red"
```

## Window name and zoom format

- default format `[#W]`
  ![window zoomed](./assets/window-zoomed.png)
- use '' icon as zoom indicator '#W ' in after
  ![window zoomed with icon after](./assets/window-zoom-with-icon-after.png)
- use '' icon as zoom indicator ' #W' in before
  ![window zoomed with icon before](./assets/window-zoom-with-icon-before.png)
- use `#I` in window name to enable window index (ex: `#I:#W `)
  ![window index](./assets/window-index.png)

```tmux
set -g @tmux-theme-window-name-format '#W'
set -g @tmux-theme-window-zoom-format '#W '
```

# Well-know issues

- icons is smaller because your font is mono font
