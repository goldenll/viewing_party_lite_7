require "rails_helper"

describe "User Dashboard Page" do
  before :each do
    @user1 = User.create!(name: "Simon", email: "simon@gmail.com")

    visit "/users/#{@user1.id}"
  end

  it "should display the dashboard content" do
    expect(page).to have_content("#{@user1.name}'s Dashboard")
    expect(page).to have_button("Discover Movies")
    expect(page).to have_content("Viewing Parties")
  end

  it "should have a button to the user's discover page" do
    expect(page).to have_button("Discover Movies")
    click_button "Discover Movies"
    expect(page).to have_current_path("/users/#{@user1.id}/discover")
  end
end
