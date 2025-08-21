import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker
import "../code/SearchBackend.qml" as SearchBackend

PlasmoidItem {
    id: root
    
    preferredRepresentation: compactRepresentation
    
    property bool dashVisible: false
    property string currentScope: "home"
    property string searchQuery: ""
    
    // Available scopes
    readonly property var scopes: [
        { id: "home", name: "Home", icon: "user-home" },
        { id: "applications", name: "Applications", icon: "applications-all" },
        { id: "files", name: "Files & Folders", icon: "folder" },
        { id: "system", name: "System Settings", icon: "configure" },
        { id: "recent", name: "Recent", icon: "document-open-recent" }
    ]
    
    // Enhanced search backend
    SearchBackend {
        id: searchBackend
        
        onResultsChanged: {
            resultsView.model = currentResults;
        }
        
        Component.onCompleted: {
            // Load home defaults on startup
            search("", "home");
        }
    }
    
    compactRepresentation: Item {
        MouseArea {
            anchors.fill: parent
            onClicked: toggleDash()
        }
        
        PlasmaCore.IconItem {
            anchors.centerIn: parent
            source: "distributor-logo-ubuntu"
            width: Math.min(parent.width, parent.height)
            height: width
        }
    }
    
    fullRepresentation: Rectangle {
        id: dashOverlay
        
        width: 800
        height: 600
        color: "#2C2C2C"
        radius: 8
        border.color: "#E95420"
        border.width: 1
        
        visible: root.dashVisible
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            // Header with search
            RowLayout {
                Layout.fillWidth: true
                
                PlasmaExtras.Heading {
                    text: "Search your computer"
                    color: "#FFFFFF"
                    level: 3
                }
                
                Item { Layout.fillWidth: true }
                
                PlasmaComponents3.Button {
                    icon.name: "window-close"
                    onClicked: toggleDash()
                    flat: true
                }
            }
            
            // Search box
            PlasmaComponents3.TextField {
                id: searchField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                
                placeholderText: "Type to search..."
                font.pointSize: 14
                
                background: Rectangle {
                    color: "#404040"
                    border.color: "#E95420"
                    border.width: searchField.activeFocus ? 2 : 1
                    radius: 4
                }
                
                color: "#FFFFFF"
                
                onTextChanged: {
                    root.searchQuery = text;
                    searchBackend.search(text, root.currentScope);
                }
                
                Keys.onEscapePressed: toggleDash()
            }
            
            // Scope selector and results
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 20
                
                // Scope selector
                ColumnLayout {
                    Layout.preferredWidth: 180
                    Layout.fillHeight: true
                    
                    PlasmaExtras.Heading {
                        text: "Filter results"
                        color: "#CCCCCC"
                        level: 4
                    }
                    
                    Repeater {
                        model: root.scopes
                        
                        PlasmaComponents3.Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            
                            text: modelData.name
                            icon.name: modelData.icon
                            
                            flat: root.currentScope !== modelData.id
                            highlighted: root.currentScope === modelData.id
                            
                            background: Rectangle {
                                color: parent.highlighted ? "#E95420" : (parent.hovered ? "#404040" : "transparent")
                                radius: 4
                            }
                            
                            onClicked: {
                                root.currentScope = modelData.id;
                                searchBackend.search(root.searchQuery, root.currentScope);
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
                
                // Results area
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#363636"
                    radius: 4
                    
                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: 10
                        
                        ListView {
                            id: resultsView
                            model: []
                            spacing: 8
                            
                            delegate: Rectangle {
                                width: resultsView.width
                                height: 60
                                color: mouseArea.containsMouse ? "#404040" : "transparent"
                                radius: 4
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    
                                    onClicked: {
                                        // Execute the result
                                        searchBackend.executeResult(modelData);
                                        toggleDash();
                                    }
                                }
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 15
                                    
                                    PlasmaCore.IconItem {
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 32
                                        source: modelData ? (modelData.icon || "application-x-executable") : "application-x-executable"
                                    }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        
                                        PlasmaComponents3.Label {
                                            text: modelData ? (modelData.title || "Unknown") : "Unknown"
                                            color: "#FFFFFF"
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }
                                        
                                        PlasmaComponents3.Label {
                                            text: modelData ? (modelData.description || "") : ""
                                            color: "#CCCCCC"
                                            font.pointSize: 9
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }
                        }
                        
                        PlasmaComponents3.Label {
                            anchors.centerIn: parent
                            text: root.searchQuery.length === 0 ? 
                                  "Start typing to search..." : 
                                  (resultsView.count === 0 ? "No results found" : "")
                            color: "#888888"
                            visible: resultsView.count === 0
                        }
                    }
                }
            }
        }
        
        // Handle clicks outside to close
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: toggleDash()
        }
    }
    
    function toggleDash() {
        root.dashVisible = !root.dashVisible;
        if (root.dashVisible) {
            searchField.forceActiveFocus();
        }
    }
    
    
    // Handle global shortcut
    Component.onCompleted: {
        plasmoid.setAction("toggleDash", "Toggle Unity Dash", "search");
        plasmoid.action("toggleDash").triggered.connect(toggleDash);
    }
}