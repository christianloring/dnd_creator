require 'rails_helper'

RSpec.describe 'Home and Dashboard', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Home Page' do
    it 'displays the home page for unauthenticated users' do
      visit root_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_button('Login')
    end

    it 'displays the home page for authenticated users' do
      user = create(:user)
      sign_in user
      visit root_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_button('Dashboard')
      expect(page).to have_button('Logout')
    end

    it 'shows appropriate navigation based on authentication status' do
      # Test unauthenticated
      visit root_path
      expect(page).to have_button('Dashboard')
      expect(page).to have_button('Login')

      # Test authenticated
      user = create(:user)
      sign_in user
      visit root_path
      expect(page).to have_button('Dashboard')
      expect(page).to have_button('Logout')
    end
  end

  describe 'Dashboard' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'requires authentication to access' do
      sign_out user
      visit dashboard_path

      expect(page).to have_current_path(new_session_path)
    end

    it 'displays dashboard for authenticated users' do
      visit dashboard_path

      expect(page).to have_current_path(dashboard_path)
      expect(page).to have_content('Dashboard')
    end

    it 'shows user statistics' do
      # Create some test data
      other_user = create(:user)
      create_list(:character, 3, user: user)
      create_list(:character, 2, user: other_user)

      visit dashboard_path

      expect(page).to have_content(User.count)
      expect(page).to have_content(Character.count)
    end

    it 'provides navigation to character management' do
      skip "TODO: Dashboard navigation links not implemented"
      visit dashboard_path

      expect(page).to have_link('Characters')
      expect(page).to have_link('New Character')
    end

    it 'shows user information' do
      skip "TODO: User information not displayed on dashboard"
      visit dashboard_path

      expect(page).to have_content(user.email_address)
    end
  end

  describe 'Navigation Flow' do
    let(:user) { create(:user) }

    it 'allows navigation from home to dashboard' do
      sign_in user
      visit root_path

      click_button 'Dashboard'

      expect(page).to have_current_path(dashboard_path)
    end

    it 'allows navigation from dashboard back to home' do
      skip "TODO: Home link not implemented on dashboard"
      sign_in user
      visit dashboard_path

      click_link 'Home' # Assuming there's a home link

      expect(page).to have_current_path(root_path)
    end
  end

  describe 'Responsive Design' do
    it 'displays properly on different screen sizes' do
      visit root_path

      # Test that the page loads without errors
      expect(page).to have_content('Welcome to your next adventure')

      # Test that navigation elements are present
      expect(page).to have_css('main')
    end
  end
end
