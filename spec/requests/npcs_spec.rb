require 'rails_helper'

RSpec.describe "Npcs", type: :request do
  before { session_sign_in }
  let(:user) { Current.session.user }

  describe "GET /npcs" do
    it "returns http success" do
      get npcs_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's NPCs" do
      npc = create(:npc, user: user)
      get npcs_path
      expect(response.body).to include(npc.name)
    end
  end

  describe "GET /npcs/new" do
    it "returns http success" do
      get new_npc_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /npcs" do
    let(:valid_params) do
      {
        npc: {
          name: "Test NPC",
          data: {
            'body_types' => 'Tall',
            'temperament' => 'Calm'
          }
        }
      }
    end

    it "creates a new NPC" do
      expect {
        post npcs_path, params: valid_params
      }.to change(Npc, :count).by(1)

      expect(response).to redirect_to(npc_path(Npc.last))
    end
  end

  describe "GET /npcs/:id" do
    let(:npc) { create(:npc, user: user) }

    it "returns http success" do
      get npc_path(npc)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /npcs/randomize" do
    it "returns http success" do
      get randomize_npcs_path
      expect(response).to have_http_status(:success)
    end

    it "renders the new template with randomized data" do
      get randomize_npcs_path
      expect(response).to render_template(:new)
    end
  end
end
