import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0

QtObject {
    id: searchBackend
    
    property var currentResults: []
    signal resultsChanged()
    
    // KRunner integration
    PlasmaCore.DataSource {
        id: krunnerSource
        engine: "org.kde.krunner"
        
        onNewData: {
            console.log("KRunner results:", JSON.stringify(data));
            processKRunnerResults(data);
        }
        
        onSourceRemoved: {
            currentResults = [];
            resultsChanged();
        }
    }
    
    // Application search using KService
    function searchApplications(query) {
        if (query.length < 2) {
            currentResults = [];
            resultsChanged();
            return;
        }
        
        var results = [];
        
        // Use KService to find applications
        var service = PlasmaCore.ServiceRegistry.service("org.kde.kservice");
        if (service) {
            var job = service.startOperationCall("findApplications", { "query": query });
            job.finished.connect(function() {
                if (job.error === 0) {
                    results = job.result.applications || [];
                    currentResults = results.map(function(app) {
                        return {
                            id: app.storageId,
                            title: app.name,
                            description: app.comment || app.genericName || "Application",
                            icon: app.iconName || "application-x-executable",
                            type: "application",
                            data: app
                        };
                    });
                    resultsChanged();
                }
            });
        }
    }
    
    // File search using Baloo
    function searchFiles(query) {
        if (query.length < 3) {
            currentResults = [];
            resultsChanged();
            return;
        }
        
        // Use Baloo search
        krunnerSource.connectSource("baloosearch:" + query);
    }
    
    // System settings search
    function searchSystemSettings(query) {
        if (query.length < 2) {
            currentResults = [];
            resultsChanged();
            return;
        }
        
        var results = [];
        var commonSettings = [
            { name: "Display & Monitor", keywords: ["display", "monitor", "screen", "resolution"], module: "displayconfiguration" },
            { name: "Network", keywords: ["network", "wifi", "ethernet", "internet"], module: "kcm_networkmanagement" },
            { name: "Sound", keywords: ["sound", "audio", "volume", "speakers"], module: "kcm_pulseaudio" },
            { name: "Power Management", keywords: ["power", "battery", "energy", "suspend"], module: "powerdevilprofilesconfig" },
            { name: "Bluetooth", keywords: ["bluetooth", "wireless", "pairing"], module: "bluedevil" },
            { name: "Keyboard", keywords: ["keyboard", "keys", "typing", "shortcuts"], module: "kcm_keyboard" },
            { name: "Mouse & Touchpad", keywords: ["mouse", "touchpad", "pointer", "cursor"], module: "kcm_mouse" },
            { name: "Desktop Effects", keywords: ["effects", "compositing", "animations"], module: "kwineffects" },
            { name: "Window Management", keywords: ["window", "windows", "behavior"], module: "kwinrules" },
            { name: "Startup and Shutdown", keywords: ["startup", "shutdown", "login", "boot"], module: "kcm_autostart" },
            { name: "User Account", keywords: ["user", "account", "profile", "avatar"], module: "user_manager" },
            { name: "Date & Time", keywords: ["date", "time", "clock", "timezone"], module: "clock" },
            { name: "Regional Settings", keywords: ["language", "locale", "region", "country"], module: "kcm_formats" }
        ];
        
        var queryLower = query.toLowerCase();
        
        commonSettings.forEach(function(setting) {
            var matches = setting.keywords.some(function(keyword) {
                return keyword.indexOf(queryLower) !== -1 || setting.name.toLowerCase().indexOf(queryLower) !== -1;
            });
            
            if (matches) {
                results.push({
                    id: setting.module,
                    title: setting.name,
                    description: "System Settings",
                    icon: "configure",
                    type: "systemsetting",
                    data: { module: setting.module }
                });
            }
        });
        
        currentResults = results;
        resultsChanged();
    }
    
    // Recent files and documents
    function searchRecent(query) {
        var results = [];
        
        // Get recent documents from KDE's recent files
        var recentService = PlasmaCore.ServiceRegistry.service("org.kde.kio");
        if (recentService) {
            var job = recentService.startOperationCall("recentDocuments", {});
            job.finished.connect(function() {
                if (job.error === 0) {
                    var documents = job.result.documents || [];
                    var filtered = documents.filter(function(doc) {
                        return !query || doc.name.toLowerCase().indexOf(query.toLowerCase()) !== -1;
                    });
                    
                    currentResults = filtered.map(function(doc) {
                        return {
                            id: doc.url,
                            title: doc.name,
                            description: doc.path,
                            icon: doc.iconName || "document",
                            type: "recentfile",
                            data: doc
                        };
                    });
                    resultsChanged();
                }
            });
        }
    }
    
    // Home scope - mix of recent apps, files, and quick actions
    function searchHome(query) {
        if (!query || query.length === 0) {
            showHomeDefaults();
            return;
        }
        
        // Search across all scopes for home
        var allResults = [];
        
        // Quick search in applications
        searchApplications(query);
        // Add file search
        searchFiles(query);
        // Add settings search  
        searchSystemSettings(query);
    }
    
    function showHomeDefaults() {
        var defaults = [
            { id: "files", title: "Files", description: "Browse your files", icon: "folder", type: "launcher" },
            { id: "settings", title: "System Settings", description: "Configure your system", icon: "configure", type: "launcher" },
            { id: "software", title: "Discover", description: "Install software", icon: "plasmadiscover", type: "application" },
            { id: "terminal", title: "Terminal", description: "Command line", icon: "utilities-terminal", type: "application" },
            { id: "calculator", title: "Calculator", description: "Perform calculations", icon: "accessories-calculator", type: "application" }
        ];
        
        currentResults = defaults;
        resultsChanged();
    }
    
    function processKRunnerResults(data) {
        var results = [];
        
        if (data && data.matches) {
            data.matches.forEach(function(match) {
                results.push({
                    id: match.id || match.data,
                    title: match.text || match.display,
                    description: match.subtext || "",
                    icon: match.iconName || "application-x-executable",
                    type: "krunner",
                    data: match
                });
            });
        }
        
        currentResults = results;
        resultsChanged();
    }
    
    function search(query, scope) {
        switch(scope) {
            case "applications":
                searchApplications(query);
                break;
            case "files":
                searchFiles(query);
                break;
            case "system":
                searchSystemSettings(query);
                break;
            case "recent":
                searchRecent(query);
                break;
            case "home":
            default:
                searchHome(query);
                break;
        }
    }
    
    function executeResult(result) {
        console.log("Executing result:", JSON.stringify(result));
        
        switch(result.type) {
            case "application":
                if (result.data && result.data.exec) {
                    executeCommand(result.data.exec);
                } else {
                    executeCommand("kstart5 " + result.id);
                }
                break;
            case "systemsetting":
                executeCommand("systemsettings5 " + result.data.module);
                break;
            case "recentfile":
                executeCommand("xdg-open '" + result.id + "'");
                break;
            case "launcher":
                if (result.id === "files") {
                    executeCommand("dolphin");
                } else if (result.id === "settings") {
                    executeCommand("systemsettings5");
                } else {
                    executeCommand("kstart5 " + result.id);
                }
                break;
            case "krunner":
            default:
                if (result.data && result.data.exec) {
                    executeCommand(result.data.exec);
                } else {
                    executeCommand(result.id);
                }
                break;
        }
    }
    
    function executeCommand(command) {
        console.log("Executing command:", command);
        
        var execSource = PlasmaCore.DataSource {
            engine: "executable"
        };
        execSource.connectSource(command);
    }
}