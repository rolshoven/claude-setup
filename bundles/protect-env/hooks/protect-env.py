#!/usr/bin/env python3
import json, sys, os, re

data = json.load(sys.stdin)
tool_input = data.get("tool_input", {})
path = tool_input.get("file_path") or tool_input.get("path") or ""
name = os.path.basename(path)

ALLOWED = re.compile(r"^\.env[.\-_](example|sample|template)$")

if name.startswith(".env") and not ALLOWED.match(name):
    print(f"Blocked: access to {path} is not allowed.", file=sys.stderr)
    sys.exit(2)

sys.exit(0)
