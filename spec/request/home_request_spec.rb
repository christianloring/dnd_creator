require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when user is not signed in" do
      it "redirects to sign in page" do
        get root_path
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is signed in" do
      before { session_sign_in }

      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "renders the dashboard template" do
        get root_path
        expect(response).to render_template(:dashboard)
      end

      it "assigns user's characters" do
        user = Current.session.user
        character = create(:character, user: user)

        get root_path

        expect(assigns(:characters)).to include(character)
      end

      it "assigns user's campaigns" do
        user = Current.session.user
        campaign = create(:campaign, user: user)

        get root_path

        expect(assigns(:campaigns)).to include(campaign)
      end
    end
  end
end
