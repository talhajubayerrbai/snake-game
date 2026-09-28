#!/bin/bash
# Deploy a versioned artifact from S3 to the running EC2 instance.
# Usage: deploy-artifact.sh <bucket> <key> <region>
# Run on the EC2 instance itself (via SSH or SSM).
set -euo pipefail

BUCKET="$1"
KEY="$2"
REGION="$3"
DEST="/opt/snake-game"
ZIP="/tmp/artifact.zip"

echo "[deploy] Downloading s3://$BUCKET/$KEY ..."
aws s3 cp "s3://$BUCKET/$KEY" "$ZIP" --region "$REGION"

echo "[deploy] Extracting to $DEST ..."
rm -rf "${DEST:?}"/*
unzip -o "$ZIP" -d "$DEST"

echo "[deploy] Restarting snake-game service ..."
systemctl restart snake-game
systemctl status snake-game --no-pager

echo "[deploy] Done."
