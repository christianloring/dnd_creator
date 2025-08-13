require 'rails_helper'

RSpec.describe "Characters::Notes", type: :request do
  let(:user) { create(:user) }
  let(:character) { create(:character, :warrior, user: user) }

  before do
    # Simulate authentication for request specs
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /index" do
    it "returns http redirect" do
      get character_notes_path(character)
      expect(response).to have_http_status(:redirect)
    end
  end
end
