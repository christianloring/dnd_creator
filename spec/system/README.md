# System Tests for D&D Creator

This directory contains comprehensive system tests for the D&D Creator application, covering all major user workflows and functionality.

## Test Files

### 1. `authentication_spec.rb`
Tests user registration, login, logout, and authentication flows.
- User registration with valid/invalid data
- Login with valid/invalid credentials
- Logout functionality
- Navigation based on authentication status

### 2. `home_and_dashboard_spec.rb`
Tests the home page and dashboard functionality.
- Home page display for authenticated/unauthenticated users
- Dashboard access and content
- User statistics display
- Navigation between pages

### 3. `character_management_spec.rb`
Tests character creation, editing, and management.
- Character creation with various attributes
- Character listing and filtering
- Character editing and validation
- Character deletion
- Profile picture uploads

### 4. `minigame_spec.rb`
Tests the character minigame functionality.
- Game initialization and loading
- Combat mechanics (attack, spell, heal)
- Shop system and purchasing
- Game progress tracking
- UI responsiveness and error handling

## Running the Tests

### Run all system tests:
```bash
bundle exec rspec spec/system/
```

### Run specific test file:
```bash
bundle exec rspec spec/system/authentication_spec.rb
```

### Run tests with JavaScript (for minigame tests):
```bash
bundle exec rspec spec/system/minigame_spec.rb
```

### Run tests with verbose output:
```bash
bundle exec rspec spec/system/ --format documentation
```

## Test Configuration

### Drivers
- **Rack Test**: Used for non-JavaScript tests (faster, no browser)
- **Selenium Chrome Headless**: Used for JavaScript tests (slower, but supports JS)

### Helpers
The `spec/support/system_test_helpers.rb` file contains helper methods:
- `sign_in(user)`: Helper for user authentication
- `wait_for_game_to_load`: Waits for game JavaScript to initialize
- `defeat_enemy`: Helper to defeat enemies in combat
- `open_shop`/`close_shop`: Shop interaction helpers

### Factories
Factories are defined in `spec/support/factories/`:
- `users.rb`: User factory with predictable password for testing
- `characters.rb`: Character factory with various traits
- `game_profiles.rb`: Game profile factory
- `campaigns.rb`: Campaign factory
- `notes.rb`: Note factory with traits for different notable types
- `runs.rb`: Run factory for game sessions

## Test Data

### Fixtures
- `spec/fixtures/files/test_image.jpg`: Test image for profile picture uploads

## Best Practices

1. **Use appropriate drivers**: Use rack_test for non-JS tests, selenium for JS tests
2. **Wait for elements**: Use Capybara's built-in waiting mechanisms
3. **Clean up data**: Tests should be independent and not rely on shared state
4. **Test user flows**: Focus on complete user workflows rather than isolated features
5. **Handle async operations**: Use proper waiting for JavaScript operations

## Troubleshooting

### Common Issues

1. **Tests failing due to timing**: Increase wait times or use `have_css` with `wait` option
2. **JavaScript not loading**: Ensure using selenium driver for JS tests
3. **Database state issues**: Use database cleaner or factory cleanup
4. **Image upload failures**: Ensure test image exists in fixtures

### Debugging

To debug failing tests:
```bash
# Run with detailed output
bundle exec rspec spec/system/failing_test_spec.rb --format documentation

# Run with browser visible (remove headless)
# Edit spec/support/capybara_config.rb to remove --headless option
```

## Coverage

These tests cover:
- ✅ User authentication (registration, login, logout)
- ✅ Home page and dashboard functionality
- ✅ Character creation, editing, and management
- ✅ Character minigame (combat, shop, progress)
- ✅ Navigation and user flows
- ✅ Error handling and validation
- ✅ Responsive design and UI interactions

## Adding New Tests

When adding new system tests:

1. Create a new spec file in `spec/system/`
2. Use appropriate driver (rack_test vs selenium)
3. Include helper methods from `SystemTestHelpers`
4. Use factories for test data
5. Follow the existing patterns and structure
6. Add documentation for new test files
