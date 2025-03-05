#!/bin/bash

# Configuration
GITHUB_USER="namrqthakaipa"
GITHUB_URL="https://api.github.com/users/${GITHUB_USER}/repos"
WORKSPACE_DIR="$HOME/namratha_workspace"
REPORT_FILE="$WORKSPACE_DIR/repo_status.txt"

# Ensure the workspace directory exists
mkdir -p "$WORKSPACE_DIR"

# Get the list of repositories
echo "Fetching repositories for $GITHUB_USER..."
repos=$(curl -s "$GITHUB_URL" | jq -r '.[].clone_url')

# Clear or create report file
echo "Repository Clone Status & PRs" > "$REPORT_FILE"
echo "=============================" >> "$REPORT_FILE"

# Clone and check PRs
for repo in $repos; do
    repo_name=$(basename -s .git "$repo")
    repo_dir="$WORKSPACE_DIR/$repo_name"

    # Clone repo if not already cloned
    if [ ! -d "$repo_dir" ]; then
        echo "Cloning $repo_name..."
        git clone "$repo" "$repo_dir"
        echo "$repo_name - Cloned" >> "$REPORT_FILE"
    else
        echo "$repo_name - Already Cloned" >> "$REPORT_FILE"
        # Pull the latest changes
        cd "$repo_dir" && git pull origin main && cd "$WORKSPACE_DIR"
    fi

    # Check for open PRs
    echo "Checking PRs for $repo_name..."
    pr_url="https://api.github.com/repos/$GITHUB_USER/$repo_name/pulls"
    pr_count=$(curl -s "$pr_url" | jq '. | length')

    if [ "$pr_count" -gt 0 ]; then
        echo "$repo_name has $pr_count open pull request(s):" >> "$REPORT_FILE"
        curl -s "$pr_url" | jq -r '.[] | "  - PR #\(.number) - \(.title) [\(.head.ref)]"' >> "$REPORT_FILE"
    else
        echo "$repo_name - No open PRs" >> "$REPORT_FILE"
    fi
    echo "---------------------------------" >> "$REPORT_FILE"
done

echo "Process completed. Check the report at: $REPORT_FILE"
