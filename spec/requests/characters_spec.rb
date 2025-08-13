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

  describe "GET /play" do
    it "returns http success" do
      get play_character_path(character)

      expect(response).to have_http_status(:success)
    end

    it "creates game profile if it doesn't exist" do
      expect {
        get play_character_path(character)
      }.to change(GameProfile, :count).by(1)
    end

    it "uses existing game profile if it exists" do
      game_profile = create(:game_profile, character: character)
      expect {
        get play_character_path(character)
      }.not_to change(GameProfile, :count)
    end
  end

  describe "PATCH /update_game_profile" do
    let(:game_profile) { create(:game_profile, character: character) }
    let(:valid_params) do
      {
        game_profile: {
          level: 2,
          exp: 5,
          hp_current: 18,
          max_hp: 20,
          gold: 50,
          data: { gear: { armor: 1 } }
        }
      }
    end

    it "updates game profile successfully" do
      patch update_game_profile_character_path(character), params: valid_params

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['game_profile']['level']).to eq(2)
    end

    it "handles level up correctly" do
      character.update!(level: 1, hitpoints: 20)
      game_profile.update!(level: 1, exp: 8, max_hp: 20, hp_current: 15)

      # Update to get exp to 10 (should trigger level up)
      params = valid_params.deep_merge(game_profile: { exp: 10, level: 1 }) # Keep level at 1
      patch update_game_profile_character_path(character), params: params

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['leveled_up']).to be true
      expect(json_response['game_profile']['level']).to eq(2)
      expect(json_response['game_profile']['exp']).to eq(0) # Reset after level up
    end

    it "returns errors for invalid data" do
      invalid_params = { game_profile: { level: -1 } }

      patch update_game_profile_character_path(character), params: invalid_params

      expect(response).to have_http_status(:unprocessable_content)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be false
      expect(json_response['errors']).to be_present
    end
  end

  describe "POST /reset_game_profile" do
    let(:game_profile) { create(:game_profile, character: character, level: 5, exp: 100, gold: 500) }

    it "resets game profile successfully" do
      post reset_game_profile_character_path(character)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['message']).to eq("Game progress reset successfully")
    end

    it "creates game profile if it doesn't exist" do
      expect {
        post reset_game_profile_character_path(character)
      }.to change(GameProfile, :count).by(1)
    end
  end
end
