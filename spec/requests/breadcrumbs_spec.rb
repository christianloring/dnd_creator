require 'rails_helper'

RSpec.describe 'Breadcrumbs', type: :request do
  let(:character) { create(:character, :warrior, user: Current.session.user) }

  before do
    session_sign_in
  end

  describe 'character pages' do
    it 'shows breadcrumbs on characters index' do
      get characters_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Home')
      expect(response.body).to include('Characters')
    end

    it 'shows breadcrumbs on character show page' do
      get character_path(character)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Home')
      expect(response.body).to include('Characters')
      expect(response.body).to include(character.name)
    end

    it 'shows breadcrumbs on character edit page' do
      get edit_character_path(character)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Home')
      expect(response.body).to include('Characters')
      expect(response.body).to include(character.name)
      expect(response.body).to include('Edit')
    end
  end

  describe 'dashboard page' do
    it 'shows breadcrumbs on dashboard' do
      get dashboard_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Home')
      expect(response.body).to include('Dashboard')
    end
  end
end
