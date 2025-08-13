require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'User Registration' do
        it 'allows a user to create a new account' do
      visit root_path
      click_button 'Login'
      click_link 'Create account'

      fill_in 'Email address', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Create Account'

      # User should be redirected to home page and be logged in
      expect(page).to have_current_path(root_path)
      expect(page).to have_button('Logout')
      expect(page).to have_button('Dashboard')
    end

        it 'shows validation errors for invalid registration' do
      visit new_registration_path

      fill_in 'Email address', with: 'invalid-email'
      fill_in 'Password', with: 'short'
      fill_in 'Password confirmation', with: 'different'
      click_button 'Create Account'

      # Form should still be on the registration page (not redirected)
      expect(page).to have_current_path(registration_path)
      expect(page).to have_button('Create Account')
    end

        it 'prevents duplicate email registration' do
      user = create(:user, email_address: 'existing@example.com')

      visit new_registration_path
      fill_in 'Email address', with: 'existing@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Create Account'

      # Form should still be on the registration page (not redirected)
      expect(page).to have_current_path(registration_path)
      expect(page).to have_button('Create Account')
    end
  end

  describe 'User Login' do
    let(:user) { create(:user, email_address: 'test@example.com') }

        it 'allows a user to log in with valid credentials' do
      # First create a user through registration
      visit root_path
      click_button 'Login'
      click_link 'Create account'

      fill_in 'Email address', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Create Account'

      # Now log out
      click_button 'Logout'

      # Then log back in
      click_button 'Login'
      fill_in 'email_address', with: 'test@example.com'
      fill_in 'password', with: 'password123'
      click_button 'Sign in'

      # User should be logged in and see logout button
      expect(page).to have_button('Logout')
      expect(page).to have_button('Dashboard')
    end

        it 'shows error for invalid credentials' do
      visit new_session_path

      fill_in 'email_address', with: 'test@example.com'
      fill_in 'password', with: 'wrongpassword'
      click_button 'Sign in'

      expect(page).to have_content('Try another email address or password')
    end

        it 'shows error for non-existent user' do
      visit new_session_path

      fill_in 'email_address', with: 'nonexistent@example.com'
      fill_in 'password', with: 'password123'
      click_button 'Sign in'

      expect(page).to have_content('Try another email address or password')
    end
  end

  describe 'User Logout' do
    let(:user) { create(:user) }

        it 'allows a user to log out' do
      sign_in user
      visit root_path

      click_button 'Logout'

      # User should be logged out and see login button
      expect(page).to have_button('Login')
      expect(page).not_to have_button('Logout')
    end
  end

  describe 'Navigation' do
        it 'shows login/register links when not authenticated' do
      visit root_path

      expect(page).to have_button('Login')
      expect(page).to have_button('Dashboard') # Dashboard is always visible
    end

        it 'shows user menu when authenticated' do
      user = create(:user)
      sign_in user
      visit root_path

      expect(page).to have_button('Logout')
      expect(page).to have_button('Dashboard')
    end
  end
end
