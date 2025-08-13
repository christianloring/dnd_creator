require 'rails_helper'

RSpec.describe "Campaigns::Notes", type: :request do
  let(:user) { create(:user) }
  let(:campaign) { create(:campaign, user: user) }

  before do
    # Simulate authentication for request specs
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /index" do
    it "returns http redirect" do
      get campaign_notes_path(campaign)
      expect(response).to have_http_status(:redirect)
    end
  end
end
