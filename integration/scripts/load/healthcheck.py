import json, sys, urllib.request

resp = urllib.request.urlopen('http://localhost:8006/health')
data = json.load(resp)

if data.get("healthy") is True:
    sys.exit(0)
else:
    sys.exit(1)