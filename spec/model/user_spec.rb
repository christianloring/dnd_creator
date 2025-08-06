require 'rails_helper'

describe User do
  it "is valid with valid attributes" do
    expect(User.new(email_address: "test@example.com", password: "securepass")).to be_valid
  end

  it "is invalid without an email_address" do
    user = User.new(password: "securepass")

    expect(user).not_to be_valid
    expect(user.errors[:email_address]).to be_present
  end

  it "is invalid without a password" do
    user = User.new(email_address: "test@example.com")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to be_present
  end

  it "is invalid with a password less than 8 characters" do
    user = User.new(email_address: "test@example.com", password: "short")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to be_present
  end

  describe "when email_address is already taken" do
    before { create(:user, email_address: "test@example.com") }

    it "is invalid with a duplicate email_address" do
      user = User.new(email_address: "test@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to be_present
    end

    it "checks for case insensitivity" do
      user = User.new(email_address: "TEST@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to be_present
    end
  end

  describe "associations" do
    it "has many sessions" do
      user = User.create!(email_address: "test@example.com", password: "securepass")
      session = create(:session, user: user)

      expect(user.sessions).to include(session)
    end

    it "destroys associated sessions when user is deleted" do
      user = User.create!(email_address: "test@example.com", password: "securepass")
      create(:session, user: user)

      expect { user.destroy }.to change { Session.count }.by(-1)
    end
  end
end
