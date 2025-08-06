describe "Sessions Request", type: :request do
  describe "GET /new" do
    it "returns a successful response" do
      get new_session_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    it "creates a session and redirects to the dashboard for valid credentials" do
      user = create(:user)

      post session_path, params: { email_address: user.email_address, password: user.password }

      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /destroy" do
    it "terminates the session and redirects to the login page" do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)

      delete session_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_path)
    end
  end
end
