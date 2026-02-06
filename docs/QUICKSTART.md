# Quick Start - GitHub Project Setup

Quick start guide to create the PrestaShop Modules dashboard in 5 minutes.

## 🚀 Option 1: Automated Setup (Recommended)

### 1. Prerequisites (2 minutes)

```bash
# Install GitHub CLI if needed
# Ubuntu/Debian
sudo apt install gh

# macOS
brew install gh

# Windows
winget install GitHub.cli

# Authenticate
gh auth login
```

### 2. Run the Script (1 minute)

```bash
# Clone the repo if needed
git clone https://github.com/nenes25/prestashop-modules-management.git
cd prestashop-modules-management/scripts

# Make the script executable
chmod +x setup-project.sh

# Launch the setup
./setup-project.sh
```

### 3. Follow the Prompts

The script will ask you:
- ✅ Create the project? (y/n)
- ✅ Create the labels? (y/n)
- ✅ Add the issues? (y/n)

### 4. Final Manual Configuration (2 minutes)

After the script, configure manually:

1. **Kanban Columns** (via GitHub interface)
   - Rename columns: Backlog, To Do, In Progress, In Review, Done

2. **Iterations/Sprints** (Settings → Fields)
   - Create "Iteration" field
   - Add March, April, May 2026

3. **Custom Views**
   - Roadmap (timeline)
   - By Repository
   - By Priority

✅ **Done! Your dashboard is operational.**

---

## 📋 Option 2: Manual Setup (10-15 minutes)

Follow the detailed guide: [MANUAL_SETUP.md](./MANUAL_SETUP.md)

---

## 🔧 Useful Commands

### List your projects
```bash
./project-helper.sh list-projects
```

### Add an issue to the project
```bash
./project-helper.sh add-issue nenes25/eicaptcha 331 PROJECT_ID
```

### Create a label in all repos
```bash
./project-helper.sh bulk-label priority:urgent ff0000 "Urgent"
```

### Check issues in a repo
```bash
./project-helper.sh check-issues nenes25/eicaptcha
```

---

## 📚 Complete Documentation

- **README.md** - Overview and installation
- **MANUAL_SETUP.md** - Step-by-step manual guide
- **project-config.json** - Project configuration (in `config/`)

---

## ⚠️ Troubleshooting

### Error "gh not found"
→ Install GitHub CLI: https://cli.github.com/

### Error "not authenticated"
→ Run: `gh auth login`

### Error "jq not found"
→ Install jq: `sudo apt install jq` or `brew install jq`

### Permission denied
→ Check repo permissions with: `gh repo view REPO --json viewerPermission`

---

## ✨ Next Steps

1. Organize issues into columns
2. Assign sprints (March 2026 for priorities)
3. Add assignees
4. Create custom views
5. Invite collaborators to the project

---

**Need help?** Check the [README.md](../README.md) or [MANUAL_SETUP.md](./MANUAL_SETUP.md)
