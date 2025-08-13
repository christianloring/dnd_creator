# Development Guide

Quick guide for working on the D&D Creator app.

## Setup

```bash
git clone https://github.com/christianloring/dnd_creator.git
cd dnd_creator
bundle install
bin/setup
bin/dev
```

## Project Structure

```
app/
├── models/          # Character, GameProfile, Encounter, NPC
├── controllers/     # RESTful controllers
├── services/        # EncounterBuilder, MonsterRepository
├── javascript/      # Combat simulator (game.js)
└── views/          # ERB templates with Tailwind

spec/               # RSpec tests
```

## Key Models

### Character
- Core character data with fantasy classes
- Ability scores and modifiers
- Associations with GameProfile, Campaigns, Notes

### GameProfile
- Game state and progression
- Combat stats, experience, gold
- JSON data for gear and meta upgrades

### Encounter
- Generated encounters with monsters
- Difficulty scaling and XP budgets
- Different encounter shapes (solo, boss+minions, swarm)

## Testing

```bash
bundle exec rspec                    # All tests
bundle exec rspec spec/models/       # Model tests
bundle exec rspec spec/system/       # System tests
```

## Game Mechanics

### Combat Simulator
- Turn-based combat in vanilla JavaScript
- Shop system for gear and items
- Experience and leveling progression
- AJAX calls to save/load game state

### Encounter Builder
- AI-powered encounter generation
- Difficulty scaling based on party level/size
- Monster selection and XP budgeting

## Code Style

- Follow Ruby style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep methods focused and small

## Common Tasks

### Adding a new character class
1. Add to `Character::FANTASY_CLASSES`
2. Add subclasses to `SUBCLASSES_BY_CLASS`
3. Update tests

### Adding new game features
1. Update `GameProfile` model
2. Modify `game.js` for UI
3. Add controller endpoints
4. Write tests

### Database changes
```bash
bin/rails generate migration AddFieldToTable
bin/rails db:migrate
```

## Debugging

```bash
bin/rails console     # Rails console
tail -f log/development.log  # View logs
```

## Deployment

```bash
kamal deploy
```
