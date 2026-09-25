#!/bin/bash
set -euo pipefail

# --- CONFIG ---
REPO_DIR="/home/pi/your-repo"          # path to your local git repo
BRANCH="main"                           # branch to pull
LOG_FILE="/home/pi/scripts/update.log"
CDP_PORT=9222                           # remote debugging port Chromium is running with

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# --- PULL LATEST ---
log "Starting update"
cd "$REPO_DIR"

if git pull origin "$BRANCH" >> "$LOG_FILE" 2>&1; then
    log "Git pull succeeded"
else
    log "Git pull FAILED"
    exit 1
fi

# --- REFRESH CHROMIUM TAB VIA CDP ---
python3 << EOF
import json, urllib.request, urllib.error

try:
    tabs = json.loads(urllib.request.urlopen("http://localhost:${CDP_PORT}/json").read())
    # grab first tab that's a real page (skip devtools/extension pages)
    page_tabs = [t for t in tabs if t.get("type") == "page"]
    ws_url = page_tabs[0]["webSocketDebuggerUrl"]
except (urllib.error.URLError, IndexError, KeyError) as e:
    print(f"Failed to find Chromium tab: {e}")
    exit(1)

import websocket
ws = websocket.create_connection(ws_url)
ws.send(json.dumps({"id": 1, "method": "Page.reload", "params": {"ignoreCache": True}}))
ws.close()
print("Reload triggered")
EOF

if [ $? -eq 0 ]; then
    log "Chromium tab refreshed"
else
    log "Chromium refresh FAILED"
    exit 1
fi

log "Update complete"