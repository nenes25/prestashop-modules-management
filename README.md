# PrestaShop Modules Management - GitHub Dashboard

Dedicated repository for cross-management of 6 PrestaShop modules via a centralized GitHub Project.

## 🎯 Objective

This repository contains all the tools and configuration needed to create and manage a **global GitHub Project** to track planning, progress, and monthly sprints for PrestaShop module development.

## 📦 Covered Modules

1. **[eicaptcha](https://github.com/nenes25/eicaptcha)** - Captcha module
2. **[prestashop_console](https://github.com/nenes25/prestashop_console)** - CLI Console for PrestaShop  
3. **[hhpsmigrationupgradedb](https://github.com/nenes25/hhpsmigrationupgradedb)** - Database migration and upgrade
4. **[hhmodulesmanager](https://github.com/nenes25/hhmodulesmanager)** - Module manager
5. **[cronjobs](https://github.com/nenes25/cronjobs)** - Scheduled tasks management
6. **[hhmodulescatalogapi](https://github.com/nenes25/hhmodulescatalogapi)** - Module catalog API

## 🚀 Quick Start

### Prerequisites

1. **GitHub CLI** installed and authenticated
   ```bash
   # Installation (Ubuntu/Debian)
   sudo apt install gh
   
   # Installation (macOS)
   brew install gh
   
   # Authentication
   gh auth login
   ```

2. **jq** for JSON processing
   ```bash
   # Ubuntu/Debian
   sudo apt install jq
   
   # macOS
   brew install jq
   ```

### Automated Installation

```bash
# Clone the repository
git clone https://github.com/nenes25/prestashop-modules-management.git
cd prestashop-modules-management

# Go to the scripts folder
cd scripts

# Run the setup script
./setup-project.sh
```

The script will:
1. ✅ Create the GitHub project "PrestaShop Modules - Roadmap 2026"
2. ✅ Create labels in all repositories
3. ✅ Add existing issues to the project
4. ℹ️ Display instructions for remaining manual steps

## 📂 Repository Structure

```
prestashop-modules-management/
├── README.md                    # Main documentation (this file)
├── config/
│   └── project-config.json     # Project configuration (columns, labels, repos)
├── scripts/
│   ├── setup-project.sh        # Automated installation script
│   └── project-helper.sh       # Utility script for common operations
└── docs/
    ├── QUICKSTART.md           # Quick start guide (5 minutes)
    ├── MANUAL_SETUP.md         # Detailed manual configuration guide
    └── VERIFICATION.md         # Verification and test report
```

## 📚 Documentation

- **[Quick Start](docs/QUICKSTART.md)** - Quick start in 5 minutes
- **[Configuration Manual](docs/MANUAL_SETUP.md)** - Detailed guide for manual setup
- **[Verification](docs/VERIFICATION.md)** - Tests and validation

## 🏷️ Created Labels

### Priority
- `priority:high` 🔴 - High priority
- `priority:medium` 🟡 - Medium priority
- `priority:low` 🟢 - Low priority

### Type
- `bug` 🐛 - Bug or error to fix
- `enhancement` ✨ - New feature or improvement
- `documentation` 📚 - Documentation
- `testing` 🧪 - Tests

### Compatibility
- `prestashop-9` 🛒 - Compatible with PrestaShop 9.x
- `php-8.x` 🐘 - Compatible with PHP 8.x

### Workflow
- `need-feedback` 💬 - Need feedback/clarification
- `ready-to-dev` ✅ - Ready for development

## 🔧 Useful Commands

### Add issues to existing project (catch-up script)
```bash
./scripts/add-issues-to-project.sh
```

### List GitHub projects
```bash
./scripts/project-helper.sh list-projects
```

### Add an issue to the project
```bash
./scripts/project-helper.sh add-issue nenes25/eicaptcha 331 PROJECT_ID
```

### Create a label in all repos
```bash
./scripts/project-helper.sh bulk-label priority:urgent ff0000 "Urgent"
```

### Check issues in a repo
```bash
./scripts/project-helper.sh check-issues nenes25/eicaptcha
```

### List configured repositories
```bash
./scripts/project-helper.sh list-repos
```

### Display help
```bash
./scripts/project-helper.sh help
```

## 📝 Post-Installation Manual Configuration

Some configurations must be done manually via the GitHub interface:

### 1. Kanban Columns Configuration

Go to the project → Configure columns:

- **Backlog** - Issues awaiting prioritization
- **To Do** - Issues prioritized for the next sprint
- **In Progress** - Issues currently being developed
- **In Review** - Pull requests under review
- **Done** - Completed issues and PRs

### 2. Adding Iterations (Sprints)

1. In the project, go to **Settings** → **Fields**
2. Create a new field of type **Iteration**
3. Add the sprints:
   - **March 2026** (March 1st, 2026, duration: 4 weeks)
   - **April 2026** (April 1st, 2026, duration: 4 weeks)
   - **May 2026** (May 1st, 2026, duration: 4 weeks)

### 3. Creating Custom Views

#### Kanban View (default)
- Type: Board
- Grouped by: Status/Column

#### Roadmap View
- Type: Roadmap
- Layout: Timeline (3 months)
- Grouped by: Iteration

#### By Repository View
- Type: Table
- Grouped by: Repository

#### By Priority View
- Type: Table
- Grouped by: Labels (priority:*)

## 🔄 Modifying the Configuration

To modify the project configuration, edit the `config/project-config.json` file:
- Add/remove repositories
- Modify issues to include
- Customize labels
- Adjust iterations

## 🤝 Contribution

To propose improvements:
1. Modify the `config/project-config.json` file or scripts
2. Test your modifications
3. Submit a Pull Request

## 📚 Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub Labels Guide](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)

## 📞 Support

In case of problems:
1. Verify that GitHub CLI is authenticated: `gh auth status`
2. Check permissions on repositories
3. Consult the [documentation](docs/)
4. Open an issue in this repository

---

**This repository facilitates collaborative management of PrestaShop modules. Feel free to adapt the configuration to your specific needs.**