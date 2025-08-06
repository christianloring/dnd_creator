# D&D Character Manager and Combat Simulator

A full-stack Rails 8 web app for managing Dungeons & Dragons characters, encounters, loot, and more — with simple combat simulation and administrative tools.

## 🧠 Project Goals

Build a feature-rich application that supports the following:

- Scalable Rails architecture with Tailwind CSS and component-driven views
- Player-facing tools like character sheets, encounter generation, loot tracking
- Game master (DM) tools like NPC builders, dice rolling, and combat simulation
- Production-grade practices like CI/CD, atomic PRs, RSpec test coverage, and deployment

---

## ✅ Feature Checklist

### 🔒 Core Functionality
- [x] Authentication
- [x] User creation
- [x] Character creation
- [x] Simple combat simulator
- [x] RSpec testing
- [x] Documentation
- [x] CI/CD
- [x] Deployment
- [x] Tailwind integration (USWDS-comparable utility framework)
- [x] Image uploading (character portraits)

### ⚔️ Encounter Builder
- [ ] Use D&D’s new encounter-building EXP guide
- [ ] Generate random fights using monsters that match EXP budget
- [ ] Create different fight types (e.g. solo boss, boss + minions)
- [ ] Create themed fights (fire, ice, angelic, undead)

### 📈 Character System
- [ ] Leveling system
- [x] Character sheet display
- [ ] Character sheet export (PDF or print-friendly)

### 🎲 Items & Loot
- [ ] For-fun loot
- [ ] Combat loot
- [ ] Consumables
- [ ] Generic/other item types

### 👥 NPC Builder
- [ ] Randomize NPC characteristics
- [ ] Generate NPC names
- [ ] Create simple NPC backstories

### 🎭 Character Helper
- [ ] Generate or tag character tropes
- [ ] Theme suggestions
- [ ] Suggested flaws/strengths/class combos

### 🛠️ Admin Tools
- [ ] Admin interface
- [ ] Dice roller
- [ ] Encounter templates or saved setups

---

## 🚀 Getting Started

### Prerequisites

- Ruby 3.4.x
- Rails 8.x
- PostgreSQL
- Node + Yarn
- ImageMagick (for ActiveStorage previews, optional)

### Setup

```bash
git clone https://github.com/yourusername/dnd_creator.git
cd dnd_creator
bundle install
yarn install
bin/setup
