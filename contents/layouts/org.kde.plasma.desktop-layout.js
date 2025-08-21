// Unity-style layout for KDE Plasma
var panel = new Panel
panel.location = "top"
panel.height = 24

// Top panel widgets (Unity-style: Global Menu | Spacer | System Tray | Clock)
var globalMenu = panel.addWidget("org.kde.plasma.appmenu")
var spacer = panel.addWidget("org.kde.plasma.panelspacer")
var systemTray = panel.addWidget("org.kde.plasma.systemtray")
var digitalClock = panel.addWidget("org.kde.plasma.digitalclock")

// Left panel for Unity-style launcher/taskbar (Unity standard width: 72px)
var leftPanel = new Panel
leftPanel.location = "left"
leftPanel.width = 72
leftPanel.hiding = "none"

// Add Unity-style widgets to left panel
var applicationLauncher = leftPanel.addWidget("org.kde.plasma.kickoff")
var taskManager = leftPanel.addWidget("org.kde.plasma.icontasks")

// Add separator before system area (Unity style)
var separator1 = leftPanel.addWidget("org.kde.plasma.panelspacer")

// Add device notifier for mounted drives
var deviceNotifier = leftPanel.addWidget("org.kde.plasma.devicenotifier")

// Add separator before trash
var separator2 = leftPanel.addWidget("org.kde.plasma.panelspacer")

var trashWidget = leftPanel.addWidget("org.kde.plasma.trash")

// Configure task manager for vertical layout (Unity style)
taskManager.currentConfigGroup = ["General"]
taskManager.writeConfig("forceStretchTasks", true)
taskManager.writeConfig("showToolTips", true)
taskManager.writeConfig("iconSize", 48)
taskManager.writeConfig("vertical", true)

// Configure separators to be minimal (Unity style)
separator1.currentConfigGroup = ["General"]
separator1.writeConfig("expanding", false)
separator1.writeConfig("length", 1)

separator2.currentConfigGroup = ["General"] 
separator2.writeConfig("expanding", false)
separator2.writeConfig("length", 1)

// Configure device notifier
deviceNotifier.currentConfigGroup = ["General"]
deviceNotifier.writeConfig("showText", false)

// Configure trash widget
trashWidget.currentConfigGroup = ["General"] 
trashWidget.writeConfig("showText", false)

// Configure global shortcuts
// Super key for application launcher
applicationLauncher.globalShortcut = "Meta"