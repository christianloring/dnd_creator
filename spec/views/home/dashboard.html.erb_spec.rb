require "rails_helper"

RSpec.describe "home/dashboard" do
  it "displays all the widgets" do
    assign(:user_count, 2)
    assign(:character_count, 3)

    render

    expect(rendered).to match("2")
    expect(rendered).to match("3")
  end
end
