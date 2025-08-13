require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when user is not signed in" do
      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get root_path
        expect(response).to render_template(:index)
      end
    end

    context "when user is signed in" do
      before { session_sign_in }

      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get root_path
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET /dashboard" do
    context "when user is not signed in" do
      it "redirects to sign in page" do
        get dashboard_path
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "when user is signed in" do
      before { session_sign_in }

      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end

      it "renders the dashboard template" do
        get dashboard_path
        expect(response).to render_template(:dashboard)
      end

      it "assigns user count" do
        get dashboard_path
        expect(assigns(:user_count)).to be_present
      end
    end
  end
end
