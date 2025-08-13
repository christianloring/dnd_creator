# D&D Character Manager

A Rails web app for managing fantasy characters and running simple combat encounters. Built as a personal project to learn Rails 8, modern JavaScript, and game development concepts.

## Features

- **Character Management**: Create and manage fantasy characters with stats and classes
- **Combat Simulator**: Turn-based combat with progression and shop system
- **Encounter Builder**: Generate balanced encounters for different party sizes
- **NPC Generator**: Create random NPCs with personalities and backgrounds
- **Campaign Notes**: Take notes for characters and campaigns

## Tech Stack

- **Backend**: Rails 8, Ruby 3.4, PostgreSQL
- **Frontend**: Tailwind CSS, Stimulus.js, vanilla JavaScript
- **Testing**: RSpec, Capybara
- **Deployment**: Docker, Kamal

## Quick Start

```bash
git clone https://github.com/christianloring/dnd_creator.git
cd dnd_creator
bundle install
bin/setup
bin/dev
```

Visit `http://localhost:3333` to get started.

## Project Structure

```
app/
├── models/          # Character, GameProfile, Encounter, NPC
├── controllers/     # RESTful controllers for all resources
├── services/        # EncounterBuilder, MonsterRepository
├── javascript/      # Combat simulator (game.js)
└── views/          # ERB templates with Tailwind

spec/               # RSpec tests with good coverage
docs/              # API and deployment docs
```

## Key Components

### Character System
- Fantasy classes (Warrior, Mage, Scout, etc.) with subclasses
- Ability scores with automatic modifier calculations
- Game profiles for tracking progression and combat stats

### Combat Simulator
- Turn-based combat in vanilla JavaScript
- Shop system for purchasing gear and items
- Experience and leveling progression
- Persistent game state via AJAX

### Encounter Builder
- AI-powered encounter generation
- Difficulty scaling based on party level/size
- Different encounter types (solo boss, boss + minions, swarm)

## Testing

```bash
bundle exec rspec                    # Run all tests
bundle exec rspec spec/system/       # System tests
bundle exec rspec --format progress  # Progress format
```

## Deployment

The app is configured for deployment with Kamal:

```bash
kamal deploy
```
---

## ✅ Feature Checklist

### 🔒 Core Functionality
- [x] Authentication
- [x] User creation
- [X] Character creation
- [X] Simple combat simulator
- [x] RSpec testing
- [x] Documentation
- [x] CI/CD
- [ ] Deployment
- [X] Tailwind integration
- [X] Image uploading (character portraits)

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

### 🛠️ Admin Tools
- [ ] Admin interface
- [ ] Dice roller
- [ ] Encounter templates or saved setups

### 🏗️ Technical Infrastructure
- [ ] API Development - RESTful API with proper documentation
- [ ] Background Jobs - Sidekiq for heavy processing (PDF generation, etc.)
- [ ] File Upload/Management - S3 integration for images/documents

---

This is a personal project built for learning and portfolio purposes. The fantasy classes and mechanics are inspired by tabletop RPGs but use original content to avoid trademark issues.
