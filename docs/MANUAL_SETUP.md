# Manual Configuration Guide - GitHub Project PrestaShop Modules

This guide details all the steps to manually create the GitHub Project if you prefer not to use the automated script.

## 📋 Table of Contents

1. [Creating the Project](#1-creating-the-project)
2. [Configuring the Kanban Structure](#2-configuring-the-kanban-structure)
3. [Adding Iterations (sprints)](#3-adding-iterations-sprints)
4. [Adding Issues](#4-adding-issues)
5. [Creating Labels](#5-creating-labels)
6. [Configuring Custom Views](#6-configuring-custom-views)

---

## 1. Creating the Project

### Steps:

1. Go to your Projects page: https://github.com/nenes25?tab=projects
2. Click on **"New project"**
3. Select type **"Board"** (Kanban board view)
4. Name the project: **"PrestaShop Modules - Roadmap 2026"**
5. (Optional) Add a description:
   ```
   Global dashboard to track planning, progress, and monthly sprints 
   for PrestaShop module development
   ```
6. Click on **"Create project"**

### Expected Result:
✅ A new empty project with a default Board view

---

## 2. Configuring the Kanban Structure

### Steps:

1. In your newly created project, you will see default columns
2. Rename/create the following columns (click on ⋮ → Rename):

   | Column | Description | Order |
   |---------|-------------|-------|
   | **Backlog** | Issues awaiting prioritization | 1 |
   | **To Do** | Issues prioritized for the next sprint | 2 |
   | **In Progress** | Issues currently being developed | 3 |
   | **In Review** | Pull requests under review | 4 |
   | **Done** | Completed issues and PRs | 5 |

3. Delete unnecessary default columns (Todo, In Progress, Done if necessary)

### Tips:
- Use drag & drop to reorganize columns
- Each column can have a specific color (Column Settings)

---

## 3. Adding Iterations (sprints)

Iterations allow you to plan work over defined periods (monthly sprints).

### Steps:

1. In the project, click on **Settings** (⚙️) in the top right
2. Go to the **"Fields"** section
3. Click on **"+ New field"**
4. Select type **"Iteration"**
5. Name the field: **"Sprint"**

6. Configure the iterations:

   #### Sprint March 2026
   - **Title**: March 2026
   - **Start date**: 2026-03-01 (March 1st, 2026)
   - **Duration**: 4 weeks

   #### Sprint April 2026
   - **Title**: April 2026
   - **Start date**: 2026-04-01 (April 1st, 2026)
   - **Duration**: 4 weeks

   #### Sprint May 2026
   - **Title**: May 2026
   - **Start date**: 2026-05-01 (May 1st, 2026)
   - **Duration**: 4 weeks

7. Click on **"Save"**

### Expected Result:
✅ A "Sprint" field available on each project item
✅ 3 sprints planned for Q2 2026

---

## 4. Adding Issues

### Method 1: Manual Addition via Interface

1. In the project, click on **"+ Add item"** at the bottom of any column
2. Select **"Add item from repository"**
3. Search and select issues by number

### Method 2: Bulk Search and Add

1. Use the **"+ Add items"** search bar
2. Filter by repository: `repo:nenes25/eicaptcha`
3. Select multiple issues by checking the boxes
4. Click on **"Add selected items"**

### List of Issues to Add:

#### eicaptcha (nenes25/eicaptcha)
Issues: #331, #329, #328, #320, #319, #318, #314, etc.

#### prestashop_console (nenes25/prestashop_console)
Issues: #251, #245, #239, #238, #234, #232, #127, #120, #92, #5

#### hhpsmigrationupgradedb (nenes25/hhpsmigrationupgradedb)
Issues: #19, #18, #3

#### hhmodulesmanager (nenes25/hhmodulesmanager)
Issues: #22, #20, #16, #14

#### hhmodulescatalogapi (nenes25/hhmodulescatalogapi)
Issues: #6, #4, #1

#### cronjobs (nenes25/cronjobs)
To be defined as needed

### Organization:
- Place priority issues in **"To Do"**
- Assign the **"March 2026"** sprint to issues to start quickly
- Put the rest in **"Backlog"**

---

## 5. Creating Labels

Labels must be created in **each repository** individually.

### Steps for Each Repository:

1. Go to the repository (e.g.: https://github.com/nenes25/eicaptcha)
2. Click on **"Issues"** → **"Labels"**
3. Click on **"New label"**

### Labels to Create:

#### Category: Priority

| Name | Color (hex) | Description |
|-----|---------------|-------------|
| `priority:high` | `d73a4a` | High priority - Handle urgently |
| `priority:medium` | `fbca04` | Medium priority - To be planned |
| `priority:low` | `0e8a16` | Low priority - Nice to have |

#### Category: Type

| Name | Color (hex) | Description |
|-----|---------------|-------------|
| `bug` | `d73a4a` | Bug or error to fix |
| `enhancement` | `a2eeef` | New feature or improvement |
| `documentation` | `0075ca` | Documentation improvement |
| `testing` | `d876e3` | Tests and code quality |

#### Category: Compatibility

| Name | Color (hex) | Description |
|-----|---------------|-------------|
| `prestashop-9` | `5319e7` | Compatible with PrestaShop 9.x |
| `php-8.x` | `7057ff` | Compatible with PHP 8.x |

#### Category: Workflow

| Name | Color (hex) | Description |
|-----|---------------|-------------|
| `need-feedback` | `d4c5f9` | Need feedback or clarification |
| `ready-to-dev` | `c5def5` | Clear specifications, ready for dev |

### Tip:
Use the automated `setup-project.sh` script to create all labels automatically in all repositories!

---

## 6. Configuring Custom Views

### View 1: Kanban (default)

1. This view is created automatically
2. Configuration:
   - **Layout**: Board
   - **Group by**: Status
   - Displays columns: Backlog, To Do, In Progress, In Review, Done

### View 2: Roadmap (Timeline)

1. Click on current view → **"+ New view"**
2. Name: **"Roadmap"**
3. Choose layout: **"Roadmap"**
4. Configuration:
   - **Slice by**: Iteration (Sprint)
   - **Timeline**: 3 months (March - May 2026)
   - **Zoom**: By week
5. Save

### View 3: By Repository

1. Create a new view
2. Name: **"By Repository"**
3. Choose layout: **"Table"**
4. Configuration:
   - **Group by**: Repository
   - **Sort by**: Priority (descending)
   - Visible columns: Title, Status, Sprint, Labels, Assignees
5. Save

### View 4: By Priority

1. Create a new view
2. Name: **"By Priority"**
3. Choose layout: **"Table"**
4. Configuration:
   - **Group by**: Labels (filter on priority:*)
   - **Sort by**: Created date (descending)
   - Visible columns: Repository, Title, Status, Sprint
5. Save

---

## ✅ Final Checklist

After following this guide, you should have:

- [ ] A GitHub project named "PrestaShop Modules - Roadmap 2026"
- [ ] 5 configured Kanban columns
- [ ] 3 monthly sprints (March, April, May 2026)
- [ ] Issues from the 6 repositories added to the project
- [ ] Labels created in all concerned repositories
- [ ] 4 custom views: Kanban, Roadmap, By Repository, By Priority
- [ ] Priority issues assigned to the March 2026 sprint

---

## 🎯 Best Practices

### Daily Usage:

1. **Move cards** between columns according to their progress
2. **Assign issues** to responsible developers
3. **Update sprints** to plan the work
4. **Add labels** to facilitate sorting and searches
5. **Link PRs to issues** for automatic tracking

### Recommended Workflow:

```
Backlog → To Do → In Progress → In Review → Done
    ↓         ↓          ↓          ↓
 Sprint    Sprint    Sprint     Auto
planning  start    reviewing  close
```

### Weekly Maintenance:

- Review Backlog (prioritization)
- Update Roadmap
- Move issues according to progress
- Plan the next sprint

---

## 📞 Need Help?

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Iterations Guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields/about-iteration-fields)
- [Automation with GitHub Actions](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project)

---

**Good luck setting up your dashboard! 🚀**
