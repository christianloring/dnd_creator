require 'rails_helper'

RSpec.describe "Characters", type: :request do
  before { session_sign_in }
  let(:character) { create(:character, user: Current.session.user) }

  describe "GET /index" do
    it "returns http success" do
      get characters_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get character_path(character)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_character_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post characters_path, params: { character: attributes_for(:character) }

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_character_path(character)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    it "returns http success" do
      patch character_path(character), params: { character: attributes_for(:character) }

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      delete character_path(character)

      expect(response).to have_http_status(:redirect)
    end
  end
end
