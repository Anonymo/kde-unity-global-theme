#!/usr/bin/env python3
"""
Unity HUD - Standalone Implementation
Provides Unity-style HUD functionality with Alt key activation
"""

import sys
import subprocess
import tkinter as tk
from tkinter import ttk
import threading
import time
import json

class UnityHUD:
    def __init__(self):
        self.visible = False
        self.root = None
        self.menu_items = [
            {"text": "New File", "shortcut": "ctrl+n", "category": "File"},
            {"text": "Open File", "shortcut": "ctrl+o", "category": "File"}, 
            {"text": "Save", "shortcut": "ctrl+s", "category": "File"},
            {"text": "Save As", "shortcut": "ctrl+shift+s", "category": "File"},
            {"text": "Print", "shortcut": "ctrl+p", "category": "File"},
            {"text": "Quit", "shortcut": "ctrl+q", "category": "File"},
            {"text": "Undo", "shortcut": "ctrl+z", "category": "Edit"},
            {"text": "Redo", "shortcut": "ctrl+y", "category": "Edit"},
            {"text": "Cut", "shortcut": "ctrl+x", "category": "Edit"},
            {"text": "Copy", "shortcut": "ctrl+c", "category": "Edit"},
            {"text": "Paste", "shortcut": "ctrl+v", "category": "Edit"},
            {"text": "Select All", "shortcut": "ctrl+a", "category": "Edit"},
            {"text": "Find", "shortcut": "ctrl+f", "category": "Edit"},
            {"text": "Replace", "shortcut": "ctrl+h", "category": "Edit"},
            {"text": "Preferences", "shortcut": "", "category": "Edit"},
            {"text": "Zoom In", "shortcut": "ctrl+plus", "category": "View"},
            {"text": "Zoom Out", "shortcut": "ctrl+minus", "category": "View"},
            {"text": "Full Screen", "shortcut": "F11", "category": "View"},
            {"text": "Help Contents", "shortcut": "F1", "category": "Help"},
            {"text": "About", "shortcut": "", "category": "Help"}
        ]
        
    def create_hud_window(self):
        """Create the HUD interface"""
        self.root = tk.Tk()
        self.root.title("")
        self.root.overrideredirect(True)  # Remove window decorations
        self.root.attributes('-topmost', True)  # Always on top
        self.root.configure(bg='#2C2C2C')
        
        # Center the window
        self.root.geometry("600x400+%d+%d" % (
            self.root.winfo_screenwidth()//2 - 300,
            self.root.winfo_screenheight()//2 - 200
        ))
        
        # Main frame
        main_frame = tk.Frame(self.root, bg='#2C2C2C', relief='solid', bd=2)
        main_frame.pack(fill='both', expand=True, padx=2, pady=2)
        
        # Search frame
        search_frame = tk.Frame(main_frame, bg='#2C2C2C', height=60)
        search_frame.pack(fill='x', padx=10, pady=10)
        search_frame.pack_propagate(False)
        
        # Search label
        search_label = tk.Label(search_frame, text="🔍", font=('Arial', 16), 
                               bg='#2C2C2C', fg='white')
        search_label.pack(side='left', padx=(0, 10))
        
        # Search entry
        self.search_var = tk.StringVar()
        self.search_entry = tk.Entry(search_frame, textvariable=self.search_var,
                                    font=('Arial', 14), bg='#404040', fg='white',
                                    relief='flat', insertbackground='white')
        self.search_entry.pack(side='left', fill='x', expand=True, padx=(0, 10))
        self.search_entry.bind('<KeyRelease>', self.on_search_change)
        self.search_entry.bind('<Return>', self.execute_selected)
        self.search_entry.bind('<Escape>', self.hide_hud)
        self.search_entry.bind('<Down>', self.focus_results)
        
        # Hint label
        hint_label = tk.Label(search_frame, text="Alt to cancel", font=('Arial', 10),
                             bg='#2C2C2C', fg='#888888')
        hint_label.pack(side='right')
        
        # Results frame
        results_frame = tk.Frame(main_frame, bg='#363636')
        results_frame.pack(fill='both', expand=True, padx=10, pady=(0, 10))
        
        # Results listbox
        self.results_listbox = tk.Listbox(results_frame, font=('Arial', 11),
                                         bg='#363636', fg='white', 
                                         selectbackground='#E95420',
                                         relief='flat', activestyle='none')
        self.results_listbox.pack(fill='both', expand=True)
        self.results_listbox.bind('<Return>', self.execute_selected)
        self.results_listbox.bind('<Escape>', self.hide_hud)
        self.results_listbox.bind('<Double-Button-1>', self.execute_selected)
        
        # Bind global Alt key (simplified)
        self.root.bind('<Alt_L>', self.hide_hud)
        self.root.bind('<KeyPress-Alt_L>', self.hide_hud)
        
        # Initial search
        self.update_results("")
        
    def update_results(self, query):
        """Update search results"""
        self.results_listbox.delete(0, tk.END)
        
        if not query:
            items = self.menu_items[:10]  # Show first 10
        else:
            query_lower = query.lower()
            items = [item for item in self.menu_items 
                    if query_lower in item['text'].lower() or 
                       query_lower in item['category'].lower()][:15]
        
        for item in items:
            display_text = f"{item['category']:10} {item['text']:30} {item['shortcut']}"
            self.results_listbox.insert(tk.END, display_text)
        
        if items:
            self.results_listbox.selection_set(0)
            
    def on_search_change(self, event=None):
        """Handle search text change"""
        query = self.search_var.get()
        self.update_results(query)
        
    def focus_results(self, event=None):
        """Move focus to results list"""
        self.results_listbox.focus_set()
        
    def execute_selected(self, event=None):
        """Execute the selected menu item"""
        selection = self.results_listbox.curselection()
        if not selection:
            return
            
        index = selection[0]
        query = self.search_var.get()
        
        if not query:
            items = self.menu_items[:10]
        else:
            query_lower = query.lower()
            items = [item for item in self.menu_items 
                    if query_lower in item['text'].lower() or 
                       query_lower in item['category'].lower()][:15]
        
        if index < len(items):
            item = items[index]
            print(f"Executing: {item['text']} ({item['shortcut']})")
            
            if item['shortcut']:
                # Convert shortcut format and send
                shortcut = item['shortcut'].replace('ctrl+', 'ctrl+').replace('+', ' ')
                try:
                    subprocess.run(['xdotool', 'key', shortcut], 
                                 capture_output=True, timeout=2)
                except Exception as e:
                    print(f"Error sending shortcut: {e}")
        
        self.hide_hud()
        
    def show_hud(self):
        """Show the HUD"""
        if not self.visible:
            self.visible = True
            if not self.root:
                self.create_hud_window()
            
            self.root.deiconify()
            self.root.lift()
            self.search_entry.focus_set()
            self.search_var.set("")
            self.update_results("")
            
    def hide_hud(self, event=None):
        """Hide the HUD"""
        if self.visible and self.root:
            self.visible = False
            self.root.withdraw()
            
    def toggle_hud(self):
        """Toggle HUD visibility"""
        if self.visible:
            self.hide_hud()
        else:
            self.show_hud()
            
    def run(self):
        """Run the HUD service"""
        print("Unity HUD service started. Press Alt+Space to activate.")
        print("Use 'pkill -f unity-hud.py' to stop.")
        
        # Create initial window (hidden)
        self.create_hud_window()
        self.root.withdraw()
        
        # Start the GUI loop
        self.root.mainloop()

