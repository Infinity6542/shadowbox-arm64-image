#!/bin/bash

set -e  # Exit on error

# Read previous version
PREVIOUS_VERSION=$(cat latest 2>/dev/null || echo "")

# Fetch current version with better error handling
echo "Fetching latest release..."
RESPONSE=$(curl -s -w "\n%{http_code}" https://api.github.com/repos/Jigsaw-Code/outline-server/releases/latest)
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo "HTTP Response Code: $HTTP_CODE"

if [ "$HTTP_CODE" != "200" ]; then
  echo "Error:  GitHub API returned $HTTP_CODE"
  echo "Response: $BODY"
  # Set VERSION_UPDATED to 0 on error
  echo "VERSION_UPDATED=0" >> "$GITHUB_OUTPUT"
  echo "VERSION=$PREVIOUS_VERSION" >> "$GITHUB_OUTPUT"
  exit 0
fi

CURRENT_VERSION=$(echo "$BODY" | jq -r ".tag_name")

echo "Previous version: $PREVIOUS_VERSION"
echo "Current version: $CURRENT_VERSION"

VERSION_UPDATED="0"

if [[ "$PREVIOUS_VERSION" != "$CURRENT_VERSION" ]]; then
  VERSION_UPDATED="1"
  echo "Version updated!"
fi

if [[ "$CURRENT_VERSION" == "null" ]] || [[ -z "$CURRENT_VERSION" ]]; then
  echo "Error: Could not determine current version"
  VERSION_UPDATED="0"
  CURRENT_VERSION="$PREVIOUS_VERSION"
fi

# Remove 'server-v' prefix if present
VERSION_CLEAN="${CURRENT_VERSION//server-v/}"

echo "VERSION_UPDATED=$VERSION_UPDATED" >> "$GITHUB_OUTPUT"
echo "VERSION=$VERSION_CLEAN" >> "$GITHUB_OUTPUT"

echo "=== GitHub Output ==="
cat "$GITHUB_OUTPUT"

# Only update 'latest' file if we got a valid version
if [[ "$CURRENT_VERSION" != "null" ]] && [[ -n "$CURRENT_VERSION" ]]; then
  echo "$CURRENT_VERSION" > latest
  echo "Updated 'latest' file"
fi
