# API Documentation

Basic REST API for the D&D Creator app. Most endpoints require authentication.

## Authentication

```http
POST /session
Content-Type: application/json

{
  "email_address": "user@example.com",
  "password": "password123"
}
```

## Characters

### List characters
```http
GET /characters
```

### Create character
```http
POST /characters
Content-Type: application/json

{
  "character": {
    "name": "Aragorn",
    "character_class": "Warrior",
    "subclass": "Path of the Berserker",
    "species": "Human",
    "level": 1,
    "strength": 16,
    "dexterity": 14,
    "constitution": 12,
    "intelligence": 10,
    "wisdom": 12,
    "charisma": 8,
    "hitpoints": 12,
    "speed": 30
  }
}
```

### Update game profile
```http
PATCH /characters/:id/update_game_profile
Content-Type: application/json

{
  "game_profile": {
    "level": 3,
    "exp": 900,
    "hp_current": 25,
    "max_hp": 25,
    "gold": 300,
    "data": {
      "gear": {"armor": 1, "weapon": 2, "wand": 0},
      "meta": {"battleTraining": true},
      "bag": {"potion": 2, "gpotion": 1}
    }
  }
}
```

## Encounters

### Generate encounter
```http
POST /encounters
Content-Type: application/json

{
  "encounter": {
    "party_level": 5,
    "party_size": 4,
    "difficulty": "medium",
    "shape": "boss_minions",
    "theme": "undead"
  }
}
```

## NPCs

### Randomize NPC
```http
GET /npcs/randomize
```

### Create NPC
```http
POST /npcs
Content-Type: application/json

{
  "npc": {
    "name": "Gandalf",
    "role": "Mentor",
    "personality": "Wise and mysterious",
    "appearance": "Tall wizard with grey robes",
    "background": "Ancient wizard with great knowledge"
  }
}
```

## Data Types

### Character Classes
- Warrior, Mage, Scout, Guardian, Mystic, Ranger, Rogue, Sage, Warlock, Wizard, Artificer

### Difficulty Levels
- easy, medium, hard, deadly

### Encounter Shapes
- solo_boss, two_bosses, boss_minions, swarm