def setup_global_shortcut():
    """Set up global shortcut for HUD"""
    shortcut_script = '''#!/bin/bash
# Unity HUD Global Shortcut Handler

HUD_PID=$(pgrep -f "unity-hud.py")

if [ -z "$HUD_PID" ]; then
    # Start HUD service
    python3 ~/.local/bin/unity-hud.py &
    sleep 1
fi

# Send toggle signal (simplified - would need more complex IPC)
echo "toggle" > /tmp/unity-hud-command 2>/dev/null || true
'''
    
    import os
    script_path = os.path.expanduser("~/.local/bin/unity-hud-toggle.sh")
    with open(script_path, 'w') as f:
        f.write(shortcut_script)
    os.chmod(script_path, 0o755)
    
    # Set up KDE global shortcut
    try:
        subprocess.run([
            'kwriteconfig6', '--file', 'kglobalshortcutsrc',
            '--group', 'kwin', '--key', 'Unity HUD', 
            f'Alt+Space,Alt+Space,{script_path}'
        ], check=True)
        print("Global shortcut Alt+Space set up successfully!")
    except Exception as e:
        print(f"Could not set up global shortcut: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--setup-shortcut":
        setup_global_shortcut()
    elif len(sys.argv) > 1 and sys.argv[1] == "--toggle":
        # Simple toggle for testing
        try:
            subprocess.run(['pkill', '-f', 'unity-hud.py'], check=False)
        except:
            pass
        time.sleep(0.5)
        hud = UnityHUD()
        hud.show_hud()
        hud.run()
    else:
        hud = UnityHUD()
        hud.run()