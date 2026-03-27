# Gureum Kanata

Personal-use fork of [gureum/gureum](https://github.com/gureum/gureum) for a very specific stack:

- macOS
- `Kanata` owns English layout and shortcuts
- `Gureum Kanata` owns Hangul composition only
- `Colemak-DH Matrix` physical layout
- `2-set Korean` Hangul automata via `libhangul`

## Status

- 100% vibe coded personal fork.
- Built for my machines first, other machines second.
- Public because that is the easiest way to reuse it across Macs.
- No guarantee of maintenance, compatibility, upstream sync, or future updates.
- If a macOS, Xcode, Kanata, or upstream Gureum change breaks this fork, assume you need to fix it yourself.

## What Changed

- Added a new Hangul input source: `두벌식 Colemak-DH Matrix`
- Kept `libhangul`'s standard `2-full` automata, but changed the Hangul key map to interpret `Colemak-DH Matrix` physical output
- Split the bundle identifier so this fork can coexist with stock Gureum
- Added a user-local debug installer: [`tools/install_debug_user.sh`](./tools/install_debug_user.sh)

## Intended Stack

- `Kanata` stays in `Colemak-DH Matrix` for both English and Korean
- `Gureum Kanata` should be selected only as the Korean IME
- `Command` and `Control` shortcuts should continue to be handled by the app and `Kanata`
- Hammerspoon input-source sync is not part of the current runtime

This fork is not trying to be a general-purpose layout framework. It exists to make one specific Kanata-first setup usable.

## Dependencies

Minimum assumptions for a fresh Mac:

- `macOS`
- full `Xcode.app`
- working `xcode-select`
- `git`
- `make`
- the parent environment repo that carries the matching `Kanata` config

Recommended preflight:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
make init
```

If stock Gureum is already installed, removing or disabling it before testing this fork is cleaner. The fork can coexist with stock Gureum, but a clean machine is easier to migrate and debug.

## Build

1. Clone the repo and fetch submodules.
2. Run `make init`.
3. Install full `Xcode.app`.
4. Run:

```sh
./tools/install_debug_user.sh
```

5. Open `System Settings > Keyboard > Input Sources`.
6. Add `구름 Kanata > 두벌식 Colemak-DH Matrix`.

The installer builds a debug app, signs it ad-hoc, installs it to `~/Library/Input Methods`, refreshes Launch Services, kills the running input method, and reopens it.

On a fresh machine, this fork is meant to be installed after the parent `Kanata` environment is already working. It is not a standalone keyboard-stack replacement.

## Runtime Assumptions

- `Kanata` is already working
- `Kanata` is the only component responsible for the Latin layout
- You are not using Gureum's built-in Roman `Colemak` mode together with Kanata
- You are fine with a personal fork that may drift from upstream

## Notes

- This fork was tested mainly in `TextEdit`, `Obsidian`, `iTerm2`, and `Chrome`
- The main goal was to keep Hangul composition working in apps where `Keyman` failed
- The parent environment repo that carries the matching Kanata config is separate on purpose

## Upstream

Upstream project:

- <https://github.com/gureum/gureum>

This fork keeps upstream attribution and licensing intact. If you want a broadly supported macOS Hangul input method, start from upstream, not from this repo.
