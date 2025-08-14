require 'rails_helper'

RSpec.describe "Campaigns", type: :request do
  before { session_sign_in }
  let(:user) { Current.session.user }
  let(:campaign) { create(:campaign, user: user) }
  let(:other_user) { create(:user) }
  let(:other_campaign) { create(:campaign, user: other_user) }

  describe "GET /campaigns" do
    it "returns http success" do
      get campaigns_path
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get campaigns_path
      expect(response).to render_template(:index)
    end

    it "assigns user's campaigns" do
      user_campaign = create(:campaign, user: user)
      other_campaign = create(:campaign, user: other_user)

      get campaigns_path

      expect(assigns(:campaigns)).to include(user_campaign)
      expect(assigns(:campaigns)).not_to include(other_campaign)
    end

    it "sets breadcrumbs" do
      get campaigns_path
      expect(response.body).to include("Campaigns")
    end
  end

  describe "GET /campaigns/:id" do
    context "when campaign belongs to current user" do
      it "returns http success" do
        get campaign_path(campaign)
        expect(response).to have_http_status(:success)
      end

      it "renders the show template" do
        get campaign_path(campaign)
        expect(response).to render_template(:show)
      end

      it "assigns the campaign" do
        get campaign_path(campaign)
        expect(assigns(:campaign)).to eq(campaign)
      end

      it "sets breadcrumbs" do
        get campaign_path(campaign)
        expect(response.body).to include("Campaigns")
        expect(response.body).to include(campaign.name)
      end
    end

    context "when campaign belongs to another user" do
      it "returns 404 not found" do
        get campaign_path(other_campaign)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /campaigns/new" do
    it "returns http success" do
      get new_campaign_path
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      get new_campaign_path
      expect(response).to render_template(:new)
    end

    it "assigns a new campaign" do
      get new_campaign_path
      expect(assigns(:campaign)).to be_a_new(Campaign)
      expect(assigns(:campaign).user).to eq(user)
    end

    it "sets breadcrumbs" do
      get new_campaign_path
      expect(response.body).to include("Campaigns")
      expect(response.body).to include("New Campaign")
    end
  end

  describe "POST /campaigns" do
    let(:valid_params) do
      {
        campaign: {
          name: "The Lost Mines of Phandelver",
          description: "A classic D&D adventure for beginners"
        }
      }
    end

    let(:invalid_params) do
      {
        campaign: {
          name: "",
          description: ""
        }
      }
    end

    context "with valid parameters" do
      it "creates a new campaign" do
        expect {
          post campaigns_path, params: valid_params
        }.to change(Campaign, :count).by(1)
      end

      it "associates the campaign with the current user" do
        post campaigns_path, params: valid_params
        expect(Campaign.last.user).to eq(user)
      end

      it "redirects to the campaign show page" do
        post campaigns_path, params: valid_params
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end

      it "sets a success notice" do
        post campaigns_path, params: valid_params
        expect(flash[:notice]).to eq("Campaign created successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not create a campaign" do
        expect {
          post campaigns_path, params: invalid_params
        }.not_to change(Campaign, :count)
      end

      it "renders the new template" do
        post campaigns_path, params: invalid_params
        expect(response).to render_template(:new)
      end

      it "returns unprocessable content status" do
        post campaigns_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /campaigns/:id/edit" do
    context "when campaign belongs to current user" do
      it "returns http success" do
        get edit_campaign_path(campaign)
        expect(response).to have_http_status(:success)
      end

      it "renders the edit template" do
        get edit_campaign_path(campaign)
        expect(response).to render_template(:edit)
      end

      it "assigns the campaign" do
        get edit_campaign_path(campaign)
        expect(assigns(:campaign)).to eq(campaign)
      end

      it "sets breadcrumbs" do
        get edit_campaign_path(campaign)
        expect(response.body).to include("Campaigns")
        expect(response.body).to include(campaign.name)
        expect(response.body).to include("Edit")
      end
    end

    context "when campaign belongs to another user" do
      it "returns 404 not found" do
        get edit_campaign_path(other_campaign)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /campaigns/:id" do
    let(:valid_params) do
      {
        campaign: {
          name: "Updated Campaign Name",
          description: "Updated campaign description"
        }
      }
    end

    let(:invalid_params) do
      {
        campaign: {
          name: "",
          description: ""
        }
      }
    end

    context "when campaign belongs to current user" do
      context "with valid parameters" do
        it "updates the campaign" do
          patch campaign_path(campaign), params: valid_params
          campaign.reload
          expect(campaign.name).to eq("Updated Campaign Name")
          expect(campaign.description).to eq("Updated campaign description")
        end

        it "redirects to the campaign show page" do
          patch campaign_path(campaign), params: valid_params
          expect(response).to redirect_to(campaign_path(campaign))
        end

        it "sets a success notice" do
          patch campaign_path(campaign), params: valid_params
          expect(flash[:notice]).to eq("Campaign updated successfully.")
        end
      end

      context "with invalid parameters" do
        it "does not update the campaign" do
          original_name = campaign.name
          patch campaign_path(campaign), params: invalid_params
          campaign.reload
          expect(campaign.name).to eq(original_name)
        end

        it "renders the edit template" do
          patch campaign_path(campaign), params: invalid_params
          expect(response).to render_template(:edit)
        end

        it "returns unprocessable content status" do
          patch campaign_path(campaign), params: invalid_params
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when campaign belongs to another user" do
      it "returns 404 not found" do
        patch campaign_path(other_campaign), params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /campaigns/:id" do
    context "when campaign belongs to current user" do
      it "deletes the campaign" do
        campaign_to_delete = create(:campaign, user: user)
        expect {
          delete campaign_path(campaign_to_delete)
        }.to change(Campaign, :count).by(-1)
      end

      it "redirects to campaigns index" do
        delete campaign_path(campaign)
        expect(response).to redirect_to(campaigns_path)
      end

      it "sets a success notice" do
        delete campaign_path(campaign)
        expect(flash[:notice]).to eq("Campaign deleted successfully.")
      end
    end

    context "when campaign belongs to another user" do
      it "returns 404 not found" do
        delete campaign_path(other_campaign)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "authentication" do
    context "when user is not signed in" do
      before { allow(Current).to receive(:session).and_return(nil) }

      it "redirects to sign in page for index" do
        get campaigns_path
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for show" do
        # Create a campaign first since we need a valid ID
        test_user = create(:user)
        campaign_for_test = create(:campaign, user: test_user)
        get campaign_path(campaign_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for new" do
        get new_campaign_path
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for create" do
        post campaigns_path, params: { campaign: { name: "Test", description: "Test" } }
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for edit" do
        # Create a campaign first since we need a valid ID
        test_user = create(:user)
        campaign_for_test = create(:campaign, user: test_user)
        get edit_campaign_path(campaign_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for update" do
        # Create a campaign first since we need a valid ID
        test_user = create(:user)
        campaign_for_test = create(:campaign, user: test_user)
        patch campaign_path(campaign_for_test), params: { campaign: { name: "Test", description: "Test" } }
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for destroy" do
        # Create a campaign first since we need a valid ID
        test_user = create(:user)
        campaign_for_test = create(:campaign, user: test_user)
        delete campaign_path(campaign_for_test)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
