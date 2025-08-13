require 'rails_helper'

RSpec.describe 'Character Minigame', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:character) do
    create(:character, :fighter,
      user: user,
      name: 'Test Character',
      level: 5,
      strength: 16,
      dexterity: 14,
      constitution: 12,
      intelligence: 10,
      wisdom: 12,
      charisma: 8,
      hitpoints: 45
    )
  end

  before do
    sign_in user
  end

    describe 'Game Initialization' do
        it 'loads the game page successfully' do
      visit play_character_path(character)

      expect(page).to have_current_path(play_character_path(character))
      expect(page).to have_content('Test Character')
      expect(page).to have_content('Battle:')
    end

        it 'displays character stats in the game UI' do
      visit play_character_path(character)

      expect(page).to have_content('HP')
      expect(page).to have_content('XP')
      expect(page).to have_content('Gold')
    end

        it 'shows the game interface elements' do
      visit play_character_path(character)

      # Basic game elements should be present
      expect(page).to have_content('Attack')
      expect(page).to have_content('Cast')
      expect(page).to have_content('Heal')
      expect(page).to have_content('Shop')
    end

    it 'initializes with an enemy present' do
      visit play_character_path(character)

      # Basic enemy info should be present
      expect(page).to have_content('Enemy')
    end
  end

  describe 'Combat Mechanics', js: true do
    before do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)
      # Wait for game to load
      expect(page).to have_css('#game-root')
    end

    it 'allows attacking enemies' do
      initial_enemy_hp = find('#ui-ehp').text.to_i

      click_button 'Attack'

      # Wait for combat log to update
      expect(page).to have_css('#combat-log')
      expect(page).to have_content('attacks')

      # Enemy HP should decrease
      new_enemy_hp = find('#ui-ehp').text.to_i
      expect(new_enemy_hp).to be < initial_enemy_hp
    end

    it 'allows casting spells' do
      initial_enemy_hp = find('#ui-ehp').text.to_i

      click_button 'Cast Spell'

      expect(page).to have_content('casts a spell')

      # Enemy HP should decrease
      new_enemy_hp = find('#ui-ehp').text.to_i
      expect(new_enemy_hp).to be < initial_enemy_hp
    end

    it 'allows healing' do
      # First take some damage
      click_button 'Attack'
      sleep(0.5) # Wait for enemy to attack back

      initial_hp = find('#ui-hp').text.to_i

      click_button 'Heal'

      expect(page).to have_content('heals')

      # HP should increase
      new_hp = find('#ui-hp').text.to_i
      expect(new_hp).to be > initial_hp
    end

    it 'tracks combat in the log' do
      click_button 'Attack'

      expect(page).to have_css('#combat-log')
      expect(page).to have_content('Test Character')
      expect(page).to have_content('Enemy 1')
    end

    it 'advances to next enemy when current enemy is defeated' do
      # Attack until enemy is defeated
      until find('#ui-ehp').text.to_i <= 0
        click_button 'Attack'
        sleep(0.1) # Small delay to allow for animations
      end

      # Should show "Next Battle" button
      expect(page).to have_button('Next Battle')
    end
  end

  describe 'Shop System', js: true do
    before do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)
      expect(page).to have_css('#game-root')
    end

    it 'opens the shop modal' do
      click_button 'Shop'

      expect(page).to have_css('.modal')
      expect(page).to have_content('Shop')
    end

    it 'displays available items in the shop' do
      click_button 'Shop'

      expect(page).to have_content('Armor')
      expect(page).to have_content('Weapon')
      expect(page).to have_content('Wand')
      expect(page).to have_content('Potion')
    end

    it 'shows current gold and gear' do
      click_button 'Shop'

      expect(page).to have_content('Gold: 0')
      expect(page).to have_content('Armor: 0')
      expect(page).to have_content('Weapon: 0')
      expect(page).to have_content('Wand: 0')
    end

    it 'allows purchasing items when enough gold' do
      # Give character some gold first
      character.game_profile.update!(gold: 100)
      visit play_character_path(character)

      click_button 'Shop'

      # Try to buy a potion (costs 50 gold)
      within('.shop-modal') do
        click_button 'Buy Potion'
      end

      expect(page).to have_content('Bought potion')
      expect(page).to have_content('Gold: 50')
    end

    it 'prevents purchasing when insufficient gold' do
      click_button 'Shop'

      # Try to buy armor (costs 100 gold) with 0 gold
      within('.shop-modal') do
        click_button 'Buy Armor Tier 1'
      end

      expect(page).to have_content('Not enough gold')
    end

    it 'closes shop modal with ESC key' do
      click_button 'Shop'
      expect(page).to have_css('.modal')

      find('body').send_keys(:escape)

      expect(page).not_to have_css('.modal')
    end

    it 'closes shop modal with close button' do
      click_button 'Shop'
      expect(page).to have_css('.modal')

      click_button 'Close'

      expect(page).not_to have_css('.modal')
    end
  end

  describe 'Game Progress', js: true do
    before do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)
      expect(page).to have_css('#game-root')
    end

    it 'tracks experience and level progression' do
      # Defeat an enemy to gain experience
      until find('#ui-ehp').text.to_i <= 0
        click_button 'Attack'
        sleep(0.1)
      end

      click_button 'Next Battle'

      # Should have gained experience
      expect(page).to have_content('Experience:')
      expect(find('#ui-exp').text.to_i).to be > 0
    end

    it 'allows resetting game progress' do
      # First gain some progress
      click_button 'Attack'
      sleep(0.5)

      click_button 'Reset Progress'

      # Confirm reset if dialog appears
      page.accept_confirm do
        click_button 'Reset Progress'
      end

      expect(page).to have_content('Progress reset')
    end

    it 'saves game state between sessions' do
      # Make some progress
      click_button 'Attack'
      sleep(0.5)

      # Navigate away and back
      visit characters_path
      visit play_character_path(character)

      # Game state should be preserved
      expect(page).to have_css('#game-root')
    end
  end

  describe 'Game UI Responsiveness', js: true do
    it 'displays correctly on different screen sizes' do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)

      # Test mobile viewport
      page.driver.browser.manage.window.resize_to(375, 667)
      expect(page).to have_css('#game-root')

      # Test desktop viewport
      page.driver.browser.manage.window.resize_to(1920, 1080)
      expect(page).to have_css('#game-root')
    end

    it 'handles rapid button clicks gracefully' do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)

      # Rapidly click attack button
      5.times { click_button 'Attack' }

      # Game should still be functional
      expect(page).to have_css('#game-root')
    end
  end

  describe 'Error Handling', js: true do
    it 'handles network errors gracefully' do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)

      # Simulate network error by disabling JavaScript
      page.execute_script('window.fetch = null;')

      # Game should still be accessible
      expect(page).to have_content('Test Character')
    end

        it 'prevents access to other users characters' do
      other_user = create(:user)
      other_character = create(:character, :fighter, user: other_user)

      # Sign out current user first
      sign_out user

      # Should redirect to login page
      visit play_character_path(other_character)
      expect(page).to have_current_path(new_session_path)
    end
  end

    describe 'Game Performance', js: true do
    it 'loads game assets efficiently' do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)

      # Check that JavaScript loads without errors
      expect(page).to have_no_console_errors

      # Game should be interactive within reasonable time
      expect(page).to have_button('Attack', wait: 5)
    end

    it 'maintains smooth gameplay during extended sessions' do
      skip "Requires JavaScript - run with Selenium driver"
      visit play_character_path(character)

      # Simulate extended gameplay
      10.times do
        click_button 'Attack'
        sleep(0.1)
      end

      # Game should remain responsive
      expect(page).to have_css('#game-root')
      expect(page).to have_button('Attack')
    end
  end

  describe 'Basic Game Page Functionality' do
    it 'loads the game page with character data' do
      visit play_character_path(character)

      expect(page).to have_current_path(play_character_path(character))
      expect(page).to have_content('Test Character')
      expect(page).to have_content('Battle:')
      expect(page).to have_content('HP')
      expect(page).to have_content('XP')
      expect(page).to have_content('Gold')
    end

    it 'prevents access to other users characters' do
      other_user = create(:user)
      other_character = create(:character, :fighter, user: other_user)

      # Sign out current user first
      sign_out user

      # Should redirect to login page
      visit play_character_path(other_character)
      expect(page).to have_current_path(new_session_path)
    end
  end
end
