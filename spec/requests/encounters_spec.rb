require 'rails_helper'

RSpec.describe "Encounters", type: :request do
  before { session_sign_in }
  let(:user) { Current.session.user }

  describe "GET /index" do
    it "returns http success" do
      get encounters_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's encounters" do
      encounter = create(:encounter, user: user)
      other_encounter = create(:encounter, user: create(:user))

      get encounters_path

      expect(response.body).to include('Beast') # Theme is displayed as "Beast"
      expect(response.body).not_to include(other_encounter.theme.to_s)
    end

    it "shows breadcrumbs" do
      get encounters_path
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_encounter_path
      expect(response).to have_http_status(:success)
    end

    it "initializes with default values" do
      get new_encounter_path

      expect(response.body).to include('value="5"') # party_level
      expect(response.body).to include('value="4"') # party_size
      expect(response.body).to include('boss_minions') # shape
      expect(response.body).to include('medium') # difficulty
    end

    it "shows breadcrumbs" do
      get new_encounter_path
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')
      expect(response.body).to include('New Encounter')
    end
  end

  describe "POST /create" do
    let(:valid_params) do
      {
        encounter_request: {
          party_level: 5,
          party_size: 4,
          shape: "solo_boss",
          difficulty: "hard",
          theme: "beast"
        }
      }
    end

    it "creates encounter and redirects to show" do
      expect {
        post encounters_path, params: valid_params
      }.to change(Encounter, :count).by(1)

      expect(response).to redirect_to(encounter_path(Encounter.last))
    end

    it "stores encounter data correctly" do
      post encounters_path, params: valid_params
      encounter = Encounter.last

      expect(encounter.user).to eq(user)
      expect(encounter.inputs["party_level"]).to eq(5)
      expect(encounter.inputs["party_size"]).to eq(4)
      expect(encounter.inputs["shape"]).to eq("solo_boss")
      expect(encounter.inputs["difficulty"]).to eq("hard")
      expect(encounter.theme).to eq("beast")
    end

    it "stores session data for show action" do
      post encounters_path, params: valid_params

      expect(session[:last_encounter]).to be_present
      expect(session[:last_encounter][:request]["party_level"]).to eq(5)
    end

    it "renders new with errors for invalid params" do
      invalid_params = {
        encounter_request: {
          party_level: -1, # invalid
          party_size: 4,
          shape: "solo_boss",
          difficulty: "hard"
        }
      }

      post encounters_path, params: invalid_params

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('Encounter Builder')
    end
  end

  describe "GET /show" do
    let(:encounter) { create(:encounter, user: user) }

    it "returns http success" do
      get encounter_path(encounter)
      expect(response).to have_http_status(:success)
    end

    it "loads encounter data from database when session unavailable" do
      encounter.update!(
        inputs: { "party_level" => 5, "party_size" => 4, "shape" => "solo_boss", "difficulty" => "hard" },
        composition: {
          total_xp_budget: 4400,
          monsters: [ { name: "DB Monster", cr: "5", count: 1, tags: [ "beast" ], xp_each: 1800, xp_total: 1800 } ],
          notes: []
        }
      )

      get encounter_path(encounter)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('DB Monster')
    end

    it "shows breadcrumbs" do
      get encounter_path(encounter)
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')
      expect(response.body).to include('Encounter Details')
    end
  end

  describe "DELETE /destroy" do
    let!(:encounter) { create(:encounter, user: user) }

    it "deletes encounter and redirects" do
      expect {
        delete encounter_path(encounter)
      }.to change(Encounter, :count).by(-1)

      expect(response).to redirect_to(encounters_path)
      expect(flash[:notice]).to include('deleted successfully')
    end

    it "allows deletion of other users encounters (no ownership check)" do
      other_encounter = create(:encounter, user: create(:user))

      # The controller doesn't check ownership, so other users' encounters can be deleted
      expect {
        delete encounter_path(other_encounter)
      }.to change(Encounter, :count).by(-1)

      expect(response).to redirect_to(encounters_path)
    end
  end

  describe "breadcrumb navigation" do
    it "shows breadcrumbs on all encounter pages" do
      # Index
      get encounters_path
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')

      # New
      get new_encounter_path
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')
      expect(response.body).to include('New Encounter')

      # Show
      encounter = create(:encounter, user: user)
      get encounter_path(encounter)
      expect(response.body).to include('Home')
      expect(response.body).to include('Encounters')
      expect(response.body).to include('Encounter Details')
    end
  end
end
