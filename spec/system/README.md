# System Tests for TTRPG Creator

This directory contains comprehensive system tests for the TTRPG Creator application, covering all major user workflows and functionality.

## Test Files

- **authentication_spec.rb** - User registration, login, logout flows
- **home_and_dashboard_spec.rb** - Home page and dashboard functionality
- **character_management_spec.rb** - Character creation, editing, listing, deletion
- **minigame_spec.rb** - Character combat simulation and game mechanics

## Running Tests

```bash
# Run all system tests
bundle exec rspec spec/system/

# Run specific test file
bundle exec rspec spec/system/authentication_spec.rb

# Run with JavaScript (Selenium)
bundle exec rspec spec/system/minigame_spec.rb --tag js
```

## Configuration

Tests are configured to use:
- **Rack Test** for fast, non-JavaScript tests
- **Selenium Chrome Headless** for JavaScript-dependent tests
- **FactoryBot** for test data generation
- **Capybara** for browser interaction

## Test Helpers

See `spec/support/system_test_helpers.rb` for:
- Authentication helpers (`sign_in`, `sign_out`)
- Character creation helpers
- Game interaction helpers

## Factories

All factories are located in `spec/support/factories/`:
- `users.rb` - User accounts
- `characters.rb` - Character data with fantasy classes
- `game_profiles.rb` - Game state data
- `campaigns.rb` - Campaign management
- `notes.rb` - Note-taking functionality

## Troubleshooting

- **Selenium issues**: Ensure Chrome/ChromeDriver is installed
- **Factory errors**: Check factory associations and validations
- **Test failures**: Verify UI elements match test expectations
