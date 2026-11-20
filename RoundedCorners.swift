import Cocoa
import ServiceManagement

final class CornerView: NSView {
    var screenRect: NSRect = .zero
    var cornerRect: NSRect = .zero
    var radius: CGFloat = 20
    var appleStyle = false
    override var isOpaque: Bool { false }
    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.current?.shouldAntialias = true
        NSGraphicsContext.current?.cgContext.setAllowsAntialiasing(true)
        NSGraphicsContext.current?.cgContext.setShouldAntialias(true)
        let full = NSRect(x: screenRect.minX - cornerRect.minX, y: screenRect.minY - cornerRect.minY, width: screenRect.width, height: screenRect.height)
        if appleStyle, let context = NSGraphicsContext.current?.cgContext {
            context.saveGState()
            context.setFillColor(NSColor.black.cgColor)
            context.fill(bounds)
            context.setBlendMode(.destinationOut)
            context.translateBy(x: full.minX, y: full.minY)
            let rounded = CALayer()
            rounded.bounds = CGRect(origin: .zero, size: full.size)
            rounded.backgroundColor = NSColor.black.cgColor
            rounded.cornerRadius = radius
            rounded.cornerCurve = .continuous
            rounded.render(in: context)
            context.restoreGState()
        } else {
            NSColor.black.setFill()
            let path = NSBezierPath(rect: bounds)
            path.append(NSBezierPath(roundedRect: full, xRadius: radius, yRadius: radius))
            path.windingRule = .evenOdd
            path.fill()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var windows: [NSWindow] = []
    private var status: NSStatusItem!
    private var radius: CGFloat = CGFloat(UserDefaults.standard.object(forKey: "radius") as? Double ?? 16)
    private var appleStyle = UserDefaults.standard.bool(forKey: "appleStyle")
    private var enabled = UserDefaults.standard.object(forKey: "enabled") as? Bool ?? true
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        status.button?.title = "◜◝"
        status.button?.toolTip = "屏幕圆角"
        let menu = NSMenu(); menu.delegate = self; status.menu = menu
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(keepOnTop), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(keepOnTop), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in self?.keepOnTop() }
        refresh()
    }
    @objc private func keepOnTop() {
        guard enabled else { return }
        for window in windows { window.orderFrontRegardless() }
    }
    func menuWillOpen(_ menu: NSMenu) {
        menu.removeAllItems()
        add(menu, enabled ? "关闭圆角" : "开启圆角", #selector(toggle))
        menu.addItem(.separator())
        for (title, tag) in [("普通圆角", 0), ("苹果圆角", 1)] {
            let item = NSMenuItem(title: title, action: #selector(setStyle(_:)), keyEquivalent: "")
            item.target = self; item.tag = tag; item.state = (appleStyle == (tag == 1)) ? .on : .off; menu.addItem(item)
        }
        menu.addItem(.separator())
        let heading = NSMenuItem(title: appleStyle ? "苹果圆角：固定 26.1 点" : "圆角大小（屏幕点）", action: nil, keyEquivalent: ""); menu.addItem(heading)
        if !appleStyle {
        for size in [8, 12, 16, 20, 24, 32, 40, 48, 64, 80] {
            let item = NSMenuItem(title: "\(size)", action: #selector(setRadius(_:)), keyEquivalent: "")
            item.target = self; item.tag = size; item.state = Int(radius) == size ? .on : .off; menu.addItem(item)
        }
        menu.addItem(.separator())
        add(menu, "减小 1 点（当前 \(Int(radius))）", #selector(decreaseRadius))
        add(menu, "增大 1 点（当前 \(Int(radius))）", #selector(increaseRadius))
        }
        menu.addItem(.separator())
        let login = NSMenuItem(title: "登录时启动", action: #selector(toggleLogin), keyEquivalent: "")
        login.target = self; login.state = SMAppService.mainApp.status == .enabled ? .on : .off; menu.addItem(login)
        menu.addItem(.separator())
        add(menu, "退出屏幕圆角", #selector(quit))
    }
    private func add(_ menu: NSMenu, _ title: String, _ action: Selector) {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: ""); item.target = self; menu.addItem(item)
    }
    @objc func toggle() { enabled.toggle(); UserDefaults.standard.set(enabled, forKey: "enabled"); refresh() }
    @objc func setStyle(_ sender: NSMenuItem) { appleStyle = sender.tag == 1; UserDefaults.standard.set(appleStyle, forKey: "appleStyle"); refresh() }
    @objc func setRadius(_ sender: NSMenuItem) { radius = CGFloat(sender.tag); UserDefaults.standard.set(Double(radius), forKey: "radius"); refresh() }
    @objc func decreaseRadius() { changeRadius(max(1, radius - 1)) }
    @objc func increaseRadius() { changeRadius(min(160, radius + 1)) }
    private func changeRadius(_ value: CGFloat) { radius = value; UserDefaults.standard.set(Double(radius), forKey: "radius"); refresh() }
    @objc func toggleLogin() {
        do {
            if SMAppService.mainApp.status == .enabled { try SMAppService.mainApp.unregister() }
            else { try SMAppService.mainApp.register() }
        } catch {
            let alert = NSAlert(); alert.messageText = "无法更改登录时启动"; alert.informativeText = "\(error.localizedDescription)\n请尝试将应用移到“应用程序”文件夹后再设置，或在系统设置的登录项中检查。"; alert.runModal()
        }
    }
    @objc func quit() { NSApp.terminate(nil) }
    @objc func refresh() {
        windows.forEach { $0.orderOut(nil) }; windows.removeAll()
        guard enabled else { return }
        for screen in NSScreen.screens {
            let f = screen.frame
            let r = min(appleStyle ? 26.1 : radius, f.width / 2, f.height / 2)
            // Include a small transparent margin beyond the curve so its antialiased
            // transition is rendered inside the window instead of clipped at its edge.
            let scale = screen.backingScaleFactor
            let extent = min(ceil(((appleStyle ? 2 * r : r) + 4) * scale) / scale, min(f.width, f.height) / 2)
            let rects = [NSRect(x:f.minX,y:f.minY,width:extent,height:extent), NSRect(x:f.maxX-extent,y:f.minY,width:extent,height:extent), NSRect(x:f.minX,y:f.maxY-extent,width:extent,height:extent), NSRect(x:f.maxX-extent,y:f.maxY-extent,width:extent,height:extent)]
            for rect in rects {
                let window = NSPanel(contentRect: rect, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false, screen: screen)
                window.isFloatingPanel = true
                window.hidesOnDeactivate = false
                window.isOpaque = false; window.backgroundColor = .clear; window.hasShadow = false
                window.ignoresMouseEvents = true
                window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.assistiveTechHighWindow)))
                window.canHide = false
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
                window.animationBehavior = .none
                window.isExcludedFromWindowsMenu = true
                let actualRect = window.frame
                let view = CornerView(frame: NSRect(origin: .zero, size: actualRect.size)); view.screenRect = f; view.cornerRect = actualRect; view.radius = r; view.appleStyle = appleStyle
                window.contentView = view; window.orderFrontRegardless(); windows.append(window)
            }
        }
    }
}
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
