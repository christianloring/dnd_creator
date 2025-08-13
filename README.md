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

Visit `http://localhost:3000` to get started.

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

## What I Learned

- **Rails 8**: Latest Rails features and conventions
- **Modern JavaScript**: ES6+ features and DOM manipulation
- **Game Development**: Turn-based combat mechanics and state management
- **Testing**: Comprehensive RSpec testing with system tests
- **Deployment**: Docker containerization and Kamal deployment

## Future Ideas

- Character sheet export (PDF)
- Multiplayer combat
- More complex encounter generation
- Character leveling system
- Campaign management tools

---

## ✅ Feature Checklist

### 🔒 Core Functionality
- [x] Authentication & User Management
- [x] Character Creation & Management
- [x] Character Sheet Display
- [x] Image Upload (Profile Pictures)
- [x] Combat Simulator (JavaScript)
- [x] Game State Persistence
- [x] Experience & Leveling System
- [x] Shop System (Gear & Items)
- [x] RSpec Testing (237 examples, 56% coverage)
- [x] Documentation (API, Development, Deployment)
- [x] Tailwind CSS Integration
- [x] Responsive Design

### ⚔️ Encounter Builder
- [x] Encounter Generation Service
- [x] XP Budget Calculation
- [x] Monster Selection by CR/XP
- [x] Different Encounter Types (solo, boss+minions, swarm)
- [x] Theme-based Monster Filtering
- [x] Encounter History & Management
- [x] Party Level & Size Scaling

### 👥 NPC Generator
- [x] Comprehensive NPC Creation System
- [x] Random NPC Generation
- [x] Detailed Physical Traits (body, face, hair, etc.)
- [x] Personality & Behavior Traits
- [x] Voice & Speech Patterns
- [x] Clothing & Appearance
- [x] NPC Management (CRUD)

### 📝 Campaign & Session Management
- [x] Campaign Creation & Management
- [x] Character-Campaign Associations
- [x] Polymorphic Notes System
- [x] Character Notes
- [x] Campaign Notes
- [x] Session Tracking (Runs)

### 🎮 Game Mechanics
- [x] Turn-based Combat System
- [x] Attack & Damage Calculation
- [x] Spell Casting System
- [x] Healing Mechanics
- [x] Gold & Economy System
- [x] Gear Progression (Armor, Weapons, Wands)
- [x] Meta Upgrades (Battle Training, etc.)
- [x] Game State Persistence

### 🏗️ Technical Infrastructure
- [x] RESTful API Design
- [x] Service Object Architecture
- [x] Factory-based Testing
- [x] System Tests with Capybara
- [x] Database Design & Migrations
- [x] Docker Configuration
- [x] Kamal Deployment Setup

### 🎨 User Interface
- [x] Dashboard with Tool Categories
- [x] DM Tools Section
- [x] Player Tools Section
- [x] For Fun Tools Section
- [x] Responsive Layout
- [x] Modal Systems (Shop)
- [x] Form Validation

---

## 🚀 Future Development Ideas

### 🎯 High Priority
- **Character Sheet Export**: PDF generation for character sheets
- **Multiplayer Combat**: Real-time combat with multiple players
- **Advanced Encounter Builder**: More monster types and encounter themes
- **Character Leveling System**: Full progression with new abilities
- **Campaign Session Tracking**: Detailed session logs and planning
- **Bread crumb navigation**: Allow easy access to previous pages

### 🎮 Game Enhancements
- **Dice Roller**: Interactive dice rolling with animations
- **Character Concept Generator**: Random character ideas and backstories
- **Theme Suggestions**: Campaign and encounter theme recommendations
- **Loot System**: Random treasure and item generation
- **Spell Database**: Comprehensive spell management

### 🛠️ Technical Improvements
- **Real-time Updates**: WebSocket integration for live updates
- **Background Jobs**: Sidekiq for heavy processing tasks
- **File Management**: S3 integration for better file storage
- **Performance Optimization**: Caching and database optimization

### 🌐 Community Features
- **Public Campaigns**: Share campaigns with other users
- **Character Templates**: Pre-built character concepts
- **Encounter Sharing**: Community encounter library
- **User Ratings**: Rate and review encounters and NPCs
- **Homebrew Suggestions**: Suggest improvements to home games

### 🔧 Developer Experience
- **API Client Libraries**: JavaScript/TypeScript SDK
- **Webhook System**: Integration with external tools
- **Plugin Architecture**: Extensible system for custom features
- **Mobile App**: React Native or PWA for mobile access

---

This is a personal project built for learning and portfolio purposes. The fantasy classes and mechanics are inspired by tabletop RPGs but use original content to avoid trademark issues.
