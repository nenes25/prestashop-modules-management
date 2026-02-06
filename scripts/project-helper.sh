#!/bin/bash

# Utility script to manage the PrestaShop Modules GitHub Project
# Provides convenient commands for common operations

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

# Help function
show_help() {
    echo -e "${GREEN}=== GitHub Project Helper - PrestaShop Modules ===${NC}\n"
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Available commands:"
    echo ""
    echo "  ${BLUE}list-projects${NC}"
    echo "    Lists all your GitHub projects"
    echo ""
    echo "  ${BLUE}add-issue${NC} <owner/repo> <issue_number> <project_id>"
    echo "    Adds a specific issue to the project"
    echo "    Example: $0 add-issue nenes25/eicaptcha 331 PROJECT_ID"
    echo ""
    echo "  ${BLUE}create-label${NC} <owner/repo> <label_name> <color> <description>"
    echo "    Creates a label in a repository"
    echo "    Example: $0 create-label nenes25/eicaptcha priority:high d73a4a 'High priority'"
    echo ""
    echo "  ${BLUE}bulk-label${NC} <label_name> <color> <description>"
    echo "    Creates a label in all project repositories"
    echo "    Example: $0 bulk-label priority:critical ff0000 'Critical'"
    echo ""
    echo "  ${BLUE}list-repos${NC}"
    echo "    Lists all repositories configured in the project"
    echo ""
    echo "  ${BLUE}check-issues${NC} <owner/repo>"
    echo "    Verifies the existence of configured issues for a repository"
    echo "    Example: $0 check-issues nenes25/eicaptcha"
    echo ""
    echo "  ${BLUE}help${NC}"
    echo "    Displays this help"
    echo ""
}

# Check prerequisites
check_requirements() {
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
        echo "Run: gh auth login"
        exit 1
    fi
}

# List projects
list_projects() {
    echo -e "${YELLOW}List of GitHub projects for @$OWNER:${NC}\n"
    gh project list --owner "$OWNER" --format json | jq -r '.projects[] | "\(.number). \(.title) (ID: \(.id))"'
}

# Add an issue to the project
add_issue() {
    local repo=$1
    local issue_num=$2
    local project_id=$3
    
    if [ -z "$repo" ] || [ -z "$issue_num" ] || [ -z "$project_id" ]; then
        echo -e "${RED}Usage: $0 add-issue <owner/repo> <issue_number> <project_id>${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Adding issue #$issue_num from repository $repo to project...${NC}"
    
    gh project item-add "$project_id" \
        --owner "$OWNER" \
        --url "https://github.com/$repo/issues/$issue_num"
    
    echo -e "${GREEN}✓ Issue added successfully${NC}"
}

# Create a label in a repository
create_label() {
    local repo=$1
    local label_name=$2
    local color=$3
    local description=$4
    
    if [ -z "$repo" ] || [ -z "$label_name" ] || [ -z "$color" ]; then
        echo -e "${RED}Usage: $0 create-label <owner/repo> <label_name> <color> <description>${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Creating label '$label_name' in $repo...${NC}"
    
    # Check if label exists
    if gh label list --repo "$repo" --search "$label_name" --limit 1 | grep -q "$label_name"; then
        echo -e "${YELLOW}Label already exists${NC}"
        exit 0
    fi
    
    gh label create "$label_name" \
        --repo "$repo" \
        --color "$color" \
        --description "$description"
    
    echo -e "${GREEN}✓ Label created successfully${NC}"
}

# Create a label in all repositories
bulk_label() {
    local label_name=$1
    local color=$2
    local description=$3
    
    if [ -z "$label_name" ] || [ -z "$color" ]; then
        echo -e "${RED}Usage: $0 bulk-label <label_name> <color> <description>${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Creating label '$label_name' in all repositories...${NC}\n"
    
    # Read repositories from config
    REPOS=$(jq -r '.repositories[] | "\(.owner)/\(.name)"' "$CONFIG_FILE")
    
    while IFS= read -r repo; do
        echo -e "${BLUE}→ $repo${NC}"
        
        if gh label list --repo "$repo" --search "$label_name" --limit 1 | grep -q "$label_name"; then
            echo "  Label already exists"
        else
            gh label create "$label_name" \
                --repo "$repo" \
                --color "$color" \
                --description "$description" 2>/dev/null && \
                echo -e "  ${GREEN}✓ Created${NC}" || \
                echo -e "  ${RED}✗ Failed${NC}"
        fi
    done <<< "$REPOS"
    
    echo -e "\n${GREEN}Operation completed${NC}"
}

# List configured repositories
list_repos() {
    echo -e "${YELLOW}Repositories configured in the project:${NC}\n"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Configuration file not found: $CONFIG_FILE${NC}"
        exit 1
    fi
    jq -r '.repositories[] | "- \(.owner)/\(.name) (\(.issues | length) configured issues)"' "$CONFIG_FILE"
}

# Check issue existence
check_issues() {
    local repo=$1
    
    if [ -z "$repo" ]; then
        echo -e "${RED}Usage: $0 check-issues <owner/repo>${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Checking issues for $repo:${NC}\n"
    
    # Find repo in config
    REPO_NAME=$(echo "$repo" | cut -d'/' -f2)
    ISSUES=$(jq -r ".repositories[] | select(.name==\"$REPO_NAME\") | .issues[]" "$CONFIG_FILE" 2>/dev/null || echo "")
    
    if [ -z "$ISSUES" ]; then
        echo -e "${RED}No configured issues for this repository${NC}"
        exit 1
    fi
    
    while IFS= read -r issue_num; do
        if [ -n "$issue_num" ]; then
            # Check if issue exists
            if gh issue view "$issue_num" --repo "$repo" &> /dev/null; then
                echo -e "${GREEN}✓${NC} Issue #$issue_num exists"
            else
                echo -e "${RED}✗${NC} Issue #$issue_num does not exist or is not accessible"
            fi
        fi
    done <<< "$ISSUES"
}

# Main
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # Show help without checking requirements
    if [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi
    
    # list-repos doesn't need authentication
    if [ "$1" = "list-repos" ]; then
        list_repos
        exit 0
    fi
    
    check_requirements
    
    case "$1" in
        list-projects)
            list_projects
            ;;
        add-issue)
            add_issue "$2" "$3" "$4"
            ;;
        create-label)
            create_label "$2" "$3" "$4" "$5"
            ;;
        bulk-label)
            bulk_label "$2" "$3" "$4"
            ;;
        list-repos)
            list_repos
            ;;
        check-issues)
            check_issues "$2"
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}\n"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
