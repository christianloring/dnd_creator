require "rails_helper"

RSpec.describe "Passwords Request", type: :request do
  def password_reset_token_for(user)
    user.to_sgid(purpose: :password_reset).to_s
  end

  describe "GET /new" do
    it "responds successfully" do
      get new_password_path

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "redirects after submitting an email" do
      user = create(:user)

      post passwords_path, params: { email_address: user.email_address }

      expect(response).to be_redirect
    end
  end

  describe "GET /edit" do
    it "responds or redirects for a valid token" do
      user = create(:user)
      token = password_reset_token_for(user)

      get edit_password_path(token: token)

      expect(response).to be_redirect.or have_http_status(:ok)
    end

    it "redirects for an invalid token" do
      get edit_password_path(token: "invalid_token")

      expect(response).to be_redirect
    end
  end

  describe "PATCH /update" do
    it "redirects after successful password update" do
      user = create(:user)
      token = password_reset_token_for(user)

      patch password_path(token: token), params: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }

      expect(response).to be_redirect
    end

    it "redirects if password confirmation fails" do
      user = create(:user)
      token = password_reset_token_for(user)

      patch password_path(token: token), params: {
        password: "newpassword",
        password_confirmation: "wrongpassword"
      }

      expect(response).to be_redirect
    end
  end
end
