#!/bin/sh

if [ "$DEV" = "true" ]; then
    python3 -m debugpy --listen 0.0.0.0:5678 -m uvicorn app.main:app --reload --host 0.0.0.0 --port 80
else
    fastapi run --port 80
fi
