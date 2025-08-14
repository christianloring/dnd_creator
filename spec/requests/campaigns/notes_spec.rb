require 'rails_helper'

RSpec.describe "Campaigns::Notes", type: :request do
  before { session_sign_in }
  let(:user) { Current.session.user }
  let(:campaign) { create(:campaign, user: user) }
  let(:note) { create(:note, notable: campaign, user: user) }
  let(:other_user) { create(:user) }
  let(:other_campaign) { create(:campaign, user: other_user) }
  let(:other_note) { create(:note, notable: other_campaign, user: other_user) }

  describe "GET /campaigns/:campaign_id/notes" do
    context "when user owns the campaign" do
      it "returns http success" do
        get campaign_notes_path(campaign)
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get campaign_notes_path(campaign)
        expect(response).to render_template(:index)
      end

      it "assigns campaign notes" do
        user_note = create(:note, notable: campaign, user: user)
        other_note = create(:note, notable: other_campaign, user: other_user)

        get campaign_notes_path(campaign)

        expect(assigns(:notes)).to include(user_note)
        expect(assigns(:notes)).not_to include(other_note)
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        get campaign_notes_path(other_campaign)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /campaigns/:campaign_id/notes/:id" do
    context "when user owns the campaign and note" do
      it "returns http success" do
        get campaign_note_path(campaign, note)
        expect(response).to have_http_status(:success)
      end

      it "renders the show template" do
        get campaign_note_path(campaign, note)
        expect(response).to render_template(:show)
      end

      it "assigns the note" do
        get campaign_note_path(campaign, note)
        expect(assigns(:note)).to eq(note)
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        get campaign_note_path(other_campaign, other_note)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /campaigns/:campaign_id/notes/new" do
    context "when user owns the campaign" do
      it "returns http success" do
        get new_campaign_note_path(campaign)
        expect(response).to have_http_status(:success)
      end

      it "renders the new template" do
        get new_campaign_note_path(campaign)
        expect(response).to render_template(:new)
      end

      it "assigns a new note" do
        get new_campaign_note_path(campaign)
        expect(assigns(:note)).to be_a_new(Note)
        expect(assigns(:note).notable).to eq(campaign)
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        get new_campaign_note_path(other_campaign)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /campaigns/:campaign_id/notes" do
    let(:valid_params) do
      {
        note: {
          title: "Campaign Session Notes",
          body: "The party encountered a group of goblins in the forest..."
        }
      }
    end

    let(:invalid_params) do
      {
        note: {
          title: "",
          body: ""
        }
      }
    end

    context "when user owns the campaign" do
      context "with valid parameters" do
        it "creates a new note" do
          expect {
            post campaign_notes_path(campaign), params: valid_params
          }.to change(Note, :count).by(1)
        end

        it "associates the note with the campaign and user" do
          post campaign_notes_path(campaign), params: valid_params
          note = Note.last
          expect(note.notable).to eq(campaign)
          expect(note.user).to eq(user)
        end

        it "redirects to the note show page" do
          post campaign_notes_path(campaign), params: valid_params
          expect(response).to redirect_to(campaign_note_path(campaign, Note.last))
        end

        it "sets a success notice" do
          post campaign_notes_path(campaign), params: valid_params
          expect(flash[:notice]).to eq("Note created successfully.")
        end
      end

      context "with invalid parameters" do
        it "does not create a note" do
          expect {
            post campaign_notes_path(campaign), params: invalid_params
          }.not_to change(Note, :count)
        end

        it "renders the new template" do
          post campaign_notes_path(campaign), params: invalid_params
          expect(response).to render_template(:new)
        end

        it "returns unprocessable content status" do
          post campaign_notes_path(campaign), params: invalid_params
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        post campaign_notes_path(other_campaign), params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /campaigns/:campaign_id/notes/:id/edit" do
    context "when user owns the campaign and note" do
      it "returns http success" do
        get edit_campaign_note_path(campaign, note)
        expect(response).to have_http_status(:success)
      end

      it "renders the edit template" do
        get edit_campaign_note_path(campaign, note)
        expect(response).to render_template(:edit)
      end

      it "assigns the note" do
        get edit_campaign_note_path(campaign, note)
        expect(assigns(:note)).to eq(note)
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        get edit_campaign_note_path(other_campaign, other_note)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /campaigns/:campaign_id/notes/:id" do
    let(:valid_params) do
      {
        note: {
          title: "Updated Campaign Notes",
          body: "Updated session notes with new information..."
        }
      }
    end

    let(:invalid_params) do
      {
        note: {
          title: "",
          body: ""
        }
      }
    end

    context "when user owns the campaign and note" do
      context "with valid parameters" do
        it "updates the note" do
          patch campaign_note_path(campaign, note), params: valid_params
          note.reload
          expect(note.title).to eq("Updated Campaign Notes")
          expect(note.body).to eq("Updated session notes with new information...")
        end

        it "redirects to the note show page" do
          patch campaign_note_path(campaign, note), params: valid_params
          expect(response).to redirect_to(campaign_note_path(campaign, note))
        end

        it "sets a success notice" do
          patch campaign_note_path(campaign, note), params: valid_params
          expect(flash[:notice]).to eq("Note updated successfully.")
        end
      end

      context "with invalid parameters" do
        it "does not update the note" do
          original_title = note.title
          patch campaign_note_path(campaign, note), params: invalid_params
          note.reload
          expect(note.title).to eq(original_title)
        end

        it "renders the edit template" do
          patch campaign_note_path(campaign, note), params: invalid_params
          expect(response).to render_template(:edit)
        end

        it "returns unprocessable content status" do
          patch campaign_note_path(campaign, note), params: invalid_params
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        patch campaign_note_path(other_campaign, other_note), params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /campaigns/:campaign_id/notes/:id" do
    context "when user owns the campaign and note" do
      it "deletes the note" do
        note_to_delete = create(:note, notable: campaign, user: user)
        expect {
          delete campaign_note_path(campaign, note_to_delete)
        }.to change(Note, :count).by(-1)
      end

      it "redirects to campaign notes index" do
        delete campaign_note_path(campaign, note)
        expect(response).to redirect_to(campaign_notes_path(campaign))
      end

      it "sets a success notice" do
        delete campaign_note_path(campaign, note)
        expect(flash[:notice]).to eq("Note deleted successfully.")
      end
    end

    context "when user does not own the campaign" do
      it "returns 404 not found" do
        delete campaign_note_path(other_campaign, other_note)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "authentication" do
    context "when user is not signed in" do
      before { allow(Current).to receive(:session).and_return(nil) }

      it "redirects to sign in page for index" do
        # Create a campaign first since we need a valid ID
        campaign_for_test = create(:campaign, user: create(:user))
        get campaign_notes_path(campaign_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for show" do
        # Create a campaign and note first since we need valid IDs
        campaign_for_test = create(:campaign, user: create(:user))
        note_for_test = create(:note, notable: campaign_for_test, user: create(:user))
        get campaign_note_path(campaign_for_test, note_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for new" do
        # Create a campaign first since we need a valid ID
        campaign_for_test = create(:campaign, user: create(:user))
        get new_campaign_note_path(campaign_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for create" do
        # Create a campaign first since we need a valid ID
        campaign_for_test = create(:campaign, user: create(:user))
        post campaign_notes_path(campaign_for_test), params: { note: { title: "Test", body: "Test" } }
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for edit" do
        # Create a campaign and note first since we need valid IDs
        campaign_for_test = create(:campaign, user: create(:user))
        note_for_test = create(:note, notable: campaign_for_test, user: create(:user))
        get edit_campaign_note_path(campaign_for_test, note_for_test)
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for update" do
        # Create a campaign and note first since we need valid IDs
        campaign_for_test = create(:campaign, user: create(:user))
        note_for_test = create(:note, notable: campaign_for_test, user: create(:user))
        patch campaign_note_path(campaign_for_test, note_for_test), params: { note: { title: "Test", body: "Test" } }
        expect(response).to redirect_to(new_session_path)
      end

      it "redirects to sign in page for destroy" do
        # Create a campaign and note first since we need valid IDs
        campaign_for_test = create(:campaign, user: create(:user))
        note_for_test = create(:note, notable: campaign_for_test, user: create(:user))
        delete campaign_note_path(campaign_for_test, note_for_test)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
