# 屏幕圆角 · Mac Rounded Corners

[English](README.en.md)

给原本是方角的 Mac 屏幕加上圆角。打开应用后，从菜单栏的 **◜◝** 切换样式、调整大小，或设置登录时启动。

## 适合哪些 Mac

按屏幕**实际显示画面**的四角判断。以下 Apple 芯片机型的内置显示区域为方角：

| 机型 | 机型标识符或芯片 | Apple 资料 |
| --- | --- | --- |
| MacBook Air 13 英寸（M1，2020） | `MacBookAir10,1` | [机型与产品图](https://support.apple.com/zh-cn/102869) |
| MacBook Pro 13 英寸（M1，2020） | `MacBookPro17,1` | [机型与产品图](https://support.apple.com/en-us/108052) |
| MacBook Pro 13 英寸（M2，2022） | `Mac14,7` | [机型与产品图](https://support.apple.com/en-us/108052) |
| iMac 24 英寸 | M1（2021）、M3（2023）、M4（2024）、M6（2026） | [机型与产品图](https://support.apple.com/en-la/108054) |

Mac mini、Mac Studio、Apple 芯片版 Mac Pro，以及其他 Apple 芯片 Mac 搭配方角外接显示器时也适用。同时使用多块显示器时，应用会给所有启用的屏幕加上圆角遮罩。

搭载 M2 至 M5 的 MacBook Air、2021 年起的 14／16 英寸 MacBook Pro 和 MacBook Neo 的内置屏幕已经带圆角。参见 Apple 的 [MacBook Air M2](https://support.apple.com/en-us/111867)、[MacBook Air M5](https://support.apple.com/en-us/126320)、[MacBook Pro 14／16 英寸](https://support.apple.com/en-us/111902)和 [MacBook Neo](https://support.apple.com/en-us/126322) 规格。

## 功能

- **普通圆角**支持预设大小和逐点微调，范围为 1–160 屏幕点。
- **苹果圆角**使用 macOS 的连续曲线，半径固定为 26.1 屏幕点。
- 为连接的每台显示器各自绘制圆角。黑色遮罩会让鼠标操作正常穿透。
- 圆角样式、大小和开关会保存到本机。菜单栏可以随时暂停圆角或退出应用。

## 下载和使用

发布包为 `arm64`，需要 Apple 芯片和 macOS 13 或更新版本。可在「 → 关于本机」核对芯片和系统版本。

1. 从 [GitHub Releases](https://github.com/luzijun360/mac-rounded-corners/releases) 下载 `MacRoundedCorners-v1.0.0-macOS-arm64.zip` 并解压。
2. 将 `屏幕圆角.app` 拖入「应用程序」并打开。
3. 点击菜单栏的 **◜◝** 设置样式和大小。启用「登录时启动」后，可以在系统设置的「通用 → 登录项」管理它。

应用采用临时签名。如果 macOS 拦截首次启动，先确认下载来源，再按 [Apple 的说明](https://support.apple.com/zh-cn/102445)在「隐私与安全性」中选择「仍要打开」。

## 从源码构建

使用支持 Swift 5.7 或更新版本的 Apple 命令行开发工具，并使用 macOS 13 或更新版本的 SDK。

```sh
bash build.sh
```

生成的应用位于 `build/屏幕圆角.app`。`RoundedCorners.swift` 包含 AppKit 菜单栏和遮罩窗口的实现，登录项通过 `SMAppService` 管理。
