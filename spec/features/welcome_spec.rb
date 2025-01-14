require "rails_helper"

RSpec.describe "/", type: :feature do
  before(:each) do
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    visit root_path
  end

  describe "When a user visits the root path" do
    it "should be on the landing page ('/') and I see the title of the applications" do
      expect(page).to have_content("Viewing Party")
    end

    it "I see a button to create a new user" do
      expect(page).to have_button("Create a New User")

      click_button "Create a New User"

      expect(current_path).to eq(new_user_path)
    end

    # it "users who are logged in can see a list of existing users which links to the their dashboard" do
    #   user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")

    #   click_link "Log In"
    #   fill_in "Email", with: "lauren@gmail.com"
    #   fill_in "Password", with: "password1"
    #   click_button "Log In"

    #   visit root_path
    #   expect(page).to have_content("Existing Users")

    #   within "#user_#{@user_1.id}" do
    #     expect(page).to have_content(@user_1.email)
    #   end
    #   within "#user_#{@user_2.id}" do
    #     expect(page).to have_content(@user_2.email)
    #   end
    #   within "#user_#{@user_3.id}" do
    #     expect(page).to have_content(@user_3.email)
    #   end
    # end

    it "users who are logged in can see a list of email addresses of existing users" do
      user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")

      click_link "Log In"
      fill_in "Email", with: "lauren@gmail.com"
      fill_in "Password", with: "password1"
      click_button "Log In"

      visit root_path

      expect(page).to have_content("Existing Users")
      expect(page).to have_content(@user_1.email)
      expect(page).to have_content(@user_2.email)
      expect(page).to have_content(@user_3.email)
    end

    it "does not display a list of existing users to visitors who are not signed in" do
      expect(page).to_not have_content("Existing Users")
    end

    it "I see a link (Home) that will take me back to the welcome page" do
      expect(page).to have_link("Home")

      click_link("Home")

      expect(current_path).to eq(root_path)
    end

    it "allows users to log in with good credentials" do
      user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")
      expect(page).to have_link("Log In")
      click_link "Log In"

      expect(current_path).to eq("/login")
      expect(page).to have_field("Email")
      expect(page).to have_field("Password")
      expect(page).to have_button("Log In")

      fill_in "Email", with: "lauren@gmail.com"
      fill_in "Password", with: "password1"
      click_button "Log In"

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content("Welcome, #{user.email}!")
    end

    it "will not allow users to log in with bad credentials" do
      user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")
      expect(page).to have_link("Log In")
      click_link "Log In"

      fill_in "Email", with: "lauren@gmail.com"
      fill_in "Password", with: "password"
      click_button "Log In"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Invalid input")
    end

    it "allows users to log out" do
      user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")

      click_link "Log In"
      fill_in "Email", with: "lauren@gmail.com"
      fill_in "Password", with: "password1"
      click_button "Log In"

      visit root_path
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_button("Create a New User")
      expect(page).to have_link("Log Out")
      click_link "Log Out"

      expect(current_path).to eq(root_path)
      expect(page).to have_link("Log In")
    end

    it "does not allow vusitors who are not logged in to visit the /dashnoard page" do
      visit "/dashboard"
      expect(current_path).to eq(root_path)
      expect(page).to have_content("You must be logged in to do that")
    end

    it "redirects visitors who try to access any admin routes to the landing page" do
      visit "/admin/dashboard"
      expect(current_path).to eq(root_path)
      
      visit "/admin/users/#{@user_1.id}"
      expect(current_path).to eq(root_path)
    end

    it "redirects users who try to access any admin routes to the landing page" do
      user = User.create!(name: "Lauren", email: "lauren@gmail.com", password: "password1")

      click_link "Log In"
      fill_in "Email", with: "lauren@gmail.com"
      fill_in "Password", with: "password1"
      click_button "Log In"

      visit "/admin/dashboard"
      expect(current_path).to eq(root_path)
      
      visit "/admin/users/#{@user_1.id}"
      expect(current_path).to eq(root_path)
    end
  end
end
