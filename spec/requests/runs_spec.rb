require 'rails_helper'

RSpec.describe "Runs", type: :request do
  before { session_sign_in }
  let(:character) { create(:character, user: Current.session.user) }
  let(:game_profile) { create(:game_profile, character: character) }

  describe "POST /characters/:character_id/runs" do
    let(:valid_params) do
      {
        run: {
          stage: 3,
          result: 'win',
          score: 250
        }
      }
    end

    it "creates a run successfully" do
      expect {
        post character_runs_path(character), params: valid_params
      }.to change(Run, :count).by(1)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['run']['score']).to eq(250)
    end

    it "creates game profile if it doesn't exist" do
      expect {
        post character_runs_path(character), params: valid_params
      }.to change(GameProfile, :count).by(1)
    end

    it "uses existing game profile if it exists" do
      game_profile # Create the game profile
      expect {
        post character_runs_path(character), params: valid_params
      }.not_to change(GameProfile, :count)
    end

    it "captures game state data correctly" do
      game_profile.update!(
        level: 4,
        exp: 15,
        hp_current: 18,
        gold: 300,
        data: { gear: { armor: 2, weapon: 1 } }
      )

      post character_runs_path(character), params: valid_params

      run = Run.last
      expect(run.data['final_level']).to eq(4)
      expect(run.data['final_exp']).to eq(15)
      expect(run.data['final_hp']).to eq(18)
      expect(run.data['final_gold']).to eq(300)
              expect(run.data['game_data']).to eq({ 'gear' => { 'armor' => 2, 'weapon' => 1 } })
    end

    context "with invalid parameters" do
      it "returns error for invalid stage" do
        invalid_params = valid_params.deep_merge(run: { stage: 0 })

        post character_runs_path(character), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end

      it "returns error for invalid result" do
        invalid_params = valid_params.deep_merge(run: { result: 'invalid' })

        post character_runs_path(character), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end

      it "returns error for negative score" do
        invalid_params = valid_params.deep_merge(run: { score: -1 })

        post character_runs_path(character), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end
    end

    context "with missing parameters" do
      it "returns error for missing stage" do
        invalid_params = valid_params.deep_merge(run: { stage: nil })

        post character_runs_path(character), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end

      it "returns error for missing result" do
        invalid_params = valid_params.deep_merge(run: { result: nil })

        post character_runs_path(character), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be false
        expect(json_response['errors']).to be_present
      end
    end
  end
end
