module SystemTestHelpers
  def sign_in(user)
    visit new_session_path
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'password123'
    click_button 'Sign in'
  end

  def sign_out(user)
    click_button 'Logout'
  end

  def create_character_with_stats(user, stats = {})
    default_stats = {
      name: 'Test Character',
      character_class: 'Warrior',
      species: 'Human',
      level: 5,
      strength: 16,
      dexterity: 14,
      constitution: 12,
      intelligence: 10,
      wisdom: 12,
      charisma: 8,
      hitpoints: 45,
      max_hp: 45,
      speed: 30
    }

    create(:character, user: user, **default_stats.merge(stats))
  end

  def wait_for_game_to_load
    expect(page).to have_css('#game-root', wait: 10)
  end

  def wait_for_combat_log
    expect(page).to have_css('#combat-log', wait: 5)
  end

  def defeat_enemy
    until find('#ui-ehp').text.to_i <= 0
      click_button 'Attack'
      sleep(0.1)
    end
  end

  def open_shop
    click_button 'Shop'
    expect(page).to have_css('.modal', wait: 5)
  end

  def close_shop
    find('body').send_keys(:escape)
    expect(page).not_to have_css('.modal')
  end

  def expect_no_console_errors
    expect(page).to have_no_console_errors
  end

  def expect_game_loaded
    expect(page).to have_css('#game-root')
    expect(page).to have_button('Attack')
    expect(page).to have_button('Cast Spell')
    expect(page).to have_button('Heal')
    expect(page).to have_button('Shop')
  end
end

RSpec.configure do |config|
  config.include SystemTestHelpers, type: :system
end
