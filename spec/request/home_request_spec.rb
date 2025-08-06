describe "Home Request", type: :request do
  describe "GET /index" do
    it "returns a successful response" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /dashboard" do
    it "returns a successful response for authenticated users" do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)

      get dashboard_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects unauthenticated users to the login page" do
      get dashboard_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
