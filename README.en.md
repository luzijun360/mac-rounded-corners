# Mac Rounded Corners

[简体中文](README.md)

Add rounded corners to square-cornered Mac displays. Use **◜◝** in the menu bar to switch styles, adjust the radius, or launch at login. The app’s menus are in Simplified Chinese.

## Which Macs is it for?

Check the corners of the visible display area. These Apple silicon models have square-cornered built-in displays.

| Model | Model identifier or chip | Apple reference |
| --- | --- | --- |
| 13-inch MacBook Air (M1, 2020) | `MacBookAir10,1` | [Model and product image](https://support.apple.com/en-ie/102869) |
| 13-inch MacBook Pro (M1, 2020) | `MacBookPro17,1` | [Model and product image](https://support.apple.com/en-us/108052) |
| 13-inch MacBook Pro (M2, 2022) | `Mac14,7` | [Model and product image](https://support.apple.com/en-us/108052) |
| 24-inch iMac | M1 (2021), M3 (2023), M4 (2024), M6 (2026) | [Models and product images](https://support.apple.com/en-la/108054) |

Square-cornered external monitors also suit the app when connected to an Apple silicon Mac, including Mac mini, Mac Studio, and Mac Pro. When several displays are active, the app draws overlays on all of them.

MacBook Air models with M2 through M5, 14-inch and 16-inch MacBook Pro models from 2021 onward, and MacBook Neo already have rounded built-in display corners. See Apple’s specs for the [M2 MacBook Air](https://support.apple.com/en-us/111867), [M5 MacBook Air](https://support.apple.com/en-us/126320), [14- and 16-inch MacBook Pro](https://support.apple.com/en-us/111902), and [MacBook Neo](https://support.apple.com/en-us/126322).

## Features

- **Standard corners** offer presets and one-point adjustments from 1 to 160 screen points.
- **Apple-style corners** use macOS’s continuous curve at a fixed radius of 26.1 points.
- Each connected display gets its own overlays, and pointer events pass through them.
- The app remembers your settings locally. You can hide the corners or quit from the menu bar.

## Install

The `arm64` download requires Apple silicon and macOS 13 or later. Check the chip and macOS version in ** → About This Mac**.

1. Download `MacRoundedCorners-v1.0.0-macOS-arm64.zip` from [GitHub Releases](https://github.com/luzijun360/mac-rounded-corners/releases) and extract it.
2. Move `屏幕圆角.app` to Applications and open it.
3. Use the **◜◝** menu to choose a style. Select **登录时启动** to launch at login.

The app uses ad-hoc signing. If Gatekeeper blocks the first launch, confirm where you downloaded it and follow [Apple’s instructions](https://support.apple.com/en-us/102445) to use **Open Anyway** in Privacy & Security.

## Build

Use Apple’s command-line developer tools with Swift 5.7 or later and the macOS 13 SDK or later.

```sh
bash build.sh
```

The app is written in Swift and uses AppKit for the overlays and menu, with `SMAppService` for launch at login. The build produces `build/屏幕圆角.app`.
