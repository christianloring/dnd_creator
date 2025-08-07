require "rails_helper"

RSpec.describe "home/dashboard" do
  it "displays all the widgets" do
    assign(:user_count, 2)

    render

    expect(rendered).to match("2")
    expect(rendered).to match("Characters aren't made yet")
  end
end
