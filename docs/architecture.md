# Architecture Overview

Simple overview of the D&D Creator app architecture.

## Tech Stack

- **Backend**: Rails 8, Ruby 3.4, PostgreSQL
- **Frontend**: Tailwind CSS, Stimulus.js, vanilla JavaScript
- **Testing**: RSpec, Capybara
- **Deployment**: Docker, Kamal

## Application Structure

```
app/
├── models/          # Character, GameProfile, Encounter, NPC
├── controllers/     # RESTful controllers
├── services/        # EncounterBuilder, MonsterRepository
├── javascript/      # Combat simulator (game.js)
└── views/          # ERB templates with Tailwind

spec/               # RSpec tests
```

## Key Components

### Character System
- Fantasy classes with subclasses
- Ability scores and modifiers
- Game profiles for progression tracking

### Combat Simulator
- Turn-based combat in vanilla JavaScript
- Shop system for gear and items
- Experience and leveling progression
- AJAX calls to save/load game state

### Encounter Builder
- AI-powered encounter generation
- Difficulty scaling based on party level/size
- Different encounter types (solo, boss+minions, swarm)

## Database Design

### Core Tables
- `users` - User accounts
- `characters` - Character data
- `game_profiles` - Game state
- `encounters` - Generated encounters
- `npcs` - Non-player characters
- `campaigns` - Campaign management
- `notes` - Polymorphic notes

### Key Relationships
- Users have many Characters
- Characters have one GameProfile
- Characters belong to many Campaigns
- Characters have many Notes (polymorphic)

## Data Flow

### Character Creation
```
User Registration → Character Creation → Game Profile Creation → Ready for Gameplay
```

### Combat Flow
```
Game Initialization → Load Character Data → Combat Round → State Update → Save Progress
```

### Encounter Generation
```
User Input → Budget Calculation → Monster Selection → Balanced Encounter
```

## Service Layer

### EncounterBuilder
```ruby
class EncounterBuilder
  def call(request)
    xp_budget = calculate_budget(request)
    monsters = select_monsters(request, xp_budget)
    EncounterResult.new(budget: xp_budget, monsters: monsters)
  end
end
```

### MonsterRepository
```ruby
class MonsterRepository
  def best_boss_for(budget, theme: nil)
    # Monster selection logic
  end
end
```

## Frontend Architecture

### JavaScript
- **game.js**: Combat simulator and shop system
- **Stimulus controllers**: Interactive UI components
- **Vanilla JS**: No heavy frameworks, just ES6+ features

### Styling
- **Tailwind CSS**: Utility-first CSS framework
- **Responsive design**: Mobile-first approach

## Security

- Session-based authentication
- User ownership validation
- Input validation at model level
- CSRF protection

## Testing Strategy

- **Unit tests**: Models and services
- **Integration tests**: Controllers
- **System tests**: User workflows
- **Factory-based**: Test data generation

## Deployment

- **Docker**: Containerized deployment
- **Kamal**: Zero-downtime deployments
- **Environment variables**: Configuration management
