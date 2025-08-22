import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

PlasmoidItem {
    id: hudRoot
    
    // HUD should be invisible by default - it's triggered by global shortcut
    preferredRepresentation: null
    
    property bool hudVisible: false
    property string currentQuery: ""
    property var menuItems: []
    property string activeWindow: ""
    
    // Global shortcut handler
    PlasmaCore.DataSource {
        id: windowInfo
        engine: "org.kde.kactivities"
        
        function getActiveWindow() {
            // Get the currently active window for menu context
            var execSource = PlasmaCore.DataSource {
                engine: "executable"
                connectedSources: ["qdbus6 org.kde.KWin /KWin org.kde.KWin.activeWindow"]
            };
            return "Active Window"; // Simplified for now
        }
    }
    
    // Menu extraction service
    PlasmaCore.DataSource {
        id: menuExtractor
        engine: "executable"
        
        function extractMenus(windowClass) {
            // Extract menus from the active application
            // This is a simplified version - would need more complex implementation
            var commonMenus = [
                { text: "New File", shortcut: "Ctrl+N", category: "File" },
                { text: "Open File", shortcut: "Ctrl+O", category: "File" },
                { text: "Save", shortcut: "Ctrl+S", category: "File" },
                { text: "Save As", shortcut: "Ctrl+Shift+S", category: "File" },
                { text: "Print", shortcut: "Ctrl+P", category: "File" },
                { text: "Quit", shortcut: "Ctrl+Q", category: "File" },
                { text: "Undo", shortcut: "Ctrl+Z", category: "Edit" },
                { text: "Redo", shortcut: "Ctrl+Y", category: "Edit" },
                { text: "Cut", shortcut: "Ctrl+X", category: "Edit" },
                { text: "Copy", shortcut: "Ctrl+C", category: "Edit" },
                { text: "Paste", shortcut: "Ctrl+V", category: "Edit" },
                { text: "Select All", shortcut: "Ctrl+A", category: "Edit" },
                { text: "Find", shortcut: "Ctrl+F", category: "Edit" },
                { text: "Replace", shortcut: "Ctrl+H", category: "Edit" },
                { text: "Preferences", shortcut: "", category: "Edit" },
                { text: "Zoom In", shortcut: "Ctrl+=", category: "View" },
                { text: "Zoom Out", shortcut: "Ctrl+-", category: "View" },
                { text: "Full Screen", shortcut: "F11", category: "View" },
                { text: "Help Contents", shortcut: "F1", category: "Help" },
                { text: "About", shortcut: "", category: "Help" }
            ];
            
            menuItems = commonMenus;
        }
    }
    
    // Global shortcut registration
    Component.onCompleted: {
        // Register Alt key as global shortcut for HUD
        var shortcutSource = PlasmaCore.DataSource {
            engine: "executable"
        };
        
        // Set up global shortcut (simplified)
        console.log("Unity HUD initialized");
        menuExtractor.extractMenus("");
    }
    
    // HUD overlay
    Rectangle {
        id: hudOverlay
        anchors.fill: parent
        color: "transparent"
        visible: hudRoot.hudVisible
        z: 9999
        
        // Background blur effect
        Rectangle {
            anchors.fill: parent
            color: "#80000000"
            
            MouseArea {
                anchors.fill: parent
                onClicked: hideHUD()
            }
        }
        
        // HUD search interface
        Rectangle {
            id: hudInterface
            anchors.centerIn: parent
            width: 600
            height: 80
            color: "#2C2C2C"
            radius: 8
            border.color: "#E95420"
            border.width: 2
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                // HUD icon
                PlasmaCore.IconItem {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    source: "search"
                }
                
                // Search field
                PlasmaComponents3.TextField {
                    id: hudSearchField
                    Layout.fillWidth: true
                    
                    placeholderText: "Type to search menus..."
                    font.pointSize: 14
                    
                    background: Rectangle {
                        color: "transparent"
                        border.width: 0
                    }
                    
                    color: "#FFFFFF"
                    
                    onTextChanged: {
                        currentQuery = text;
                        filterMenuItems();
                    }
                    
                    Keys.onEscapePressed: hideHUD()
                    Keys.onReturnPressed: executeSelectedMenuItem()
                    Keys.onEnterPressed: executeSelectedMenuItem()
                    Keys.onDownPressed: resultsView.forceActiveFocus()
                }
                
                // Hint text
                PlasmaComponents3.Label {
                    text: "Alt to cancel"
                    color: "#888888"
                    font.pointSize: 10
                }
            }
        }
        
        // Results list
        Rectangle {
            id: resultsContainer
            anchors.top: hudInterface.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: hudInterface.horizontalCenter
            width: hudInterface.width
            height: Math.min(400, filteredMenuItems.length * 40)
            color: "#363636"
            radius: 4
            visible: filteredMenuItems.length > 0
            
            ListView {
                id: resultsView
                anchors.fill: parent
                anchors.margins: 5
                model: filteredMenuItems
                currentIndex: 0
                
                delegate: Rectangle {
                    width: resultsView.width
                    height: 35
                    color: ListView.isCurrentItem ? "#E95420" : (mouseArea.containsMouse ? "#404040" : "transparent")
                    radius: 3
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onClicked: {
                            resultsView.currentIndex = index;
                            executeSelectedMenuItem();
                        }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10
                        
                        PlasmaComponents3.Label {
                            text: modelData.category
                            color: "#CCCCCC"
                            font.pointSize: 9
                            Layout.preferredWidth: 60
                        }
                        
                        PlasmaComponents3.Label {
                            text: modelData.text
                            color: "#FFFFFF"
                            font.bold: ListView.isCurrentItem
                            Layout.fillWidth: true
                        }
                        
                        PlasmaComponents3.Label {
                            text: modelData.shortcut
                            color: "#888888"
                            font.pointSize: 9
                            visible: modelData.shortcut.length > 0
                        }
                    }
                }
                
                Keys.onUpPressed: {
                    if (currentIndex > 0) currentIndex--;
                }
                
                Keys.onDownPressed: {
                    if (currentIndex < count - 1) currentIndex++;
                }
                
                Keys.onReturnPressed: executeSelectedMenuItem()
                Keys.onEnterPressed: executeSelectedMenuItem()
                Keys.onEscapePressed: hideHUD()
            }
        }
        
        Keys.onPressed: {
            if (event.key === Qt.Key_Alt) {
                hideHUD();
                event.accepted = true;
            }
        }
    }
    
    // Filtered menu items
    property var filteredMenuItems: []
    
    function filterMenuItems() {
        if (currentQuery.length === 0) {
            filteredMenuItems = menuItems.slice(0, 10); // Show first 10 items
            return;
        }
        
        var query = currentQuery.toLowerCase();
        var filtered = menuItems.filter(function(item) {
            return item.text.toLowerCase().indexOf(query) !== -1 ||
                   item.category.toLowerCase().indexOf(query) !== -1;
        });
        
        filteredMenuItems = filtered.slice(0, 15); // Limit to 15 results
    }
    
    function showHUD() {
        hudRoot.hudVisible = true;
        hudSearchField.text = "";
        hudSearchField.forceActiveFocus();
        filterMenuItems();
        
        // Get active window info
        activeWindow = windowInfo.getActiveWindow();
        menuExtractor.extractMenus(activeWindow);
    }
    
    function hideHUD() {
        hudRoot.hudVisible = false;
        hudSearchField.text = "";
        currentQuery = "";
    }
    
    function executeSelectedMenuItem() {
        if (filteredMenuItems.length === 0) return;
        
        var selectedItem = filteredMenuItems[resultsView.currentIndex];
        console.log("Executing menu item:", selectedItem.text);
        
        // Execute the menu item action
        if (selectedItem.shortcut.length > 0) {
            // Send keyboard shortcut
            var execSource = PlasmaCore.DataSource {
                engine: "executable"
            };
            execSource.connectSource("xdotool key " + selectedItem.shortcut.replace(/Ctrl/g, "ctrl").replace(/Shift/g, "shift").replace(/\+/g, " "));
        }
        
        hideHUD();
    }
    
    // Global shortcut activation
    Connections {
        target: plasmoid
        
        function onActivated() {
            if (hudRoot.hudVisible) {
                hideHUD();
            } else {
                showHUD();
            }
        }
    }
}