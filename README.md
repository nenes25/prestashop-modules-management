# PrestaShop Modules Management - Dashboard GitHub

Dépôt dédié à la gestion transverse des 6 modules PrestaShop via un GitHub Project centralisé.

## 🎯 Objectif

Ce dépôt contient tous les outils et la configuration nécessaires pour créer et gérer un **GitHub Project global** permettant de suivre la planification, la progression, et les sprints mensuels des développements sur les modules PrestaShop.

## 📦 Modules concernés

1. **[eicaptcha](https://github.com/nenes25/eicaptcha)** - Module de captcha
2. **[prestashop_console](https://github.com/nenes25/prestashop_console)** - Console CLI pour PrestaShop  
3. **[hhpsmigrationupgradedb](https://github.com/nenes25/hhpsmigrationupgradedb)** - Migration et upgrade de base de données
4. **[hhmodulesmanager](https://github.com/nenes25/hhmodulesmanager)** - Gestionnaire de modules
5. **[cronjobs](https://github.com/nenes25/cronjobs)** - Gestion des tâches planifiées
6. **[hhmodulescatalogapi](https://github.com/nenes25/hhmodulescatalogapi)** - API catalogue de modules

## 🚀 Démarrage rapide

### Prérequis

1. **GitHub CLI** installé et authentifié
   ```bash
   # Installation (Ubuntu/Debian)
   sudo apt install gh
   
   # Installation (macOS)
   brew install gh
   
   # Authentification
   gh auth login
   ```

2. **jq** pour le traitement JSON
   ```bash
   # Ubuntu/Debian
   sudo apt install jq
   
   # macOS
   brew install jq
   ```

### Installation automatique

```bash
# Cloner le dépôt
git clone https://github.com/nenes25/prestashop-modules-management.git
cd prestashop-modules-management

# Se placer dans le dossier scripts
cd scripts

# Exécuter le script de setup
./setup-project.sh
```

Le script va:
1. ✅ Créer le projet GitHub "PrestaShop Modules - Roadmap 2026"
2. ✅ Créer les labels dans tous les dépôts
3. ✅ Ajouter les issues existantes au projet
4. ℹ️ Afficher les instructions pour les étapes manuelles restantes

## 📂 Structure du dépôt

```
prestashop-modules-management/
├── README.md                    # Documentation principale (ce fichier)
├── config/
│   └── project-config.json     # Configuration du projet (colonnes, labels, repos)
├── scripts/
│   ├── setup-project.sh        # Script d'installation automatique
│   └── project-helper.sh       # Script utilitaire pour opérations courantes
└── docs/
    ├── QUICKSTART.md           # Guide de démarrage rapide (5 minutes)
    ├── MANUAL_SETUP.md         # Guide de configuration manuelle détaillée
    └── VERIFICATION.md         # Rapport de vérification et tests
```

## 📚 Documentation

- **[Quick Start](docs/QUICKSTART.md)** - Démarrage rapide en 5 minutes
- **[Manuel de configuration](docs/MANUAL_SETUP.md)** - Guide détaillé pour setup manuel
- **[Vérification](docs/VERIFICATION.md)** - Tests et validation

## 🏷️ Labels créés

### Priorité
- `priority:high` 🔴 - Priorité haute
- `priority:medium` 🟡 - Priorité moyenne
- `priority:low` 🟢 - Priorité basse

### Type
- `bug` 🐛 - Bug ou erreur à corriger
- `enhancement` ✨ - Nouvelle fonctionnalité ou amélioration
- `documentation` 📚 - Documentation
- `testing` 🧪 - Tests

### Compatibilité
- `prestashop-9` 🛒 - Compatible PrestaShop 9.x
- `php-8.x` 🐘 - Compatible PHP 8.x

### Workflow
- `need-feedback` 💬 - Besoin de retour/clarification
- `ready-to-dev` ✅ - Prêt pour le développement

## 🔧 Commandes utiles

### Lister les projets GitHub
```bash
./scripts/project-helper.sh list-projects
```

### Ajouter une issue au projet
```bash
./scripts/project-helper.sh add-issue nenes25/eicaptcha 331 PROJECT_ID
```

### Créer un label dans tous les repos
```bash
./scripts/project-helper.sh bulk-label priority:urgent ff0000 "Urgent"
```

### Vérifier les issues d'un repo
```bash
./scripts/project-helper.sh check-issues nenes25/eicaptcha
```

### Lister les dépôts configurés
```bash
./scripts/project-helper.sh list-repos
```

### Afficher l'aide
```bash
./scripts/project-helper.sh help
```

## 📝 Configuration manuelle post-installation

Certaines configurations doivent être faites manuellement via l'interface GitHub:

### 1. Configuration des colonnes Kanban

Aller sur le projet → Configurer les colonnes:

- **Backlog** - Issues en attente de priorisation
- **À faire** - Issues priorisées pour le prochain sprint
- **En cours** - Issues en cours de développement
- **En revue** - Pull requests en cours de revue
- **Terminé** - Issues et PRs terminés

### 2. Ajout des Iterations (Sprints)

1. Dans le projet, aller dans **Settings** → **Fields**
2. Créer un nouveau field de type **Iteration**
3. Ajouter les sprints:
   - **Mars 2026** (1er mars 2026, durée: 4 semaines)
   - **Avril 2026** (1er avril 2026, durée: 4 semaines)
   - **Mai 2026** (1er mai 2026, durée: 4 semaines)

### 3. Création des vues personnalisées

#### Vue Kanban (par défaut)
- Type: Board
- Groupé par: Status/Colonne

#### Vue Roadmap
- Type: Roadmap
- Layout: Timeline (3 mois)
- Groupé par: Iteration

#### Vue par dépôt
- Type: Table
- Groupé par: Repository

#### Vue par priorité
- Type: Table
- Groupé par: Labels (priority:*)

## 🔄 Modification de la configuration

Pour modifier la configuration du projet, éditez le fichier `config/project-config.json`:
- Ajouter/supprimer des dépôts
- Modifier les issues à inclure
- Personnaliser les labels
- Ajuster les iterations

## 🤝 Contribution

Pour proposer des améliorations:
1. Modifier le fichier `config/project-config.json` ou les scripts
2. Tester vos modifications
3. Soumettre une Pull Request

## 📚 Ressources

- [Documentation GitHub Projects](https://docs.github.com/fr/issues/planning-and-tracking-with-projects)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Guide des labels GitHub](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)

## 📞 Support

En cas de problème:
1. Vérifier que GitHub CLI est authentifié: `gh auth status`
2. Vérifier les permissions sur les dépôts
3. Consulter la [documentation](docs/)
4. Ouvrir une issue dans ce dépôt

---

**Ce dépôt facilite la gestion collaborative des modules PrestaShop. N'hésitez pas à adapter la configuration selon vos besoins spécifiques.**