import Cocoa
import FlutterMacOS

/// Shows the debugged application and the devtool side by side.
///
/// Each one runs in its own Flutter engine, hence in its own isolate. Both
/// engines share the Dart VM of this process, so a single debug session and a
/// single VM service cover the two of them.
class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let project = FlutterDartProject()

    // Runs `main`: the debugged application.
    let appController = FlutterViewController(project: project)

    // Runs `devtoolMain`: the devtool, which connects to the VM service of
    // this process to inspect the application above.
    let devtoolEngine = FlutterEngine(
      name: "devtool", project: project, allowHeadlessExecution: false)
    let devtoolController = FlutterViewController(
      engine: devtoolEngine, nibName: nil, bundle: nil)
    devtoolEngine.run(withEntrypoint: "devtoolMain")

    let splitViewController = NSSplitViewController()
    splitViewController.splitView.isVertical = true
    splitViewController.splitView.dividerStyle = .thin

    let appItem = NSSplitViewItem(viewController: appController)
    appItem.minimumThickness = 320
    let devtoolItem = NSSplitViewItem(viewController: devtoolController)
    devtoolItem.minimumThickness = 480
    // Resizing the window resizes the devtool rather than the application.
    appItem.holdingPriority = .defaultHigh
    splitViewController.addSplitViewItem(appItem)
    splitViewController.addSplitViewItem(devtoolItem)

    let size = NSSize(width: 1600, height: 900)
    self.contentViewController = splitViewController
    self.setContentSize(size)
    self.center()
    splitViewController.splitView.setPosition(420, ofDividerAt: 0)

    RegisterGeneratedPlugins(registry: appController)
    RegisterGeneratedPlugins(registry: devtoolController)

    super.awakeFromNib()
  }
}
