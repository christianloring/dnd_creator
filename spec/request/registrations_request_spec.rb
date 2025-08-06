describe "Registrations Request", type: :request do
  describe "GET /new" do
    it "returns a successful response" do
      get new_registration_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    it "creates a user and redirects to the dashboard for valid parameters" do
      post registration_path, params: { user: { email_address: "example@gmail.com", password: "password123", password_confirmation: "password123" } }

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end

    it "renders the new template with unprocessable entity status for invalid parameters" do
      post registration_path, params: { user: { email_address: "", password: "password123", password_confirmation: "password123" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
  end
end
