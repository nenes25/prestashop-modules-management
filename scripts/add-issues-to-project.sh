#!/bin/bash

# Script to add configured issues to an existing GitHub Project
# Use this script if issues were not added during initial project creation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config/project-config.json"
OWNER="nenes25"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Add Issues to GitHub Project ===${NC}\n"

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI is not authenticated${NC}"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: Configuration file not found: $CONFIG_FILE${NC}"
    exit 1
fi

# List available projects
echo -e "${YELLOW}Available GitHub projects:${NC}\n"
gh project list --owner "$OWNER" --format json | jq -r '.projects[] | "\(.number). \(.title)"'

echo ""
echo -e "${YELLOW}Enter the project number:${NC}"
read -r PROJECT_NUMBER

if [ -z "$PROJECT_NUMBER" ]; then
    echo -e "${RED}Error: Project number is required${NC}"
    exit 1
fi

# Verify project exists
if ! gh project view "$PROJECT_NUMBER" --owner "$OWNER" &> /dev/null; then
    echo -e "${RED}Error: Project #$PROJECT_NUMBER not found${NC}"
    exit 1
fi

echo -e "\n${GREEN}Using project #$PROJECT_NUMBER${NC}\n"

# Add issues to project
echo -e "${YELLOW}Adding issues to project...${NC}\n"

REPO_COUNT=$(jq '.repositories | length' "$CONFIG_FILE")
ADDED_COUNT=0
FAILED_COUNT=0

for ((i=0; i<$REPO_COUNT; i++)); do
    REPO_OWNER=$(jq -r ".repositories[$i].owner" "$CONFIG_FILE")
    REPO_NAME=$(jq -r ".repositories[$i].name" "$CONFIG_FILE")
    REPO_FULL="$REPO_OWNER/$REPO_NAME"
    
    echo -e "${BLUE}Processing repository: $REPO_FULL${NC}"
    
    # Read issue numbers
    ISSUES=$(jq -r ".repositories[$i].issues[]" "$CONFIG_FILE" 2>/dev/null || echo "")
    
    if [ -z "$ISSUES" ]; then
        echo -e "  ${YELLOW}→ No issues configured${NC}\n"
        continue
    fi
    
    while IFS= read -r issue_num; do
        if [ -n "$issue_num" ]; then
            echo -n "  - Adding issue #$issue_num... "
            
            # Add issue to project
            if gh project item-add "$PROJECT_NUMBER" \
                --owner "$OWNER" \
                --url "https://github.com/$REPO_FULL/issues/$issue_num" &> /dev/null; then
                echo -e "${GREEN}✓${NC}"
                ADDED_COUNT=$((ADDED_COUNT + 1))
            else
                echo -e "${RED}✗ (already added or non-existent)${NC}"
                FAILED_COUNT=$((FAILED_COUNT + 1))
            fi
        fi
    done <<< "$ISSUES"
    
    echo ""
done

echo -e "${GREEN}=== Summary ===${NC}"
echo -e "  Successfully added: ${GREEN}$ADDED_COUNT${NC}"
echo -e "  Failed/Skipped: ${YELLOW}$FAILED_COUNT${NC}"
echo ""
echo -e "${GREEN}✓ Operation completed${NC}"
