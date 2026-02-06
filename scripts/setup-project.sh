#!/bin/bash

# Script to create and configure the GitHub Project for PrestaShop modules
# This script requires GitHub CLI (gh) authentication

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config/project-config.json"

# Colors for display
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Setup GitHub Project for PrestaShop Modules ===${NC}\n"

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    echo "Install it with: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
    exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You must authenticate with GitHub CLI${NC}"
    gh auth login
fi

# Read configuration
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: Configuration file not found: $CONFIG_FILE${NC}"
    exit 1
fi

PROJECT_NAME=$(jq -r '.project.name' "$CONFIG_FILE")
PROJECT_DESC=$(jq -r '.project.description' "$CONFIG_FILE")
OWNER="nenes25"

echo -e "${GREEN}Configuration loaded:${NC}"
echo "  - Project name: $PROJECT_NAME"
echo "  - Owner: $OWNER"
echo ""

# Function to create the project
create_project() {
    echo -e "${YELLOW}Creating GitHub project...${NC}"
    
    # Create project (organization or user)
    PROJECT_OUTPUT=$(gh project create \
        --owner "$OWNER" \
        --title "$PROJECT_NAME" \
        --format json)
    
    PROJECT_ID=$(echo "$PROJECT_OUTPUT" | jq -r '.id')
    PROJECT_NUMBER=$(echo "$PROJECT_OUTPUT" | jq -r '.number')
    
    if [ -z "$PROJECT_NUMBER" ] || [ "$PROJECT_NUMBER" == "null" ]; then
        echo -e "${RED}Error: Unable to create project${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Project created successfully (Number: $PROJECT_NUMBER, ID: $PROJECT_ID)${NC}"
    echo "$PROJECT_NUMBER"
}

# Function to create labels in all repos
create_labels() {
    echo -e "\n${YELLOW}Creating labels in repositories...${NC}"
    
    # Get list of repositories
    REPOS=$(jq -r '.repositories[] | "\(.owner)/\(.name)"' "$CONFIG_FILE")
    
    # Label types
    for label_type in priority type compatibility workflow; do
        echo -e "\n${YELLOW}Creating labels of type: $label_type${NC}"
        
        # Read labels of this type
        LABELS=$(jq -c ".labels.$label_type[]" "$CONFIG_FILE")
        
        while IFS= read -r label; do
            LABEL_NAME=$(echo "$label" | jq -r '.name')
            LABEL_COLOR=$(echo "$label" | jq -r '.color')
            LABEL_DESC=$(echo "$label" | jq -r '.description')
            
            echo "  - Creating label: $LABEL_NAME"
            
            # Create label in each repo
            while IFS= read -r repo; do
                # Check if label already exists
                if gh label list --repo "$repo" --search "$LABEL_NAME" --limit 1 | grep -q "$LABEL_NAME"; then
                    echo "    → Label '$LABEL_NAME' already exists in $repo"
                else
                    gh label create "$LABEL_NAME" \
                        --repo "$repo" \
                        --color "$LABEL_COLOR" \
                        --description "$LABEL_DESC" 2>/dev/null || echo "    → Failed to create in $repo"
                fi
            done <<< "$REPOS"
            
        done <<< "$LABELS"
    done
    
    echo -e "${GREEN}✓ Labels created${NC}"
}

# Function to add issues to the project
add_issues_to_project() {
    local project_number=$1
    
    echo -e "\n${YELLOW}Adding issues to project...${NC}"
    
    # Read repositories and their issues
    REPO_COUNT=$(jq '.repositories | length' "$CONFIG_FILE")
    
    for ((i=0; i<$REPO_COUNT; i++)); do
        REPO_OWNER=$(jq -r ".repositories[$i].owner" "$CONFIG_FILE")
        REPO_NAME=$(jq -r ".repositories[$i].name" "$CONFIG_FILE")
        REPO_FULL="$REPO_OWNER/$REPO_NAME"
        
        echo -e "\n${YELLOW}Processing repository: $REPO_FULL${NC}"
        
        # Read issue numbers
        ISSUES=$(jq -r ".repositories[$i].issues[]" "$CONFIG_FILE" 2>/dev/null || echo "")
        
        if [ -z "$ISSUES" ]; then
            echo "  → No issues specified for this repository"
            continue
        fi
        
        while IFS= read -r issue_num; do
            if [ -n "$issue_num" ]; then
                echo "  - Adding issue #$issue_num..."
                
                # Add issue to project
                gh project item-add "$project_number" \
                    --owner "$OWNER" \
                    --url "https://github.com/$REPO_FULL/issues/$issue_num" 2>/dev/null || \
                    echo "    → Failed to add issue #$issue_num (may already be added or non-existent)"
            fi
        done <<< "$ISSUES"
    done
    
    echo -e "${GREEN}✓ Issues added to project${NC}"
}

# Display instructions for manual steps
show_manual_steps() {
    local project_number=$1
    
    echo -e "\n${YELLOW}=== Remaining Manual Steps ===${NC}"
    echo ""
    echo "The project was created successfully. Some configurations must be done manually:"
    echo ""
    echo "1. Configure Kanban board columns:"
    echo "   - Go to: https://github.com/users/$OWNER/projects"
    echo "   - Open project '$PROJECT_NAME'"
    echo "   - Add/rename columns: Backlog, To Do, In Progress, In Review, Done"
    echo ""
    echo "2. Add iterations (sprints):"
    echo "   - In the project, go to Settings → Fields"
    echo "   - Create a new field of type 'Iteration'"
    echo "   - Add sprints:"
    echo "     * March 2026 (March 1st - duration: 4 weeks)"
    echo "     * April 2026 (April 1st - duration: 4 weeks)"
    echo "     * May 2026 (May 1st - duration: 4 weeks)"
    echo ""
    echo "3. Create custom views:"
    echo "   - Kanban view (by column/status)"
    echo "   - Roadmap view (timeline, grouped by Iteration)"
    echo "   - By repository view (grouped by repository)"
    echo "   - By priority view (grouped by labels)"
    echo ""
    echo "4. Configure project visibility (Settings → Visibility)"
    echo ""
    echo -e "${GREEN}Project number: $project_number${NC}"
    echo -e "${GREEN}Project URL: https://github.com/users/$OWNER/projects${NC}"
}

# Main
main() {
    echo -e "${YELLOW}Do you want to proceed with project creation? (y/n)${NC}"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
    
    # Create project
    PROJECT_NUMBER=$(create_project)
    
    # Create labels
    echo -e "\n${YELLOW}Do you want to create labels in all repositories? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        create_labels
    fi
    
    # Add issues
    echo -e "\n${YELLOW}Do you want to add issues to the project? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        add_issues_to_project "$PROJECT_NUMBER"
    fi
    
    # Display instructions for manual steps
    show_manual_steps "$PROJECT_NUMBER"
    
    echo -e "\n${GREEN}=== Setup completed successfully! ===${NC}"
}

# Execute main script
main
