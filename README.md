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
- [ ] Character creation
- [ ] Simple combat simulator
- [x] RSpec testing
- [x] Documentation
- [x] CI/CD
- [ ] Deployment
- [ ] Tailwind integration
- [ ] Image uploading (character portraits)

### ⚔️ Encounter Builder
- [ ] Use D&D’s new encounter-building EXP guide
- [ ] Generate random fights using monsters that match EXP budget
- [ ] Create different fight types (e.g. solo boss, boss + minions)
- [ ] Create themed fights (fire, ice, angelic, undead)

### 📈 Character System
- [ ] Leveling system
- [ ] Character sheet display
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
- [ ] Character flaws
- [ ] Character strengths

### 📝 Campaign & Session Management
- [ ] Ability to take notes
- [ ] Campaign planning
- [ ] Session planning

### �🛠️ Admin Tools
- [ ] Admin interface
- [ ] Dice roller
- [ ] Encounter templates or saved setups

### 🏗️ Technical Infrastructure
- [ ] API Development - RESTful API with proper documentation
- [ ] Background Jobs - Sidekiq for heavy processing (PDF generation, etc.)
- [ ] File Upload/Management - S3 integration for images/documents

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
bin/setup
